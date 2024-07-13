################################################################################
# SISMID Intro to R 2024
# Exercise 03
# Zane Billings and Amy Winter
################################################################################

# In this exercise, we'll practice data cleaning using the measles datasets
# we've looked at previously.

# Question 1 ###################################################################
# Part A: Load in the MeaslesCases.csv data, and take a look at it to remind
# yourself of the structure.


# Part B: Is this data in wide format or long format? Explain your answer.


# Part C: use the reshape() function to edit this dataset so that you have
# one column for cases and one column for year.


# Part D: look at the str() of the long format data. What is new compared to
# what we usually see? Try calling reshape() again with only your long format
# data set as an argument.


# Part E: remove the description column from this data set.


# Question 2 ###################################################################
# Part A: Load in the PopSize data using an appropriate package.


# Part B: Remove the "indicator name" and "indicator code" variables.


# Part C: reshape the dataset into long format.
# Make sure the times in the long format data are correct and the variable
# containing the population size data has an understandable name.


# Part D: rename any variable names that have spaces in them.


# Part E: Finally, Look at the str() of your new data frame at the end to
# double check everything.


# Question 3 ###################################################################
# Part A: Read in the MeaslesVaccinationCoverage.csv data set.


# Part B:
# Merge together the (long format) cases dataset and the vaccination coverage
# dataset. Set the `all` argument to be TRUE (i.e., do a full join).
# You will need to specify the "by.x" and "by.y" arguments correctly.


# Part C:
# Merge the previous cases/coverage dataset with the long form of the popsize
# dataset. Make sure you include all years/countries with records in the
# cases/coverage dataset but do NOT include years/countries from the popsize
# dataset that are unused. (I.e. if x = cases/coverage dataset, all.x = TRUE
# and all.y = FALSE).


# Part D: notice that you now have three variables that contain country names.
# Choose one of them to keep, delete the other two, and rename the new variable
# to "country".
# Then, remove the "ANTIGEN_DESCRIPTION" column, and rename any columns that
# are all uppercase to have better formatted names.


# Part E: sort the dataset by country code, then by year, then by the variable
# containig the MCV1/MCV2 information (whatever you renamed it).
# Hint: use the order() function.


# Part F: remove all of the countries where the MCV1/MCV2 variable is missing.


# Part G: use some of the functions we've learned to look at your dataset
# and make sure it looks OK. Then answer these questions.
# - How many rows are there in the final data set?
# - How many different countries are there in the final data set?
# - What year did MCV2 first start being reported in the data? (Hint:
#    use the table() function.)
# - How many countries have observations in every year of the data set? (Hint:
#    use the table() function, and then use rowSums() on the table.)


# Part F: save your cleaned dataset to a .Rds file in your data directory!
# Name it "measles_final.Rds".


#### Congratulations on finishing exercise 3! This one was tough but look at
# all the cool and useful stuff you've already learned to do!
