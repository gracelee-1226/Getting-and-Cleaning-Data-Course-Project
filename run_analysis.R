setwd("/Users/yangli/Desktop/Coursera/Data Science/3-Getting and Cleaning Data/UCI HAR Dataset")
library(dplyr)
###Read the data
#Read the activity data
ActivityTrain<-read.table("train/y_train.txt")
ActivityTest<-read.table("test/y_test.txt")
#Read the subject data
SubjectTrain<-read.table("train/subject_train.txt")
SubjectTest<-read.table("test/subject_test.txt")
#Read the feature data
FeatureTrain<-read.table("train/X_train.txt")
FeatureTest<-read.table("test/X_test.txt")

###Q1:Merge the training and the test to create one data set
#Bind rows
Activity<-rbind(ActivityTrain,ActivityTest)
Subject<-rbind(SubjectTrain,SubjectTest)
Feature<-rbind(FeatureTrain,FeatureTest)
#Set names
names(Activity)<-c("Activity")
names(Subject)<-c("Subject")
FeatureNames<-read.table("features.txt")
names(Feature)<-FeatureNames$V2
#Bind columns
AandS<-cbind(Activity,Subject)
Data<-cbind(Feature,AandS)

###Q2:Extract only the measurements on the mean and std for each measurement
#Take names with mean() or std()
SubFeatureNames<-FeatureNames$V2[grep("mean\\(\\)|std\\(\\)",FeatureNames$V2)]
#Subset Data
SubData<-subset(Data,select=c(as.character(SubFeatureNames),"Activity","Subject"))

###Q3:Use descriptive activity names to name the activities in the data set
#Read the Activity Labels
ActivityLabels<-read.table("activity_labels.txt")
#Factorize SubData$Activity with descriptive activity names
SubData$Activity<-factor(SubData$Activity,levels=ActivityLabels$V1,labels=ActivityLabels$V2)

###Q4:Appropriately label the data set with descriptive variable names
names(SubData)<-gsub("^t","time",names(SubData))
names(SubData)<-gsub("^f","frequency",names(SubData))
names(SubData)<-gsub("Acc","Accelerometer",names(SubData))
names(SubData)<-gsub("Gyro","Gyroscope",names(SubData))
names(SubData)<-gsub("Mag","Magnitude",names(SubData))
names(SubData)<-gsub("BodyBody","Body",names(SubData))

###5:Create a second, independent tidy data set with the average of each variable for each activity and each subject
OutputData<-aggregate(. ~Subject+Activity,SubData,mean)
OutputData<-OutputData[order(OutputData$Subject,OutputData$Activity),]
write.table(OutputData,file="TidyData.txt",row.name=FALSE)

