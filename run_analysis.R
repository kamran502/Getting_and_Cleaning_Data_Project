#Load required library
library(plyr)

#Load train data into variables
x_train <- read.table("./Dataset/train/X_train.txt")
y_train <- read.table("./Dataset/train/y_train.txt")
subject_train <- read.table("./Dataset/train/subject_train.txt")

#Load test data into variables
x_test <- read.table("./Dataset/test/X_test.txt")
y_test <- read.table("./Dataset/test/y_test.txt")
subject_test <- read.table("./Dataset/test/subject_test.txt")

#Coursera requirement 1: Merges the training and the test sets to create one data set.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

#Coursera requirement 2: Extracts only the measurements on the mean and standard deviation for each measurement.
#Load features data
features <- read.table("./Dataset/features.txt")
#Filter only mean and std dev measurements
mean_stddv <- grep("-(mean|std)\\(\\)", features[, 2])
#take subset of data
x <- x[, mean_stddv]
# rename column names
names(x) <- features[mean_stddv, 2]

#Coursera requirement 3: Uses descriptive activity names to name the activities in the data set
activities <- read.table("./Dataset/activity_labels.txt")
# update values with correct activity names
y[, 1] <- activities[y[, 1], 2]
names(y) <- "activity"

#Coursera requirement 4: Appropriately labels the data set with descriptive variable names.
# correct subject column name
names(subject) <- "subject"

# bind all the data in a single data set
data <- cbind(x, y, subject)

#Coursera requirement 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averages_data <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)