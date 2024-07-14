################################################################################
# SISMID Intro to R 2024
# Exercise 05 Solution
# Zane Billings and Amy Winter
################################################################################

# This exercise will focus on making base R graphics.

# Question 1 ###################################################################
# Part A: load in the "measles_final" dataset you created at the end of exercise
# 3.
meas <- readRDS(here::here("data", "measles_final.Rds"))

# Part B: choose one country from the dataset -- it can be either the same
# country you picked in Exercise 04, or a different one. Make a new dataframe
# containing only the records for that country.
# Recalculate the cases per 1000 population, reusing your code from exercise 4.
cc <- "IND"
meas_cc <- meas[meas$iso3c == cc, ]
meas_cc$total_pop <- as.numeric(meas_cc$total_pop)
meas_cc$cases_per_thousand <- meas_cc$Cases / meas_cc$total_pop * 1000

# Part C: make a line plot of cases per 1000 over time in the country you
# chose. You should only use records for MCV1 vaccine coverage to avoid
# accidentally double plotting anything for this plot.
# Make sure your plot has a title and good axis legends.
plot(
	meas_cc$time[meas_cc$vaccine_antigen == "MCV1"],
	meas_cc$cases_per_thousand[meas_cc$vaccine_antigen == "MCV1"],
	xlab = "Year",
	ylab = "Cases per 1000 individuals",
	main = "Measles incidence in India over time",
	type = "b"
)

# Part D: make a line plot of vaccine coverage over time in the country you
# chose. Make sure the lines for MCV1 and 2 are visually distinct using color,
# line type, or some other way. Give the plot good axis titles, and add a
# legend showing which line is MCV1 and 2.
plot(
	vaccine_coverage ~ time,
	data = subset(meas_cc, vaccine_antigen == "MCV1"),
	col = "dodgerblue2",
	pch = 1,
	lty = 1,
	type = "b",
	xlab = "Year",
	ylab = "Vaccine coverage"
)

points(
	vaccine_coverage ~ time,
	data = subset(meas_cc, vaccine_antigen == "MCV2"),
	col = "darkorange3",
	pch = 2,
	lty = 1,
	type = "b"
)

legend(
	"topleft",
	legend = c("MCV1", "MCV2"),
	pch = c(1, 2),
	col = c("dodgerblue2", "darkorange3"),
	lty = c(1, 1)
)

# Part E: now let's go back to the original dataset, with every country.
# Compute the incidence per 1000 people. Make a scatter
# plot with year on the x-axis, and LOG incidence per 1000 people on the y axis.
# Make sure you are only plotting the data for MCV1.
# Make sure the y-axis has logarithmic scaling -- you can ignore the warning
# about dropping points for now.
meas$total_pop <- as.numeric(meas$total_pop)
meas$cases_per_thousand <- meas$Cases / meas$total_pop * 1000
plot(
	meas$time[meas_cc$vaccine_antigen == "MCV1"],
	log10(meas$cases_per_thousand[meas_cc$vaccine_antigen == "MCV1"]),
	xlab = "Year",
	ylab = "Log10 incidence per 1000 people",
	main = "Incidence per 1000 people over time in all countries"
)

# Part F: use the lm() or glm() function to fit a simple regression line with
# log10(incidence per 1000 people) as the outcome and time as the exposure.
# Use the abline() function to add that regression line to the plot.
# HINT: you will need to subset the data to remove all the countries where the
# incidence was zero.
meas_mod <- lm(
	log10(cases_per_thousand) ~ time,
	data = subset(meas, vaccine_antigen == "MCV1" & cases_per_thousand > 0)
)

abline(meas_mod, lwd = 2, col = "red")
legend("bottomright", lty = 1, lwd = 2, col = "red", "Regression line")

# Part G: use the coef(), round(), and paste0() functions to make a character
# vector with one entry that looks like this: "y = 2.3 + 09.4 * x", but with
# the estimated coefficients from the model. Round the numbers to 2 decimal
# places. Then, use the text() function to add that text to the plot.
# HINT: for this model, the slope is positive. So you don't need to worry about
# whether the sign in the middle should be a + or a -.
eq <- paste0(
	"y = ", round(coef(meas_mod)[1], 2), " + ", round(coef(meas_mod)[2], 2),
	"x"
)
text(
	x = 1990, y = 1.4,
	labels = eq,
	col = "red",
	cex = 1.5
)

# Part H: for all countries, but for only the year 2010, make a plot showing
# two boxplots, one for MCV1 coverage and one for MCV2 coverage.
boxplot(
	vaccine_coverage ~ vaccine_antigen,
	data = subset(meas, time == 2010),
	xlab = "Vaccine antigen", ylab = "Vaccine coverage",
	main = "MCV Coverage across countries in 2010"
)

# Part I: using the layout() function, make a grid of four plots like the one
# you just made (i.e., each plot in the grid should have one boxplot for MCV1
# and one boxplot for MCV2). The top left plot should be for the year 2000,
# the top right plot for 2005, the bottom left for 2010, and the bottom right
# for 2015.
layout(matrix(1:4, ncol = 2, byrow = TRUE))
boxplot(
	vaccine_coverage ~ vaccine_antigen,
	data = subset(meas, time == 2000),
	xlab = "Vaccine antigen", ylab = "Vaccine coverage",
	main = "2000"
)
boxplot(
	vaccine_coverage ~ vaccine_antigen,
	data = subset(meas, time == 2005),
	xlab = "Vaccine antigen", ylab = "Vaccine coverage",
	main = "2005"
)
boxplot(
	vaccine_coverage ~ vaccine_antigen,
	data = subset(meas, time == 2010),
	xlab = "Vaccine antigen", ylab = "Vaccine coverage",
	main = "2010"
)
boxplot(
	vaccine_coverage ~ vaccine_antigen,
	data = subset(meas, time == 2015),
	xlab = "Vaccine antigen", ylab = "Vaccine coverage",
	main = "2015"
)

layout(1)

# Question 2 ###################################################################
# Part A: Load the diphtheria data set.
library(haven)
diph <- haven::read_sas(here::here("data", "Diphtheria_IgG_Serology.sas7bdat"))

# Part B: Make a histogram of the DP_antibody variable. Choose appropriate
# breaks, and make the axis labels and (optionally) title meaningful.
hist(
	diph$DP_antibody,
	ylab = "Diphtheria antibody level",
	main = NULL,
	breaks = seq(0, 1.6, 0.1)
)

# Part C: Make a histogram of the DP_antibody variable that distinguishes
# between the levels of DP_vacc somehow. You can either stack two
# histograms, or show overlapping histograms in different colors.
hist(
	diph$DP_antibody[diph$DP_vacc == 1],
	xlab = "Diphtheria antibody level",
	main = NULL,
	breaks = seq(0, 1.6, 0.1),
	col = adjustcolor("darkorange3", alpha.f = 0.3)
)
hist(
	diph$DP_antibody[diph$DP_vacc == 0],
	main = NULL,
	breaks = seq(0, 1.6, 0.1),
	col = adjustcolor("dodgerblue2", alpha.f = 0.3),
	add = TRUE
)

legend(
	"topright",
	c("Unvaccinated", "Vaccinated"),
	fill = c(
		adjustcolor("dodgerblue2", alpha.f = 0.3),
		adjustcolor("darkorange3", alpha.f = 0.3)
	)
)

# Part D: make a bar plot of DP infection status.
barplot(
	table(diph$DP_infection),
	xlab = "Diphtheria Infection Status",
	ylab = "Frequency"
)

# Part E: make a grouped bar plot, where DP infection status is on the x
# axis, but each vaccine group has its own bar -- there will be four bars
# total on the plot.
barplot(
	table(diph$DP_vacc, diph$DP_infection),
	xlab = "Diphtheria infection status",
	ylab = "Frequency",
	col = c("darkorchid4", "seagreen2"),
	legend.text = c("Unvaccinated", "Vaccinated"),
	args.legend = list(x = "topleft"),
	beside = TRUE
)

# Part E 1/2: Make the same plot but with a stacked bar chart instead of
# side-by-side / grouped.
barplot(
	table(diph$DP_vacc, diph$DP_infection),
	xlab = "Diphtheria infection status",
	ylab = "Frequency",
	col = c("darkorchid4", "seagreen2"),
	legend.text = c("Unvaccinated", "Vaccinated"),
	args.legend = list(x = "topleft"),
	beside = FALSE
)

# Part F: this is the last exercise but it has multiple parts! First,
# fit a logistic regression model where DP_infection is the outcome and
# DP_Antibody is the only predictor.
diph_mod <- glm(
	DP_infection ~ DP_antibody,
	data = diph,
	family = "binomial"
)
summary(diph_mod)

# Next, make a new data frame that has a single column named "DP_antibody".
# For the value of that column, make a sequence of numbers using seq() that
# goes from the minimum observed antibody level in our data, to the maximum
# observed level, and make the sequence 100 numbers long.
ab_range <- range(diph$DP_antibody)
grid_data <- data.frame(
	DP_antibody = seq(ab_range[1], ab_range[2], length.out = 100L)
)

# Now use the predict() function, passing in your fitted logistic regression
# model, and the data frame you just made as the newdata argument. Make sure
# you set the arguments type = "link" and se.fit = TRUE.
# HINT: you can look at ?predict.glm to get better help than if you just
# looked at ?predict !
raw_preds <- predict(
	diph_mod,
	newdata = grid_data,
	type = "link",
	se.fit = TRUE
)

# Next we'll turn our predictions into a data frame. Make a new data frame
# named "pred_data" with the following columns:
# DP_antibody: the sequence of numbers you generated before.
# preds: from the prediction object, this is $fit.
# se: from the prediction object, this is $se.fit.
pred_data <- data.frame(
	DP_antibody = grid_data$DP_antibody,
	preds = raw_preds$fit,
	se = raw_preds$se.fit
)

# Now add two more columns to "pred_data" like this:
# lwr = preds - 1.96 * se
# upr = preds + 1.96 * se
pred_data$lwr <- pred_data$preds - 1.96 * pred_data$se
pred_data$upr <- pred_data$preds + 1.96 * pred_data$se

# Right now all of our predictions and CIs are in log-odds units, which is
# too hard to interpret -- we want probability units. So, using the
# transform() function, apply the plogis() function to the preds, lwr, and upr
# columns of pred_data. All you need to know about plogis() is that it turns
# log odds ratios into probabilities.
pred_data2 <- transform(
	pred_data,
	preds = plogis(preds),
	lwr = plogis(lwr),
	upr = plogis(upr)
)

# Now we can make a plot showing off our logistic regression model! First,
# using the diph data set, make a scatterplot of DP infection vs antibody level.
# As usual, make sure the axis labels are nice.
plot(
	diph$DP_antibody,
	diph$DP_infection,
	xlab = "Diphtheria antibody level",
	ylab = "Diphtheria infection status"
)

# Now use the lines() function to add a line plot of pred_data$pred vs.
# pred_data$DP_antibody to the plot. Make the line red and dashed, and increase
# the lwd so it is thicker.
lines(
	pred_data2$DP_antibody,
	pred_data2$preds,
	col = "red",
	lty = 2,
	lwd = 2
)

# Now use the lines() function two more times: once to add the lwr variable
# (the lower bound of the confidence interval), and once to add the upr
# variable (the upper bound of the confidence interval). Make both of these
# lines red, DOTTED (lty = 3), and thinner than the middle line.
lines(
	pred_data2$DP_antibody,
	pred_data2$lwr,
	col = "red",
	lty = 3,
	lwd = 1.25
)

lines(
	pred_data2$DP_antibody,
	pred_data2$upr,
	col = "red",
	lty = 3,
	lwd = 1.25
)

################################################################################
# Now you'll have quite a nice plot of the logistic
# regression model you fit! If you want to keep improving the plot, you can
# try adding the odds ratio onto the plot, and adding a legend. Or you can
# try to add another variable to the model and make the plot. Good job
# completing this exercise!!
################################################################################
