## 2 July 2024
## Creating dataset 1 for exercises
## Aggregate data 

## Objective:
## Create three csv files of wide form datat I will combine into an excel document with different sheets
## Measles Cases, Measles Vaccination Coverage, Population size

library(readxl)
library(countrycode)
library(dplyr)
library(tidyverse)

cases <- read_excel("./data/raw/Measles reported cases and incidence 2024-03-07 23-26 UTC.xlsx", sheet="Sheet1")
cases <- cases %>% 
  mutate(iso3c = countrycode(`Country / Region`, "country.name", "iso3c")) %>%
  rename(Description = Disease) %>% 
  mutate(Description = "Number of Measles Cases") %>%
  relocate(iso3c, .before = Description) %>%
  pivot_longer(cols=-c(`Country / Region`, "iso3c", "Description"), names_to = "year", values_to="number") %>%
  mutate(number = as.numeric(gsub(",", "", number))) %>%
  pivot_wider(names_from=year, values_from=number)
write.csv(cases, file="./data/MeaslesCases.csv", row.names = FALSE)

coverage <- read_excel("./data/raw/Measles vaccination coverage 2024-03-07 21-54 UTC.xlsx", sheet="Sheet1")
coverage <- coverage %>%
  filter(COVERAGE_CATEGORY == "WUENIC") %>% 
  select(-c(GROUP, TARGET_NUMBER, DOSES, COVERAGE_CATEGORY, COVERAGE_CATEGORY_DESCRIPTION))
write.csv(coverage, file="./data/MeaslesVaccinationCoverage.csv", row.names = FALSE)


population <- read_excel("./data/raw/API_SP.POP.TOTL_DS2_en_excel_v2_316404.xls")
write.csv(population, file="./data/PopulationSize.csv", row.names = FALSE)



## Combine
cas <- cases %>%
  select(-c(`Country / Region`, "Description")) %>%
  pivot_longer(cols=-c("iso3c"), names_to = "year", values_to="measles_cases")
pop <- population %>%
  select(-c(`Country Name`, `Indicator Code`, `Indicator Name`)) %>%
  pivot_longer(cols=-c(`Country Code`), names_to = "year", values_to="population") %>%
  rename(iso3c=`Country Code`)
cov <- coverage %>%
  select(-c(NAME, ANTIGEN_DESCRIPTION)) %>%
  pivot_wider(names_from= ANTIGEN, values_from=COVERAGE) %>%
  rename(iso3c = CODE, MCV1_coverage = MCV1, MCV2_coverage = MCV2, year=YEAR) %>%
  mutate(year = as.character(year))
  
df <- left_join(left_join(cas, pop), cov)
write.csv(df, file="./data/MeaslesClean.csv", row.names = FALSE)
