################################################################################
# SISMID Intro to R 2024
# Exercise 04 Solution
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
meas <- readRDS("data/measles_final.Rds") 
#or
meas <- readRDS(here::here("data", "measles_final.Rds"))

# Part B: choose a country from the dataset to focus on, and make a new data
# frame containing only the records for that country. How many records does
# the country you picked have for MCV1 and MCV2? How many missing records does
# it have for cases? What about for vaccine coverage (in both antigens)?
cc <- "IND"
meas_cc <- meas[meas$iso3c == cc, ]

table(meas_cc$vaccine_antigen)

table(!is.na(meas_cc$Cases))

table(
	is.na(meas_cc$vaccine_coverage),
	meas_cc$vaccine_antigen,
	dnn = list("missing record", "antigen")
)

# Part C: Calculate the number of cases per 1,000 people for each year for
# the data for your country you chose. Make sure you add this as a column to
# your dataset. Note: you will need to convert the total_pop variable to a
# numeric variable first.
meas_cc$total_pop <- as.numeric(meas_cc$total_pop)
meas_cc$cases_per_thousand <- meas_cc$Cases / meas_cc$total_pop * 1000

# Part D: use the cut() function to group the years into groups for every
# decade. Save this variable as "decade" in your dataset. (Hint: you can use
# seq(1980, 2030, 10) to make the "breaks".) Make sure to use the arguments
# right = FALSE, so that the years 1980 - 1989 are in one group, and 1990 is
# in the next group. Also, make sure to use the "Labels" argument to make the
# values look nice!
meas_cc$decade <- cut(
	meas_cc$time,
	breaks = seq(1980, 2030, 10),
	labels = paste(seq(1980, 2020, 10), "-", c(seq(1990, 2020, 10), "2022")),
	right = FALSE
)

# Part E: Now use the aggregate() function to get the average vaccination
# coverage for each decade (for each vaccine antigen)
vac_by_decade <-
	aggregate(
		vaccine_coverage ~ vaccine_antigen + decade,
		data = meas_cc,
		FUN = mean,
		na.rm = TRUE
	)

# Part F: Now use the aggregate() function to get the average cases_per_thousand
# for each decade. Do this separately by vaccine_antigen as well, to avoid
# double counting some data in our summary statistics.
prev_by_decade <-
	aggregate(
		cases_per_thousand ~ vaccine_antigen + decade,
		data = meas_cc,
		FUN = mean,
		na.rm = TRUE
	)

# Part G: use the merge() function to combine the average vaccination coverage
# per decade with the average incidence by decade.
prev_vac_by_decade <-
	merge(
		vac_by_decade, prev_by_decade,
		by = c("vaccine_antigen", "decade")
	)

# Part H: install the package "tinytable". Then use the function
# tinytable::tt() on the result of Part G. This will give you a nice looking
# table that's almost ready for publication!
#install.packages("tinytable")
tinytable::tt(prev_vac_by_decade)

# If you want to read more about tinytable, you can see the documentation here
# https://vincentarelbundock.github.io/tinytable/
# to learn how to make this table publication ready. There are also other
# great table packages for R, see this page for some explanation.
# https://andreashandel.github.io/MADAcourse/content/module-data-presentation/tables-in-r.html

# Part I: Compute the Pearson's correlation on the vaccine coverage
# and cases per thousand. Make sure to include a confidence interval!
# Do this separately for MCV1 and MCV2 vaccines.
# Give a quick interpretation of the results for the country you picked.
cor.test(
	~ vaccine_coverage + cases_per_thousand,
	data = subset(meas_cc, vaccine_antigen == "MCV1")
)

cor.test(
	~ vaccine_coverage + cases_per_thousand,
	data = subset(meas_cc, vaccine_antigen == "MCV2")
)

# Q2: Diphtheria data ##########################################################
# Part A: Load the Diphtheria_IgG_Serology dataset into R.
library(haven)
diph <- haven::read_sas("data/Diphtheria_IgG_Serology.sas7bdat")
#OR
diph <- haven::read_sas(here::here("data", "Diphtheria_IgG_Serology.sas7bdat"))

# Part B: Make a 2x2 table of infection and vaccination. Format the labels so
# that the table is easy to read. Hint: you should make factor versions of
# the variables if you want them to print nicer.
table(
	factor(diph$DP_vacc, c(1, 0), c("+", "-")),
	factor(diph$DP_infection, c(1, 0), c("+", "-")),
	dnn = list("Vaccinated", "Infection")
)

# Part C: Let's calculate the crude odds ratio. Calculate the crude odds ratio
# by calculating the odds in the vaccinated group, and dividing by the odds
# in the unvaccinated group.
# Hint: odds = risk / (1 - risk) = mean(variable) / (1 - mean(variable)) for
# a dichotomous variable! Or you can use the table counts.

# First calculate the risks
r_v <- subset(diph, DP_vacc == 1)$DP_infection |> mean()
r_u <- subset(diph, DP_vacc == 0)$DP_infection |> mean()

# Now calculate the odds
o_v <- r_v / (1 - r_v)
o_u <- r_u / (1 - r_u)

# And the odds ratio
crude_or <- o_v / o_u

# Part D: we don't have to do it by hand every time! download the "epitools"
# package and look at the documentation/google to figure out how to calculate
# an odds ratio using this package.
# This also calculates the confidence interval for us!
install.packages("epitools")
epitools::epitab(
	x = diph$DP_vacc,
	y = diph$DP_infection,
	method = "oddsratio",
	verbose = TRUE
)

# Part E: fit a logistic regression model to the data using the glm() function
# to estimate the adjusted OR. The outcome should be DP_infection, the
# exposure is DP_vacc, and the covariates are age_months and group.
# Before you fit this model, create an indicator variable for being rural.
# Pass that into the model, instead of the group variable.
# We'll ignore the DP_antibody variable for now.
# Save the model to an object and look at the summary.
# Report the adjusted odds ratio for vaccination. Do you have an explanation
# for what might be going on here?

diph$rural <- ifelse(diph$group == "rural", 1, 0)

model_me <- glm(
	DP_infection ~ DP_vacc + rural + age_months,
	data = diph,
	family = binomial("logit")
)
summary(model_me)

# Part F: fit a logistic regression model with the same dependent and
# independent variables. This time, add an interaction term between vaccination
# status and age. Then use the anova() function on your fitted
# models to test whether the interaction term significantly improves the fit.
# Briefly report whether the interaction improves the model.
model_ie <- glm(
	DP_infection ~ DP_vacc + rural + age_months + age_months:DP_vacc,
	data = diph,
	family = binomial("logit")
)
summary(model_ie)

anova(model_ie, model_me, test = "LRT")

# Part G: for this question, choose the correct logistic regression model to
# use based on the results of the likelihood ratio test you just performed.
# Use the confint() function to get confidence intervals for your coefficients.
# Report the final estimates and confidence intervals for your adjusted
# odds ratio.
# HINT: remember that the coefficient is the log odds ratio. You need to
# exponentiate the estimates to get the OR. Use the exp() function.
# You can ignore the warning messages that might show up for now.
confint(model_ie)

exp(2.24)
exp(-0.21)
exp(5.94)

# Part H: again we don't have to do all of this by hand. Install the package
# 'epiDisplay' and use the function 'logistic.display()' on the model you
# chose. The 'epiDisplay' and 'epitools' package automate many of these
# epidemiology tasks for us!
# (Note that the default CI method for confint is slightly different, so your
# results might not be exactly the same. That's ok!)
install.packages("epiDisplay")
epiDisplay::logistic.display(model_ie)

# Part I: Final question for this model! Good job so far! Next we want to
# calculate the risk of infection for a specific individual. Let's say
# someone who is vaccinated, who is rural, and has an age in months of 60.
# Hint: first make a new data frame with this information. Then use the
# predict() function on your model, and pass that data frame as the 'newdata'
# argument. Set the argument `type = "response"`.
pred_data <- data.frame(
	DP_vacc = 1,
	DP_antibody = 0.4,
	rural = 1,
	age_months = 60
)

predict(model_me, newdata = pred_data, type = "response")

# Congratulations! You finished the exercise! ##################################
