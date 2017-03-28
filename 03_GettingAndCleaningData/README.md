# Getting and Cleaning Data Assignment
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

The data set was taken within the project:

## Human Activity Recognition Using Smartphones Data Set
Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

More information on the dataset can be found [here!](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The original data files can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) as a zip file.

## The repo contains the following files:

### codebook.md / codebook.html

In the code book the whole analysis steps are described including the experiment description, raw data explanation plus all data transformation steps towards the clean data set.

### run_analysis.R

The analysis script executes all necessary steps towards one clean data set. The steps are as follows:

1. Download and unzip the data folder (if not already happened)
2. Read all necessary data into the workspace
3. Merging training and test data
4. Searching for only the measurements on the mean and standard deviation with grep in features and select the correspondig columns in the data_set
5. Creating one single data set and labeling the colums according to names from 4.
6. Turning the subject and activivty columns into the factor class to be able sort them later
7. Reshaping the data to calculate the mean of each subject and each activity
8. Saving txt file of the data set reordered after mean values

### data_mean_tidy.txt
This is the resulting clean data set.


