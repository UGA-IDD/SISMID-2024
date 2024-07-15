################################################################################
# SISMID Intro to R 2024
# Exercise 02 Solution
# Zane Billings and Amy Winter
################################################################################

# For this exercise, you should try to complete all three questions in order.

# Question 1 ###################################################################
# Part A: create a numeric vector with the values 1, 2, 5, 1, 7, and 8. Name
# the vector q1_vec.
q1_vec <- c(1, 2, 5, 1, 7, 8)

# Part B: check the type of the vector and make sure it is numeric.
class(q1_vec)

# Part C: convert the type of the vector to integer, and check the type after.
# Save the integer vector to a variable named q1_vec_int.
q1_vec_int <- as.integer(q1_vec)
class(q1_vec_int)

# Part D: get the mean and standard deviation of q1_vec.
mean(q1_vec)
sd(q1_vec)

# Part E: add a new element, 2.443, to q1_vec_int. Then check the class of
# that object again. Can you explain what happened?
q1_vec_int <- c(q1_vec_int, 2.443)
class(q1_vec_int)

# Part F: create a new vector named q1_vec_chr by adding the term "beans" to
# the end of q1_vec. Then try to take the mean. Why can't you take the mean
# of this object?
q1_vec_chr <- c(q1_vec, "beans")
mean(q1_vec_chr)

# Question 2 ###################################################################
# For this question, we'll use the measles vaccination coverage dataset.
# Part A: load the file "MeaslesVaccinationCoverage.csv" into R.
meas <- read.csv(here::here("data", "MeaslesVaccinationCoverage.csv"))

# Part B: inspect the data set with str() and other functions to get a sense of
# what is in the data.
str(meas)
summary(meas)

# Part C: how many rows and columns are in this data set?
dim(meas)
ncol(meas)
nrow(meas)

# Part D: convert the character variables in the dataset into factors. Then
# look at the summary() again. How many observations are for the MCV1 vaccine
# and how many are for the MCV2 vaccine?
meas <- meas |>
	transform(
		CODE = factor(CODE),
		NAME = factor(NAME),
		ANTIGEN = factor(ANTIGEN),
		ANTIGEN_DESCRIPTION = factor(ANTIGEN_DESCRIPTION)
	)
summary(meas)

# Part E: does each country in the dataset have the same number of observations?
table(meas$NAME) |> unique()

# Part F: which country has the most missing observations for vaccine coverage?
# How many missing values does it have?
# HINT: after you create a table, you can use [ to index specific columns of
# the created table.
missing_table <- table(meas$NAME, is.na(meas$COVERAGE))
which.max(missing_table[, 2])
max(missing_table[, 2])

# Part G: How many countries have 99% MCV2 coverage in 2022?
subset(meas, ANTIGEN == "MCV2" & COVERAGE == 99 & YEAR == 2022)

# BONUS QUESTION: among countries with no missing data points for vaccine
# coverage, which country had the lowest coverage for MCV1 in 2022? What about
# MCV2?
# HINT 1: first make a vector of all of the country names where the count of
# missing tables was 0. You could use the table you made earlier, or you can use
# the any() function. Then use that vector along with the %in% logical operator
# to filter the dataset.
# HINT 2: Once you have filtered the data to get only countries with no
# missing values, filter it again to get only the data with 2022 data and
# MCV1, and use indexing and min() to find the lowest coverage country. Then
# repeat with MCV2.
no_missing_countries <- names(which(missing_table[, 2] == 0))
meas_nmc <- meas[meas$NAME %in% no_missing_countries, ]
mcv1 <- subset(meas_nmc, (YEAR == 2022) & (ANTIGEN == "MCV1"))
mcv1[which.min(mcv1$COVERAGE), ]

mcv2 <- subset(meas_nmc, (YEAR == 2022) & (ANTIGEN == "MCV2"))
mcv2[which.min(mcv2$COVERAGE), ]

# Question 3 ###################################################################
# For this question, we'll work with the "MeaslesCases.csv" data set.
# Part A: read in the data set, and use the functions we've learned so far to
# take a look at it.
cases <- read.csv(here::here("data", "MeaslesCases.csv"))
summary(cases)
str(cases)
head(cases)

# Part B: we'll also need a second data set for this problem. We'll discuss
# a more efficient way to solve this problem in the next module. But for now,
# go ahead and load `countries-regions.csv` as well, and take a look.
cr <- read.csv(here::here("data", "countries-regions.csv"))
str(cr)

# Part C: using the countries-regions dataset, make a character vector that
# contains the `alpha.3` country code of every country in the "Oceania" region.
oceania_countries <- cr[cr$region == "Oceania", "alpha.3"]

# Part D: get the total number of cases across countries in Oceania for every
# year recorded in the MeaslesCases data set. Ignore missing data values.
# Which year had the highest number of measles cases in Oceania?
# Which year had the lowest number of cases?
# HINT 1: First subset the cases data so you only have the rows for countries in
# Oceania, and you only have the columns which are cases in each year.
# HINT 2: you can select a sequence of adjacent columns in the dataset using
# the : (colon) operator, e.g. to get all of the years, you can use
# X2023:X1980 as the "select" argument in subset().
# HINT 3: After you subset the data, you can get the sums across each column
# ( e.g. with colSums() ) and
# look at the highest and lowest values.
colSums(
	subset(cases, iso3c %in% oceania_countries, X2023:X1980),
	na.rm = TRUE
)

# BONUS PROBLEM Part E: Are there any countries where the average number of
# measles cases from
# 2020 - 2023 for that country is higher than the average number of measles
# cases from 1997 - 2000?
# Only consider countries with no missing values during these periods.
# HINT 1: you don't need to do anything with the NAs, R will propagate them for
# you and they will stay NA when you do a logical operator.)
# HINT 2: first make two subsetted data sets, one with the years 2020 - 2023,
# and one with the years 1997 - 2000. Then calculate the rowMeans() of each
# of those subsets.
period1 <- cases[, c("X2023", "X2022", "X2021", "X2020")]
period2 <- cases[, c("X2000", "X1999", "X1998", "X1997")]
cases[which(rowMeans(period1) > rowMeans(period2)), "Country...Region"]

# CONGRATULATIONS! You finished the second exercise! This one was a lot tougher
# than the first one!
