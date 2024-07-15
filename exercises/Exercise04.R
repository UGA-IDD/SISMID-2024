################################################################################
# SISMID Intro to R 2024
# Exercise 04
# Zane Billings and Amy Winter
################################################################################

# This exercise will focus on variable summarization and basic statistics with
# R using two different infectious disease datasets.

# This is a long exercise! We recommend that you try all of the questions when
# you have time. But during class, you should focus on one of the two questions;
# choose which one interests you more.
# Q1 is about exploring the measles data you cleaned last time and making
# a table that is almost publication-ready.
# Q2 is about exploring diphtheria serosurvey data and calculating crude and
# adjusted odds ratios.

# Q1: Measles data #############################################################
# Part A: Load the "measles_final" dataset you created at the end of exercise 3.
# If you didn't finish exercise 3, you can download the finished Rds file from
# the course website and start there.


# Part B: choose a country from the dataset to focus on, and make a new data
# frame containing only the records for that country. How many records does
# the country you picked have for MCV1 and MCV2? How many missing records does
# it have for cases? What about for vaccine coverage (in both antigens)?


# Part C: Calculate the number of cases per 1,000 people for each year for
# the data for your country you chose. Make sure you add this as a column to
# your dataset. Note: you will need to convert the total_pop variable to a
# numeric variable first.


# Part D: use the cut() function to group the years into groups for every
# decade. Save this variable as "decade" in your dataset. (Hint: you can use
# seq(1980, 2030, 10) to make the "breaks".) Make sure to use the arguments
# right = FALSE, so that the years 1980 - 1989 are in one group, and 1990 is
# in the next group. Also, make sure to use the "Labels" argument to make the
# values look nice!

# Part E: Now use the aggregate() function to get the average vaccination
# coverage for each decade (for each vaccine antigen)


# Part F: Now use the aggregate() function to get the average cases_per_thousand
# for each decade. Do this separately by vaccine_antigen as well, to avoid
# double counting some data in our summary statistics.


# Part G: use the merge() function to combine the average vaccination coverage
# per decade with the average incidence by decade.


# Part H: install the package "tinytable". Then use the function
# tinytable::tt() on the result of Part G. This will give you a nice looking
# table that's almost ready for publication!
# install.packages(tinytable)


# If you want to read more about tinytable, you can see the documentation here
# https://vincentarelbundock.github.io/tinytable/
# to learn how to make this table publication ready. There are also other
# great table packages for R, see this page for some explanation.
# https://andreashandel.github.io/MADAcourse/content/module-data-presentation/tables-in-r.html

# Part I: Compute the Pearson's correlation on the vaccine coverage
# and cases per thousand. Make sure to include a confidence interval!
# Do this separately for MCV1 and MCV2 vaccines.
# Give a quick interpretation of the results for the country you picked.


# Q2: Diphtheria data ##########################################################
# Part A: Load the Diphtheria_IgG_Serology dataset into R.


# Part B: Make a 2x2 table of infection and vaccination. Format the labels so
# that the table is easy to read. Hint: you should make factor versions of
# the variables if you want them to print nicer.


# Part C: Let's calculate the crude odds ratio. Calculate the crude odds ratio
# by calculating the odds in the vaccinated group, and dividing by the odds
# in the unvaccinated group.
# Hint: odds = risk / (1 - risk) = mean(variable) / (1 - mean(variable)) for
# a dichotomous variable! Or you can use the table counts.


# Part D: we don't have to do it by hand every time! download the "epitools"
# package and look at the documentation/google to figure out how to calculate
# an odds ratio using this package.
# This also calculates the confidence interval for us!


# Part E: fit a logistic regression model to the data using the glm() function
# to estimate the adjusted OR. The outcome should be DP_infection, the
# exposure is DP_vacc, and the covariates are age_months and group.
# Before you fit this model, create an indicator variable for being rural.
# Pass that into the model, instead of the group variable.
# We'll ignore the DP_antibody variable for now.
# Save the model to an object and look at the summary.
# Report the adjusted odds ratio for vaccination. Do you have an explanation
# for what might be going on here?


# Part F: fit a logistic regression model with the same dependent and
# independent variables. This time, add an interaction term between vaccination
# status and age. Then use the anova() function on your fitted
# models to test whether the interaction term significantly improves the fit.
# Briefly report whether the interaction improves the model.


# Part G: for this question, choose the correct logistic regression model to
# use based on the results of the likelihood ratio test you just performed.
# Use the confint() function to get confidence intervals for your coefficients.
# Report the final estimates and confidence intervals for your adjusted
# odds ratio.
# HINT: remember that the coefficient is the log odds ratio. You need to
# exponentiate the estimates to get the OR. Use the exp() function.
# You can ignore the warning messages that might show up for now.


# Part H: again we don't have to do all of this by hand. Install the package
# 'epiDisplay' and use the function 'logistic.display()' on the model you
# chose. The 'epiDisplay' and 'epitools' package automate many of these
# epidemiology tasks for us!
# (Note that the default CI method for confint is slightly different, so your
# results might not be exactly the same. That's ok!)
# install.packages(epiDisplay)


# Part I: Final question for this model! Good job so far! Next we want to
# calculate the risk of infection for a specific individual. Let's say
# someone who is vaccinated, with an antibody value of 0.4, a group value of
# rural, and an age in months of 60.
# Hint: first make a new data frame with this information. Then use the
# predict() function on your model, and pass that data frame as the 'newdata'
# argument. Set the argument `type = "response"`.


# Congratulations! You finished the exercise! ##################################
