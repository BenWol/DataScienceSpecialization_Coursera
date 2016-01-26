# This sript was created as part of the assignment 1 of the Data Science Specialization - course "Getting and 
# Cleaning Data". It contains all steps to create a tidy data set of the data files provided on the
# course website about Human Activity Recognition Using Smartphones Dataset which is collected from
# the accelerators of a Samsung Galaxy S smartphone. The script does the following:
# a) Merges the training and the test sets to create one data set.
# b) Extracts only the measurements on the mean and standard deviation for each measurement.
# c) Uses descriptive activity names to name the activities in the data set
# d) Appropriately labels the data set with descriptive variable names.
# e) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 0. choose a working directory
setwd("...")

# 1. download and unzip the data folder (if not already happened)
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
    url <- "..."
    download.file(url,destfile = "getdata-projectfiles-UCI HAR Dataset.zip",method = "curl")
}
if(!file.exists("UCI HAR Dataset")){
    unzip("getdata-projectfiles-UCI HAR Dataset.zip")
}

# 2. read all necessary data into the workspace
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# 3. Merging training and test data set
data_set <- rbind(train_set,test_set)
data_labels <- rbind(train_labels,test_labels)
data_subject <- rbind(train_subject,test_subject)

# 4. Searching for only the measurements on the mean and standard deviation with grep in features and select the correspondig columns in the data_set
features_mean_std <- grepl("mean",features$V2,ignore.case = TRUE) | grepl("std",features$V2,ignore.case = TRUE)
data_set_mean_std <- data_set[,features_mean_std]

# 5. Creating one single data set and labeling the colums according to names from 4.
data <- cbind(data_subject,data_labels,data_set_mean_std)

names_features_mean_std <- as.character(features$V2[features_mean_std])
names_features_mean_std <- sub("\\()-", "",names_features_mean_std)
names_features_mean_std <- sub("\\()", "",names_features_mean_std)
names_features_mean_std <- sub("\\(", "",names_features_mean_std)
names_features_mean_std <- sub(",", "",names_features_mean_std)
names_features_mean_std <- sub("-", "",names_features_mean_std)
names_features_mean_std <- sub("\\)", "",names_features_mean_std)
names_features_mean_std <- sub("\\)", "",names_features_mean_std)
names_features_mean_std <- sub("mean", "Mean",names_features_mean_std)
names_features_mean_std <- sub("std", "Std",names_features_mean_std)
names_features_mean_std <- sub("^t","Time",names_features_mean_std)
names_features_mean_std <- sub("^f","Frequency",names_features_mean_std)

colnames(data) <- c("subject","activity",as.character(names_features_mean_std))

# 6. turning the subject and activivty columns into the factor class to be able sort them later
data$subject <- factor(data$subject)
data$activity <- factor(data$activity, levels = activity_labels[,1], labels = activity_labels[,2])

# 7. Reshaping the data to calculate the mean of each subject and each activity
library(reshape2)
data_melted <- melt(data,id = c("subject","activity"))
data_mean_values <- dcast(data_melted,subject + activity ~ variable,mean)

# 8. save txt file of the data set reordered after mean values
write.table(data_mean_values, file = "data_mean_tidy.txt")







