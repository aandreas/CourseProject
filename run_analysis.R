##############################################
##run_analysis.R##############################
##############################################

#########  Merges the training and the test sets to create one data set ############

## First create a training set data frame,
##then add Subject and Activity columns ##

traindf <- read.table("X_train.txt")

train_sub_df <- read.table("subject_train.txt")
traindf <- cbind(traindf,train_sub_df)

train_activ_df <- read.table("y_train.txt")
traindf <- cbind(traindf,train_activ_df)

## create the test set data frame,
## then add Subject and Activity columns ##

testdf <- read.table("X_test.txt")

test_sub_df <- read.table("subject_test.txt")
testdf <- cbind(testdf,test_sub_df)

test_activ_df <- read.table("y_test.txt")
testdf <- cbind(testdf,test_activ_df)

## merge train and test data frames into one.
combo_df<- rbind(traindf,testdf)

#############################################################
##Appropriately labels the data set with descriptive variable names.
#############################################################

## create data frame from features.txt 
feature_df <- read.table("C:/Users/Armen/RprogCoursera/W3/UCI_HAR_Dataset/features.txt")
feature_v <- as.vector(feature_df[,"V2"]) ## contains 561 names

feature_v[562:563] <- c("Subject", "Activity") ## add two more names

########## Appropriately label the data set with descriptive variable names. 
colnames(combo_df) <- feature_v

########## Extracts only the measurements on the mean and standard deviation for each measurement. 

combo_df_2 <- combo_df[,grepl("(mean)|(std)|(Subject)|(Activity)", names(combo_df))]


########## Uses descriptive activity names to name the activities in the data set

combo_df_2$Activity[combo_df_2$Activity == 1] <- "WALKING"
combo_df_2$Activity[combo_df_2$Activity == 2] <- "WALKING_UPSTAIRS"
combo_df_2$Activity[combo_df_2$Activity == 3] <- "WALKING_DOWNSTAIRS"
combo_df_2$Activity[combo_df_2$Activity == 4] <- "SITTING"
combo_df_2$Activity[combo_df_2$Activity == 5] <- "STANDING"
combo_df_2$Activity[combo_df_2$Activity == 6] <- "LAYING"

######### From the data set 'combo_df_2', create a second,independent tidy data set
## with the average of each variable for each activity and each subject.###########

library("dplyr")
## use group_by() and summarise_each() from dplyr library
combo_df_by_sub_act <- group_by(combo_df_2, Subject, Activity)
final_df <-summarise_each(combo_df_by_sub_act,funs(mean))
