# GettingCleaning
The is my project repo for the Getting and Cleaning Data course
This repo includes the following files, as specified in the course project instructions:

1. run_analysis.r. This is a single R script that reads data files, selects and names features, and the summarizes data.

2. my_summaries.txt.  This is a comma-separated text file. Its first line contains feature names.  The rightmost three columns are activity name, activity code, and subject number. 

3. codebook.txt.  This is a list of the feature names. It is derived from the column names of my summaries dataframe,  ( 'summaries'), and the means of those features as output in my_summaries.txt.  The names of the means are simply the names of the features with '_mean' appended.


Explanation of the R script:

 Part 1: Merge training and test datasets.
 Read x_test and x_train, then select features containing the string 'std' or 'mean'.  read y_test and y_train for activity codes, subject_test and subject_train for  the subject id's. 
 Combine test and train files, and later add columns for test subject and activity name. I kept all files in a single directory, "Bob/GCData/UCI HAR Dataset" for ease of running this script.

 Part 2: Select relevant features.
 Read a text file of all feature names. Select those containing 'std' or 'mean', then create suitable variable names by using gsub to remove characters that can't be used as column names in R.

 Complete the data frame: 
 Bind columns for subject ID and activity code to the test and training data, then combine via rbind to yield 'thedata', which is my merged data frame.

 Part 3: add a column to thedata with the activity name, access from the activity table using the activity code

 Part 4.  Appropriately label the data set with descriptive variable names. These are the incoming feature names, with incompatible characters removed, above.

 Part 5:  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. The 'summaries' data frame has the same column names as 'thedata', with '_mean' appended to indicate the values are the mean of the given feature for each combination of activity and subject.
