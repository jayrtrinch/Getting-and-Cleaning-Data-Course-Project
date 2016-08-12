## If you have not downloaded the files for this project, please do so before proceeding. 
## The dl_data.R script in this repository will download the data set and unzip the files 
## in the directory ./temp/UCI HAR Dataset. 

## Note that the succeeding lines of code will only work, assuming that the unzipped files 
## are in the directory ./temp/UCI HAR Dataset.  


path <- file.path("./temp" , "UCI HAR Dataset")     # stores filepath
files<-list.files(path, recursive=TRUE)             # lists all files stored in path
files

# reads the needed files into R

features_labels <- read.table(file.path(path, "features.txt" ), header = FALSE, stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(path, "activity_labels.txt" ), header = FALSE, stringsAsFactors = FALSE)
subject_train <- read.table(file.path(path, "train/subject_train.txt" ), header = FALSE)
X_train <- read.table(file.path(path, "train/X_train.txt" ), header = FALSE)
Y_train <- read.table(file.path(path, "train/Y_train.txt" ), header = FALSE)
subject_test <- read.table(file.path(path, "test/subject_test.txt" ), header = FALSE)
X_test <- read.table(file.path(path, "test/X_test.txt" ), header = FALSE)
Y_test <- read.table(file.path(path, "test/Y_test.txt" ), header = FALSE)

# displays structure of above loaded objects

str(features_labels)
features_labels[[2]]
str(activity_labels)
activity_labels[[2]]
str(subject_train)
unique(subject_train[[1]])
str(X_train)
str(Y_train)
unique(Y_train[[1]])
str(subject_test)
unique(subject_test[[1]])
str(X_test)
str(Y_test)
unique(Y_test[[1]])

# merges components of training and test sets in respective objects

Subject <- rbind(subject_train, subject_test)
Activity <- rbind(Y_train, Y_test)
Features_561 <- rbind(X_train, X_test)

# add feature_labels

colnames(Features_561) <- t(features_labels[[2]])

# set colnames

colnames(Subject) <- "Subject"
colnames(Activity) <- "Activity"

# cbind assembly

data <- cbind(Subject, Activity, Features_561)
rm(subject_train, subject_test, Subject, Activity, Y_train, Y_test, Features_561, X_train, X_test, features_labels)
str(data)

# checks is.na

table(is.na(data))

# selects colnames with mean/sd

selected_variable_names <- grep(".*mean\\(\\).*|.*std\\(\\).*" ,colnames(data), value = T)
selected_variable_names <- c("Subject", "Activity", selected_variable_names)
data <- data[, selected_variable_names]
str(data)

# replace int in Activity with activity_labels

str(data$Activity)
for (i in 1:6) data[data$Activity == i, 2] <- activity_labels[[2]][[i]]
data$Activity <- as.factor(data$Activity)
str(data$Activity)
head(data$Activity, 50)

# replaces abbreviated colnames

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)

# r melts and casts data set 

if (require(reshape2) == F) install.packages("reshape2")
mdata <- melt(data, id = c("Subject", "Activity"))
str(mdata)
head(mdata)
data2 <- dcast(mdata, Subject + Activity ~ variable, mean)
str(data2)
data2[1:30, 1:3]

# write output to root directory

write.table(data2, file = "tidy_dataset.txt", row.names = FALSE)