#initialize dplyr package 
library(dplyr)

#initialize and read all the data in text files
activity <- read.table("activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("features.txt", col.names = c("n", "functions"))
subject_test <- read.table("./test/subject_test.txt", col.names="subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/Y_test.txt", col.names = "code")
subject_train <- read.table("./train/subject_train.txt", col.names="subject")
x_train <- read.table("./train/x_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt",col.names = "code")


#merge train and test data accordingly using rbind
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

#merge subject, x and y datasets 
Merge <- cbind(Subject, X, Y)

#select and merge specific columns such as subject, code and columns containing mean and standard deviation
TidyData <- Merge %>% select(subject, code, contains("mean"), contains("std"))

#change the data under tidydata$code by categorizing the codes accordingly to the correct activity name
TidyData$code <-activity[TidyData$code, 2]

#renaming the columns from code to activity, and renaming column names from short to complete titles
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#creates a new tidy data set by grouping TidyData by subject and activity, and then gets the average of each variable for each activity and each subject
FinalData <- TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))

#creates a text file and stores the table result from FinalData
write.table(FinalData, "FinalData.txt", row.name=FALSE)

