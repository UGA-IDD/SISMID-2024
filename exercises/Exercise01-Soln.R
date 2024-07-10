################################################################################
# SISMID Intro to R 2024
# Exercise 01 Solution
# Zane Billings and Amy Winter
################################################################################

# Before you start the exercise, make sure you create an R Project to hold all
# of your materials for this class! Your R Project should contain (at least)
# a Code directory and a Data directory. You could also add, for example, a
# Results and a Notes directory to save various files.

# Also, make sure you have your R project for this course OPEN in RStudio.
# If you look in the top right corner, you should see a cube with the name of
# your R project next to it. If it says "New Project" then your R Project is
# NOT open and your working directory will be wrong!

# QUESTION ZERO: print the working directory and make sure it makes your
# project working directory!

#### Question 1 ####
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

# Because we added a numeric value that is not an integer, the entire vector
# became numeric because vectors can only contain one type of element.

#### Question 2 ####
# Part A: create a character vector with six elements. Name it q2_vec.
q2_vec <- c("A", "B", "C", "Bears", "Beets", "Battlestar Galactica")

# Part B: verify the class and length of q2_vec using functions.
class(q2_vec)
length(q2_vec)

# Part C: check whether the length of q2_vec is the same as the length of q1_vec
# using functions.
length(q1_vec) == length(q2_vec)

# Part D: if you concentate q1_vec and q2_vec, what type will the output be?
# Do it, save the result with whatever variable name you like, and check.
# Can you explain the answer?
q1q2_vec <- c(q1_vec, q2_vec)
class(q1q2_vec)

# Part E: What happens if you try to take the mean of q2_vec? Can you explain
# the result?
mean(q2_vec)

# The result is NA and we get a warning message telling us that the argument
# is not numeric or logical. This is because it doesn't make sense to take the
# mean of a bunch of words.

#### Question 3 ####
# Part A: create a data frame named my_df. The first column of my_df should
# be q1_vec, and the second column of my_df should be q2_vec.
my_df <- data.frame(q1_vec, q2_vec)

# Part B: call the summary() and str() functions on my_df. Make sure you
# can explain the output that you see!
summary(my_df)
str(my_df)

# Part C: save my_df as an Rds file named "my_df.Rds".
saveRDS(my_df, "my_df.Rds")

# Part D: read in the file my_df.Rds as an object called my_df2. Check whether
# it is identical() to my_df.
my_df2 <- readRDS("my_df.Rds")
identical(my_df, my_df2)

# Part E: save q1_vec, q2_vec, and my_df in a .Rdata file named
# "exercise01.Rdata"
save(q1_vec, q2_vec, my_df, file = "exercise01.Rdata")

#### Question 4 ####
# For this question, we want to load a data set that our friend give us in
# SAS format. You should download the file "Diphtheria_IgG_Serology.sas7bdat"
# to your data directory.

# Part A: use google to find a package that can allow you to read a SAS
# (sas7bdat) file into R. Install and load that package.
install.packages("haven")
library(haven)

# Part B: read in the data set and use R functions to show the name and type
# of each variable, the first 6 rows of the data, and a summary of each variable.
diph <- haven::read_sas(here::here("data", "Diphtheria_IgG_Serology.sas7bdat"))
str(diph)
head(diph)
summary(diph)

# Part C: How many people got vaccinated in the data set? What is the overall
# prevalence of diphtheria in the dataset?
sum(diph$DP_vacc)
mean(diph$DP_infection)

# Part D: Make a 2x2 table of infection vs. vaccination. Make sure the rows
# and columns have understandable labels.
table(diph$DP_vacc, diph$DP_infection, dnn = list("Vaccination", "Infection"))

#### Congratulations! You finished this exercise!! ####
