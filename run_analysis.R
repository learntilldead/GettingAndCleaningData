# load data files
testData <- read.table("UCI HAR Dataset/test/X_test.txt")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")

# load subject files
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

# load activity files
testActivity <- read.table("UCI HAR Dataset/test/y_test.txt")
trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt")

# merge test and training data
data <- rbind(testData, trainData)
subjects <- rbind(testSubject, trainSubject)
activities <- rbind(testActivity, trainActivity)

# subset mean and std data
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_data <- data[, grep("mean|std", features$V2)]

# convert activity numbers to strings
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")
named_activities = data.frame(lapply(activities, function(x) activity_labels[x,2]))

# add descriptive column names
colnames(mean_std_data) <- features[grep("mean|std", features$V2),]$V2
colnames(named_activities) <- c("activites")
colnames(subjects) <- c("subjects")

# merge data with subject and activity columns
new_mean_std_data <- cbind(subjects, named_activities, mean_std_data)

# create a factor column for each activity and each subject
new_mean_std_data$subject_activity <- interaction(new_mean_std_data$subjects, new_mean_std_data$activites)

# calculate the means of all variables for each activity and each subject
result <- aggregate(new_mean_std_data[, 3:(ncol(new_mean_std_data)-1)], 
                    by=list(new_mean_std_data$subject_activity), 
                    mean, rm.na=TRUE)