#
# Project for Getting and Cleaning Data 
#
# Part1: merge training and test datasets
# read x_test and x_train, then select features containing the string 'std' or 'mean'.
# read y_test and y_train for activity codes, subject_test and subject_train for
# the subject id's. 
# Combine test and train files, adding columns for test subject and activity name.
# all files are in "Bob/GCData/UCI HAR Dataset" for ease of running this script.
library(sqldf)
library(plyr)
library(data.table)
#
# setwd("Bob/GCData/UCI HAR Dataset")
 rawtest <- read.table("x_test.txt")
 acttest <- read.table("y_test.txt")
 subtest <-read.table("subject_test.txt")
#
 rawtrain <- read.table("x_train.txt")
 acttrain <- read.table("y_train.txt")
 subtrain <-read.table("subject_train.txt")
#
# Part 2: read a text file of all feature names. Select those containing 'std' or 'mean', 
# then create suitable variable names by using gsub to remove characters
#  that can't be used as column names in R.  
#
rawfeatures <-read.table("features.txt")
thefeatures <- rawfeatures[ grepl('*mean*', rawfeatures$V2) == TRUE | 
                              grepl('*std*', rawfeatures$V2) == TRUE  ,]
thefeatures [,2] <- gsub( "(",  ".",  thefeatures[,2], fixed=TRUE)
thefeatures [,2] <- gsub( ")",  ".",  thefeatures[,2], fixed=TRUE)
gsub( ",",  ".",  thefeatures[,2], fixed=TRUE)
numfeatures <- nrow(thefeatures)
mycols <- thefeatures$V1

activity <- read.table("activity_labels.txt")
names(activity)[1] <- "Code"
names(activity)[2] <- "Name"
#
# Step 3 and 4: 
#  Bind columns for subject ID and activity code to the test and training data, then combine
#  via rbind to yield 'thedata' which is my merged data frame. 
#
 testdata <- cbind(rawtest[, mycols], subtest)
 testdata <- cbind(testdata, acttest)
 traindata <- cbind( rawtrain[, mycols], subtrain)
 traindata <- cbind( traindata, acttrain)
#
thedata <- rbind( testdata, traindata)
names(thedata)[numfeatures + 1] <- "Subject"
names(thedata)[numfeatures + 2] <- "ActivityCode"
#
# Part 3: add a column to thedata with the activity name, access from the activity 
# table using the activity code.
#
thedata["ActivityName"] <- NA
for ( i in 1:nrow(thedata)) { 
    thedata[i,"ActivityName"] <- 
    as.character(activity[thedata[i,"ActivityCode"],"Name"]) 
}
#
# Part 4.  Appropriately label the data set with descriptive variable names. These are 
# the incoming feature names, with incompatible characters removed, above.
#
for ( i in 1:numfeatures ) { names(thedata)[i] <- as.character(thefeatures[i,2])}
#
# Part 5:  From the data set in step 4, creates a second, independent tidy data set 
#  with the average of each variable for each activity and each subject. The 'summaries' 
#  data frame has the same column names as 'thedata', with '_mean' appended to indicate 
#  the values are the mean of the given feature for each combination of activity and subject.
#
maxsub <- max(thedata$Subject) 
datacol <- ncol(thedata) 
summaries <- as.data.frame( matrix (  nrow = 1, ncol = (datacol-3) ))
for ( i in 1:(datacol-3) ) { 
  names(summaries)[i] <- paste(names(thedata)[i], "_mean", sep="")
}
#
actrows <- nrow(activity)
indx <- 0
for (i in 1:actrows) {
  for ( j in 1:maxsub) {
    indx <- indx + 1
    summaries[indx,"ActivityName"] <- as.character(activity[i,"Name"])
    summaries[indx,"ActivityCode"] <- as.character(activity[i,"Code"])
    summaries[indx,"Subject"] <- j
    subj_actdata <- subset(thedata, ActivityCode == i & Subject == j) 
    for (k in 1: (datacol -3)   ) {
      sumval <- mean(subj_actdata[,j])
      summaries[indx,k] <- sumval 
    }  
  }
}
write.table(summaries, file ="mysummaries.txt", sep = ",", row.names = FALSE) 
#
# output summary feature names for the codebook
#                                
# write.table(names(thedata),"datacodebook.txt") 
write.table(names(summaries),"summarycodebook.txt")