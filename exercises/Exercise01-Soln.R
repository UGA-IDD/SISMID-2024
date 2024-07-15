################################################################################
# SISMID Intro to R 2024
# Exercise 01 Solution
# Zane Billings and Amy Winter
################################################################################

# For this question, we want to load a data set that our friend give us in
# SAS format. You should download the file "Diphtheria_IgG_Serology.sas7bdat"
# to your data directory.

# Part A: use google to find a package that can allow you to read a SAS
# (sas7bdat) file into R. Install and load that package.
install.packages("haven")
library(haven)

# Part B: read in the data set.
diph <- haven::read_sas(here::here("data", "Diphtheria_IgG_Serology.sas7bdat"))

# Part C: Now use a function to read in the CSV version of the data set.
diph2 <- read.csv(here::here("data", "Diphtheria_IgG_Serology.csv"))

# Part D: Write out the diphtheria file in tab delimited format.
# Make sure you don't include a row name column.
write.table(diph2, file = "data/Diph.tsv", sep = "\t")

# Congratulations, you finished the exercise! ##################################
