# **Getting and Cleaning Data Course Project**



**Jayson Trinchera**  
**August 11, 2016**  
**Last updated 2016-08-12 03:52:36 using R version 3.3.1 (2016-06-21)**  


# **Introduction**   
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The data set that will be used is a database built from the recordings of 30 volunteers within the age bracket of 19-48 years performing six activities of daily living (walking, walking upstairs, walking downstairs, sitting, standing, laying) while wearing a smartphone (Samsung Galaxy S II) on the waist. More information on the study and the data set is available at the link below.

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The goals of this project are the following:   

1. To merge the training and the test sets to create one data set   
2. To extract only the measurements on the mean and standard deviation for each measurement   
3. To use descriptive activity names to name the activities in the data set   
4. To appropriately labels the data set with descriptive variable names; and   
5. To creates a second, independent tidy data set with the average of each variable for each activity and each subject.   

# **Getting Started**  
In this repository, you will find:  

- **dl_data.R** : an R-script that will download and unzip the data set in your computer
- **run_analysis.R** : the R-script to be executed on the data set to accomplish the 5 objectives listed above  
- **tidy_dataset.txt** : the clean data produced by using run_analysis.R  
- **CodeBook.md**, **CodeBook.Rmd**, **CodeBook.html** : describes the data, variables, and step-by-step transformations performed by run_analysis.R  
- **README.md** : this document you are reading now  

## **Packages Used**  
This project will make use of the following packages:  

- reshape2  
- knitr   

If you do not have these packages in R, kindly install them first using the **install.packages()** command.


## **Downloading the Data Set**  
To download the data set for this project, please load and execute **dl_data.R** in R. Listed below is the code inside this script and what it does.  


```r
## This downloads the .zip file and places it in a folder named "temp" in the root directory of R

# if(!file.exists("./temp")){dir.create("./temp")}
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl,destfile="./temp/Dataset.zip")

## This unzips the file inside "temp""

# unzip(zipfile="./temp/Dataset.zip",exdir="./temp")
```

## **Next Steps**  
After downloading the data set and unzipping, you may load and execute **run_analysis.R** in R. Detailed information about the code and what it does can be found on: **CodeBook.md**, **CodeBook.Rmd**, or **CodeBook.html**.  
