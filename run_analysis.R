library(dplyr);

# PART 1: Merges the training and the test sets to create one data set.
# The working directory is set to "C:\Acads\Coursera\Data Science Specialization\3 Getting and Cleaning Data\Week 4\UCI HAR Dataset"

#reading training data
xTrain <- read.table("train/X_train.txt");
yTrain <- read.table("train/y_train.txt");
subjectTrain <- read.table("train/subject_train.txt");

#reading test data
xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt");
subjectTest <- read.table("test/subject_test.txt");

# Combining 'X', 'Y' and subject data
xData <- rbind(xTrain, xTest);
yData <- rbind(yTrain, yTest);
subjectData <- rbind(subjectTrain, subjectTest);

# PART 2: Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt");
meanStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2]); #extracting columns with mean and std
xData <- xData[, meanStdFeatures]; #extracting required columns
names(xData) <- features[meanStdFeatures, 2]; #changing names

# PART 3: Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt");
yData[, 1] <- activities[yData[, 1], 2]; #update yData with correct activity names
names(yData) <- "activity"; #changing column name

# PART 4: Appropriately labels the data set with descriptive variable names.

names(subjectData) <- "subject";
data <- cbind(xData, yData, subjectData); #binding all the data

# PART 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

averagesData <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]));
write.table(averagesData, "Tidy Data Set.txt", row.name=FALSE)