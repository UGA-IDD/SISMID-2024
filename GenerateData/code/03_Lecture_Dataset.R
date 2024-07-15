## I need to modify the dataset to:
## 1. add observation_id and save the new datasets
## 2. create time point two dataset 
## 3. create merged dataset
## 13 July 2024

df <- readr::read_csv("./lectures/data/serodata.csv")

# 1. Add observation_id  ####
df$observation_id <- sample(5000:10000, 651)
write.csv(df, file="./lectures/data/serodata.csv", row.names = FALSE) #comma delimited
#I moved the observation_id by hand and added it to the .xlsx file
df <- readr::read_csv("./lectures/data/serodata.csv")
write.table(df, file="./lectures/data/serodata1.txt", sep="\t", row.names = FALSE) #tab delimited
write.table(df, file="./lectures/data/serodata2.txt", sep=";", row.names = FALSE) #semicolon delimited


# 2. create time point two dataset   ####
#most people's IgG will drop, some will increase
#lets sample from 0.2 to 0 to get percent decrease over 4 years for 577 observations
percent.decrease <- runif(577, min=0, max=0.2)
#lets sample from 0.5 to 0 to get percent decrease over 4 years for 74 observations
percent.increase <- runif(74, min=0, max=0.5)

#randomly assign increase and decrease
index.decrease <- sample(1:651, 577)
index.increase <- c(1:651)[(1:651 %in% index.decrease)==FALSE]

#get new data
new_df <- data.frame(observation_id=df$observation_id, IgG_concentration=rep(NA, 651), age=rep(NA, 651))
new_df$IgG_concentration[index.decrease] <- df$IgG_concentration[index.decrease]-(df$IgG_concentration[index.decrease]*percent.decrease)
new_df$IgG_concentration[index.increase] <- df$IgG_concentration[index.increase]+(df$IgG_concentration[index.increase]*percent.increase)
new_df$age <- df$age+4

#add some more NA values in for the heck of it
new_df$IgG_concentration[sample(1:651, 5)] <- NA
#drop the lines with missing values
new_df <- new_df[!is.na(new_df$IgG_concentration),]

write.csv(new_df, file="./lectures/data/serodata_new.csv", row.names = FALSE) #comma delimited


