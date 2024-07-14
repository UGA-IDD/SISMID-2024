################################################################################
# SISMID Intro to R 2024
# Exercise 03 Solution
# Zane Billings and Amy Winter
################################################################################

# In this exercise, we'll practice data cleaning using the measles datasets
# we've looked at previously.

# Question 1 ###################################################################
# Part A: Load in the MeaslesCases.csv data, and take a look at it to remind
# yourself of the structure.
cases <- read.csv(here::here("data", "MeaslesCases.csv"))
str(cases)

# Part B: Is this data in wide format or long format? Explain your answer.

# The data is in wide format because there are multiple columns that store
# the number of measles cases. Each year of data is a column, so the same
# variable is stored across multiple columns.

# Part C: use the reshape() function to edit this dataset so that you have
# one column for cases and one column for year.
cases_long <-
	reshape(
		cases,
		direction = "long",
		varying = paste0("X", 2023:1980),
		v.names = "Cases",
		idvar = names(cases)[1:3],
		times = 1980:2023
	)

# Part D: look at the str() of the long format data. What is new compared to
# what we usually see? Try calling reshape() again with only your long format
# data set as an argument.
str(cases_long)
reshape(cases_long)

# This data has an attr() field which adds additional metadata to it. This can
# be used by reshape() if we need to pivot the data back and forth.

# Part E: remove the description column from this data set.
cases_long$Description <- NULL

# Question 2 ###################################################################
# Part A: Load in the PopSize data using an appropriate package.
library(readxl)
popsize <- readxl::read_excel(here::here("data", "PopSize.xlsx"))

# Part B: Remove the "indicator name" and "indicator code" variables.
popsize$`Indicator Name` <- NULL
popsize$`Indicator Code` <- NULL

# Part C: reshape the dataset into long format.
# Make sure the times in the long format data are correct and the variable
# containing the population size data has an understandable name.
popsize_long <-
	reshape(
		popsize,
		direction = "long",
		varying = names(popsize)[3:66],
		v.names = "total_pop",
		idvar = names(popsize)[1:2],
		times = 1960:2023
	)

# Part D: rename any variable names that have spaces in them.
names(popsize_long)[names(popsize_long) == "Country Name"] <- "country_name"
names(popsize_long)[names(popsize_long) == "Country Code"] <- "country_code"

# Part E: Finally, Look at the str() of your new data frame at the end to
# double check everything.
str(popsize_long)

# Question 3 ###################################################################
# Part A: Read in the MeaslesVaccinationCoverage.csv data set.
vc <- read.csv(here::here("data", "MeaslesVaccinationCoverage.csv"))

# Part B:
# Merge together the (long format) cases dataset and the vaccination coverage
# dataset. Set the `all` argument to be TRUE (i.e., do a full join).
# You will need to specify the "by.x" and "by.y" arguments correctly.
cases_vc <-
	merge(
		cases_long, vc,
		by.x = c("iso3c", "time"),
		by.y = c("CODE", "YEAR"),
		all = TRUE
	)

# Part C:
# Merge the previous cases/coverage dataset with the long form of the popsize
# dataset. Make sure you include all years/countries with records in the
# cases/coverage dataset but do NOT include years/countries from the popsize
# dataset that are unused. (I.e. if x = cases/coverage dataset, all.x = TRUE
# and all.y = FALSE).
cases_vc_pop <-
	merge(
		cases_vc, popsize_long,
		by.x = c("iso3c", "time"),
		by.y = c("country_code", "time"),
		all.x = TRUE
	)

# Part D: notice that you now have three variables that contain country names.
# Keep the variable "Country...Region" and get rid of the other two. Then,
# rename that variable to "country".
# Then, remove the "ANTIGEN_DESCRIPTION" column, and rename any columns that
# are all uppercase to have better formatted names.
cases_vc_pop$country_name <- NULL
cases_vc_pop$NAME <- NULL
names(cases_vc_pop)[names(cases_vc_pop) == "Country...Region"] <- "country"

cases_vc_pop$ANTIGEN_DESCRIPTION <- NULL
names(cases_vc_pop)[names(cases_vc_pop) == "ANTIGEN"] <- "vaccine_antigen"
names(cases_vc_pop)[names(cases_vc_pop) == "COVERAGE"] <- "vaccine_coverage"

# Part E: sort the dataset by country code, then by year, then by the variable
# containig the MCV1/MCV2 information (whatever you renamed it).
# Hint: use the order() function.
sort_order <-
	order(
		cases_vc_pop$iso3c, cases_vc_pop$time, cases_vc_pop$vaccine_antigen
	)
meas_sorted <- cases_vc_pop[sort_order, ]

# Part F: remove all of the countries where the MCV1/MCV2 variable is missing.
meas_clean <- meas_sorted[!is.na(meas_sorted$vaccine_antigen), ]

# Part G: if you look at all of the country names in the dataset, you will see
# that some are NA.

# Part G: use some of the functions we've learned to look at your dataset
# and make sure it looks OK. Then answer these questions.
# - How many rows are there in the final data set?
# - How many different countries are there in the final data set?
# - What year did MCV2 first start being reported in the data? (Hint:
#    use the table() function.)
# - How many countries have observations in every year of the data set? (Hint:
#    use the table() function, and then use rowSums() on the table.)

nrow(meas_clean)
length(unique(meas_clean$country))
table(meas_clean$time, meas_clean$vaccine_antigen) # The answer is 2000

year_counts_per_country <-
	table(meas_clean$country, meas_clean$time) |>
	rowSums()

max_years <- max(year_counts_per_country)

names(year_counts_per_country)[year_counts_per_country == max_years] |>
	length()

# Part F: save your cleaned dataset to a .Rds file in your data directory!
# Name it "measles_final.Rds".
saveRDS(meas_clean, here::here("data", "measles_final.Rds"))

#### Congratulations on finishing exercise 3! This one was tough but look at
# all the cool and useful stuff you've already learned to do!
