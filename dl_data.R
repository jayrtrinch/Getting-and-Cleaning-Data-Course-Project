
# this downloads the .zip file and places it in a folder named "temp" in the root directory of R

if(!file.exists("./temp")){dir.create("./temp")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./temp/Dataset.zip")

# this unzips the file inside "temp"
# the unzipped files will be in the directory ./temp/UCI HAR Dataset

unzip(zipfile="./temp/Dataset.zip",exdir="./temp")


