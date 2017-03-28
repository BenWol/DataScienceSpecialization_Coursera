
#Codebook for the Assignment of Getting and Cleaning Data: Human Activity Recognition Using Smartphones Dataset
###author: BenWol
###date: 17/01/2016

## Project Description
Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

##Study design and data processing

###Collection of the raw data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

###Notes on the original (raw) data 
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

##Creating the tidy datafile

###Guide to create the tidy data file
The analysis script executes the following points:
1. Download and unzip the data folder (if not already happened)
2. Read all necessary data into the workspace
3. Merging training and test data
4. Searching for only the measurements on the mean and standard deviation with grep in features and select the correspondig columns in the data_set
5. Creating one single data set and labeling the colums according to names from 4.
6. Turning the subject and activivty columns into the factor class to be able sort them later
7. Reshaping the data to calculate the mean of each subject and each activity
8. Saving txt file of the data set reordered after mean values

###Cleaning of the data
0. At first one has to choose the where the run_analysis.R script should be executed and so where the raw data will be tidied.
1. In the first step the raw data will be downloaded and unzipped. The code also contains an if-loop to check if the data is already present in the current working directory and skips the download/zip if that is true.
2. The second step of the script reads in all the necessary data to create a clean data set. Here the main data sits in the 'X_train.txt' ("UCI HAR Dataset/train/X_train.txt") or 'X_test.txt' ("UCI HAR Dataset/test/X_test.txt") files. The activity label entry for every measured observation (each row) has to be loaded extra with 'y_train.txt' ("UCI HAR Dataset/train/y_train.txt") or 'y_test.txt' ("UCI HAR Dataset/test/y_test.txt"). These can then be correlated with the activity label information sitting in "UCI HAR Dataset/activity_labels.txt". Every observation entry (each row) was performed by 1 of 30 test persons. The subject files ("UCI HAR Dataset/train/subject_train.txt", "UCI HAR Dataset/test/subject_test.txt") tell you which person performed which observation.
3. The set, labels and subject files corresponding to the train and the test set are of the same type and built equally (same number variables/columns, different number observations). To combine the data to one you can just use the rbind() function.
4. Next the variables need to be selected after only those you correspond to a mean or a standard deviation value (std). The data set is cut to only these variables/columns (86 in total).
5. Now the resulting data is combined to one data set by adding the subject and the activity information as columns 1 and 2. Here the cbind() funciton is used. Additionally the activity labels are cleaned and changed to descriptive variable names. All columns get these cleaned names.
6. In the following the subject and the activity column are transformed to into factors to further be able to reshape them with the 'melt()' and the 'dcast()' function. Also all activity levels are labeled.
7. Using the reshape2 package, the data set is melted to only depend on subject and activity while all other variables are lined up in one variable and one value. Then the data is tabulated by each row entry (depending on subject and acitvity) while calculating the mean value for each subject(30x) + activity(6x) combination. This leads to 30 rows with calculated means for all variables (86x).
8. Last the tidied data is saved as a .txt file.

[README](https://github.com/BenWol/Getting_and_Cleaning_Data_Assignment/blob/master/README.md)

##Description of the variables in the data_mean_tidy.txt file
The .txt file contains the mean values of 86 variables for all 180 subject (30) - activity (6) combinations. So the file contains 180 rows and 88 columns. Saved as a .txt file it has a size of 293 kB. 
In the following all variables/columns are shortly described:

###Variable 1: subject
The subject factor identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. The subject is of the factor class.

###Variable 2: activity
The activity factors give information about the activity the test object performed for each observaion. the class labels with their activity name. The activities are 1 WALKING,
2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS, 4 SITTING, 5 STANDING, 6 LAYING.

###Variable 3 - 88:
The 86 variables are selected numeric variables, that are detected and calculated out of the accelerometer and gyroscope 3-axial raw signals TimeAcc-XYZ and TimeGyro-XYZ. These time domain signals were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (TimeBodyAcc-XYZ and TimeGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (TimeBodyAccJerk-XYZ and TimeBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (TimeBodyAccMag, TimeGravityAccMag, TimeBodyAccJerkMag, TimeBodyGyroMag, TimeBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing FrequencyBodyAcc-XYZ, FrequencyBodyAccJerk-XYZ, FrequencyBodyGyro-XYZ, FrequencyBodyAccJerkMag, FrequencyBodyGyroMag, FrequencyBodyGyroJerkMag.

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

For all these variable/signal/feature categories the mean value as well as the standard deviation (std) value was kept in the tidy dataset.

All variables are normalized numeric variables with a value bound within [-1,1].

The following list presents all numeric variables selected in the tidy dataset with a cleaned name (as used in the tidy dataset):

#### 3: TimeBodyAccMeanX
#### 4: TimeBodyAccMeanY
#### 5: TimeBodyAccMeanZ
#### 6: TimeBodyAccStdX
#### 7: TimeBodyAccStdY
#### 8: TimeBodyAccStdZ
#### 9: TimeGravityAccMeanX
#### 10: TimeGravityAccMeanY
#### 11: TimeGravityAccMeanZ
#### 12: TimeGravityAccStdX
#### 13: TimeGravityAccStdY
#### 14: TimeGravityAccStdZ
#### 15: TimeBodyAccJerkMeanX
#### 16: TimeBodyAccJerkMeanY
#### 17: TimeBodyAccJerkMeanZ
#### 18: TimeBodyAccJerkStdX
#### 19: TimeBodyAccJerkStdY
#### 20: TimeBodyAccJerkStdZ
#### 21: TimeBodyGyroMeanX
#### 22: TimeBodyGyroMeanY
#### 23: TimeBodyGyroMeanZ
#### 24: TimeBodyGyroStdX
#### 25: TimeBodyGyroStdY
#### 26: TimeBodyGyroStdZ
#### 27: TimeBodyGyroJerkMeanX
#### 28: TimeBodyGyroJerkMeanY
#### 29: TimeBodyGyroJerkMeanZ
#### 30: TimeBodyGyroJerkStdX
#### 31: TimeBodyGyroJerkStdY
#### 32: TimeBodyGyroJerkStdZ
#### 33: TimeBodyAccMagMean
#### 34: TimeBodyAccMagStd
#### 35: TimeGravityAccMagMean
#### 36: TimeGravityAccMagStd
#### 37: TimeBodyAccJerkMagMean
#### 38: TimeBodyAccJerkMagStd
#### 39: TimeBodyGyroMagMean
#### 40: TimeBodyGyroMagStd
#### 41: TimeBodyGyroJerkMagMean
#### 42: TimeBodyGyroJerkMagStd
#### 43: FrequencyBodyAccMeanX
#### 44: FrequencyBodyAccMeanY
#### 45: FrequencyBodyAccMeanZ
#### 46: FrequencyBodyAccStdX
#### 47: FrequencyBodyAccStdY
#### 48: FrequencyBodyAccStdZ
#### 49: FrequencyBodyAccMeanFreqX
#### 50: FrequencyBodyAccMeanFreqY
#### 51: FrequencyBodyAccMeanFreqZ
#### 52: FrequencyBodyAccJerkMeanX
#### 53: FrequencyBodyAccJerkMeanY
#### 54: FrequencyBodyAccJerkMeanZ
#### 55: FrequencyBodyAccJerkStdX
#### 56: FrequencyBodyAccJerkStdY
#### 57: FrequencyBodyAccJerkStdZ
#### 58: FrequencyBodyAccJerkMeanFreqX
#### 59: FrequencyBodyAccJerkMeanFreqY
#### 60: FrequencyBodyAccJerkMeanFreqZ
#### 61: FrequencyBodyGyroMeanX
#### 62: FrequencyBodyGyroMeanY
#### 63: FrequencyBodyGyroMeanZ
#### 64: FrequencyBodyGyroStdX
#### 65: FrequencyBodyGyroStdY
#### 66: FrequencyBodyGyroStdZ
#### 67: FrequencyBodyGyroMeanFreqX
#### 68: FrequencyBodyGyroMeanFreqY
#### 69: FrequencyBodyGyroMeanFreqZ
#### 70: FrequencyBodyAccMagMean
#### 71: FrequencyBodyAccMagStd
#### 72: FrequencyBodyAccMagMeanFreq
#### 73: FrequencyBodyBodyAccJerkMagMean
#### 74: FrequencyBodyBodyAccJerkMagStd
#### 75: FrequencyBodyBodyAccJerkMagMeanFreq
#### 76: FrequencyBodyBodyGyroMagMean
#### 77: FrequencyBodyBodyGyroMagStd
#### 78: FrequencyBodyBodyGyroMagMeanFreq
#### 79: FrequencyBodyBodyGyroJerkMagMean
#### 80: FrequencyBodyBodyGyroJerkMagStd
#### 81: FrequencyBodyBodyGyroJerkMagMeanFreq
#### 82: angletBodyAccMeangravity
#### 83: angletBodyAccJerkMeangravityMean
#### 84: angletBodyGyroMeangravityMean
#### 85: angletBodyGyroJerkMeangravityMean
#### 86: angleXgravityMean
#### 87: angleYgravityMean
#### 88: angleZgravityMean