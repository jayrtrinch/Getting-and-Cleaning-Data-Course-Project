## This downloads the .zip file and places it in a folder named "temp" in the root directory of R

if(!file.exists("./temp")){dir.create("./temp")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./temp/Dataset.zip")

## This unzips the file inside "temp"

unzip(zipfile="./temp/Dataset.zip",exdir="./temp")