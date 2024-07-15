################################################################################
# SISMID Intro to R 2024
# Exercise 05
# Zane Billings and Amy Winter
################################################################################

# This exercise will focus on making base R graphics.
# Like exercise 4, this exercise is quite long. While we think both questions
# can provide you with valuable experience, during class you should focus on
# either Q1 or Q2 depending on what interests you.
# In Q1, you will make plots of vaccine coverage and incidence with the
# measles data.
# in Q2, you will explore the diphtheria dataset and fit a logistic regression
# model, which you can use to make a nice but difficult plot.

# Question 1 ###################################################################
# Part A: load in the "measles_final" dataset you created at the end of exercise
# 3. Remember you can download this from the course website if you need to.


# Part B: choose one country from the dataset -- it can be either the same
# country you picked in Exercise 04, or a different one. Make a new dataframe
# containing only the records for that country.
# Recalculate the cases per 1000 population, reusing your code from exercise 4.


# Part C: make a line plot of cases per 1000 over time in the country you
# chose. You should only use records for MCV1 vaccine coverage to avoid
# accidentally double plotting anything for this plot.
# Make sure your plot has a title and good axis legends.


# Part D: make a line plot of vaccine coverage over time in the country you
# chose. Make sure the lines for MCV1 and 2 are visually distinct using color,
# line type, or some other way. Give the plot good axis titles, and add a
# legend showing which line is MCV1 and 2.
# HINT: create two subsets of the data, one for MCV1 and one for MCV2.
# Then make a plot with one of the subsets (make sure you set the xlim and
# ylim arguments correctly). Then, use the points() function to add the
# data for the second subset. Make sure you make them distinguishable using
# shapes and/or colors, and add a legend!!


# Part E: now let's go back to the original dataset, with every country.
# Compute the incidence per 1000 people. Make a scatter
# plot with year on the x-axis, and LOG incidence per 1000 people on the y axis.
# Make sure you are only plotting the data for MCV1.
# Make sure the y-axis has logarithmic scaling -- you can ignore the warning
# about dropping points for now.


# Part F: use the lm() or glm() function to fit a simple regression line with
# log10(incidence per 1000 people) as the outcome and time as the exposure.
# Use the abline() function to add that regression line to the plot.
# HINT: you will need to subset the data to remove all the countries where the
# incidence was zero.


# Part G: use the coef(), round(), and paste0() functions to make a character
# vector with one entry that looks like this: "y = 2.3 + 09.4 * x", but with
# the estimated coefficients from the model. Round the numbers to 2 decimal
# places. Then, use the text() function to add that text to the plot.
# HINT: for this model, the slope is positive. So you don't need to worry about
# whether the sign in the middle should be a + or a -.

# Part H: for all countries, but for only the year 2010, make a plot showing
# two boxplots, one for MCV1 coverage and one for MCV2 coverage.


# Part I: using the layout() function, make a grid of four plots like the one
# you just made (i.e., each plot in the grid should have one boxplot for MCV1
# and one boxplot for MCV2). The top left plot should be for the year 2000,
# the top right plot for 2005, the bottom left for 2010, and the bottom right
# for 2015.
# HINT: the correct syntax for the layout function for this question is
# layout(matrix(1:4, ncol = 2, byrow = TRUE)).
# HINT: YOu will need four boxplot() calls in this exercise.


# IMPORTANT: after you finish your plot, you should call layout(1) to reset
# to the default layout.
# You can use par(mfrow = ...) instead of layout() for this question if you
# want to.

# Question 2 ###################################################################
# Part A: Load the diphtheria data set.


# Part B: Make a histogram of the DP_antibody variable. Choose appropriate
# breaks, and make the axis labels and (optionally) title meaningful.


# Part C: Make a histogram of the DP_antibody variable that distinguishes
# between the levels of DP_vacc somehow. You can either stack two
# histograms, or show overlapping histograms in different colors.
# HINT: you can just adjustcolor("color", alpha.f = number from 0 to 1) to
# make a color partially transparent.
# HINT: you can set the argument "add = TRUE" to a histogram to plot the
# new histogram directly on top of whatever plot is currently being shown
# in the graphics window.


# Part D: make a bar plot of DP infection status.


# Part E: make a grouped bar plot, where DP infection status is on the x
# axis, but each vaccine group has its own bar -- there will be four bars
# total on the plot.
# HINT: use google or the help page to find the argument you need to change
# to get side by side bars.


# Part E 1/2: Make the same plot but with a stacked bar chart instead of
# side-by-side / grouped.


# Part F: this is the last exercise but it has multiple parts! First,
# fit a logistic regression model where DP_infection is the outcome and
# DP_Antibody is the only predictor.
# Make sure you look at the summary.



# Next, make a new data frame that has a single column named "DP_antibody".
# For the value of that column, make a sequence of numbers using seq() that
# goes from the minimum observed antibody level in our data, to the maximum
# observed level, and make the sequence 100 numbers long.
# HINT: read the help page for the seq() function to figure out which three
# arguments you need to specify. Your data frame code will look something like
# grid_data <- data.frame(DP_antibody = seq(...)).


# Now use the predict() function, passing in your fitted logistic regression
# model, and the data frame you just made as the newdata argument. Make sure
# you set the arguments type = "link" and se.fit = TRUE.
# HINT: you can look at ?predict.glm to get better help than if you just
# looked at ?predict !


# Next we'll turn our predictions into a data frame. Make a new data frame
# named "pred_data" with the following columns:
# DP_antibody: the sequence of numbers you generated before.
# preds: from the prediction object, this is $fit.
# se: from the prediction object, this is $se.fit.
# HINT: use the data.frame() function.


# Now add two more columns to "pred_data" like this:
# lwr = preds - 1.96 * se
# upr = preds + 1.96 * se
# HINT: you can do this with pred_data$lwr <- ..., or with the transform()
# function.


# Right now all of our predictions and CIs are in log-odds units, which is
# too hard to interpret -- we want probability units. So, using the
# transform() function, apply the plogis() function to the preds, lwr, and upr
# columns of pred_data. All you need to know about plogis() is that it turns
# log odds ratios into probabilities.
# HINT: if you don't want to use the transform function, you could also do
# pred_data$column <- plogis(pred_data$column).


# Now we can make a plot showing off our logistic regression model! First,
# using the diph data set, make a scatterplot of DP infection vs antibody level.
# As usual, make sure the axis labels are nice.


# Now use the lines() function to add a line plot of pred_data$pred vs.
# pred_data$DP_antibody to the plot. Make the line red and dashed, and increase
# the lwd so it is thicker.


# Now use the lines() function two more times: once to add the lwr variable
# (the lower bound of the confidence interval), and once to add the upr
# variable (the upper bound of the confidence interval). Make both of these
# lines red, DOTTED (lty = 3), and thinner than the middle line.


################################################################################
# Now you'll have quite a nice plot of the logistic
# regression model you fit! If you want to keep improving the plot, you can
# try adding the odds ratio onto the plot, and adding a legend. Or you can
# try to add another variable to the model and make the plot. Good job
# completing this exercise!!
################################################################################
