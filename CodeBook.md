# CodeBook



**Jayson Trinchera**  
**August 11, 2016**  
**Last updated 2016-08-12 04:12:21 using R version 3.3.1 (2016-06-21)**  

# **Introduction**   
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The data set that will be used is a database built from the recordings of 30 volunteers within the age bracket of 19-48 years performing six activities of daily living (walking, walking upstairs, walking downstairs, sitting, standing, laying) while wearing a smartphone (Samsung Galaxy S II) on the waist. More information on the study and the data set is available at the link below.

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The goals of this project are the following:   

1. To merge the training and the test sets to create one data set   
2. To extract only the measurements on the mean and standard deviation for each measurement   
3. To use descriptive activity names to name the activities in the data set   
4. To appropriately labels the data set with descriptive variable names; and   
5. To creates a second, independent tidy data set with the average of each variable for each activity and each subject.   

# **Step 1: Looking at the Files**  
The **dl_data.R** script in this repository will download the data set and unzip the files in the directory ./temp/UCI HAR Dataset. First, we'll take a peek at the list of files. The following code does that.  


```r
path <- file.path("./temp" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```

Detailed information about the data set can be found on **./temp/UCI HAR Dataset/README.txt**. For this project, we'll only use the following files and ignore the remainder.  

- **"features.txt"**  
- **"activity_labels.txt"**  
- **"train/subject_train.txt"**  
- **"train/X_train.txt"**  
- **"train/y_train.txt"** 
- **"test/subject_test.txt"**   
- **"test/X_test.txt"**   
- **"test/y_test.txt"**  
 
# **Step 2: Reading the Files and Making Sense of the Data**  
We'll read all the above files in to R.    


```r
features_labels <- read.table(file.path(path, "features.txt" ), header = FALSE, stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(path, "activity_labels.txt" ), header = FALSE, stringsAsFactors = FALSE)
subject_train <- read.table(file.path(path, "train/subject_train.txt" ), header = FALSE)
X_train <- read.table(file.path(path, "train/X_train.txt" ), header = FALSE)
Y_train <- read.table(file.path(path, "train/Y_train.txt" ), header = FALSE)
subject_test <- read.table(file.path(path, "test/subject_test.txt" ), header = FALSE)
X_test <- read.table(file.path(path, "test/X_test.txt" ), header = FALSE)
Y_test <- read.table(file.path(path, "test/Y_test.txt" ), header = FALSE)
```

Now, we'll try to make sense of the data based on their structure. We'll look at the objects created above in R one-by-one.  

## **features_labels**  
The second column of this data frame contains the names of 561 features or measurements obtained in the study. Each of these are the names of the variables that we'd like to set up as column names for our tidy data set. The following description of abbreviations is helpful to understand the naming of these features/variables. More information about these features can be found on **"features_info.txt"**.   

- a prefix of "t" indicates time domain signals  
- a prefix of "f" indicates frequency domain signals  
- "Acc" indicates measurements from the smartphone accelerometer which signify linear acceleration  
- "Gyro" indicates measurements from the smartphone gyroscopic sensor which signify angular velocity    
- "Body" denotes body acceleration signals  
- "Gravity"  denotes gravity acceleration signals  
- "Jerk" signals represent "BodyAcc" or "BodyGyro" as a function of time  
- "Mag" indicates the magnitude of the three-dimensional signals calculated using the Euclidean norm  
- the suffixes "-X", "-Y", and "-Z"" denote recordings in the X, Y and Z axes  
- the following set of suffixes to identify the command/transformation applied: "-mean()", "-std()", "-mad()", "-max()", "-min()", "-sma()", "-energy()", "-iqr()", "-entropy()", "-arCoeff()", "-correlation()", "-maxInds()", "-meanFreq()", "-skewness()", "-kurtosis()", "-bandsEnergy()", and "-angle()".  


```r
str(features_labels)
```

```
## 'data.frame':	561 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
```

```r
features_labels[[2]]
```

```
##   [1] "tBodyAcc-mean()-X"                   
##   [2] "tBodyAcc-mean()-Y"                   
##   [3] "tBodyAcc-mean()-Z"                   
##   [4] "tBodyAcc-std()-X"                    
##   [5] "tBodyAcc-std()-Y"                    
##   [6] "tBodyAcc-std()-Z"                    
##   [7] "tBodyAcc-mad()-X"                    
##   [8] "tBodyAcc-mad()-Y"                    
##   [9] "tBodyAcc-mad()-Z"                    
##  [10] "tBodyAcc-max()-X"                    
##  [11] "tBodyAcc-max()-Y"                    
##  [12] "tBodyAcc-max()-Z"                    
##  [13] "tBodyAcc-min()-X"                    
##  [14] "tBodyAcc-min()-Y"                    
##  [15] "tBodyAcc-min()-Z"                    
##  [16] "tBodyAcc-sma()"                      
##  [17] "tBodyAcc-energy()-X"                 
##  [18] "tBodyAcc-energy()-Y"                 
##  [19] "tBodyAcc-energy()-Z"                 
##  [20] "tBodyAcc-iqr()-X"                    
##  [21] "tBodyAcc-iqr()-Y"                    
##  [22] "tBodyAcc-iqr()-Z"                    
##  [23] "tBodyAcc-entropy()-X"                
##  [24] "tBodyAcc-entropy()-Y"                
##  [25] "tBodyAcc-entropy()-Z"                
##  [26] "tBodyAcc-arCoeff()-X,1"              
##  [27] "tBodyAcc-arCoeff()-X,2"              
##  [28] "tBodyAcc-arCoeff()-X,3"              
##  [29] "tBodyAcc-arCoeff()-X,4"              
##  [30] "tBodyAcc-arCoeff()-Y,1"              
##  [31] "tBodyAcc-arCoeff()-Y,2"              
##  [32] "tBodyAcc-arCoeff()-Y,3"              
##  [33] "tBodyAcc-arCoeff()-Y,4"              
##  [34] "tBodyAcc-arCoeff()-Z,1"              
##  [35] "tBodyAcc-arCoeff()-Z,2"              
##  [36] "tBodyAcc-arCoeff()-Z,3"              
##  [37] "tBodyAcc-arCoeff()-Z,4"              
##  [38] "tBodyAcc-correlation()-X,Y"          
##  [39] "tBodyAcc-correlation()-X,Z"          
##  [40] "tBodyAcc-correlation()-Y,Z"          
##  [41] "tGravityAcc-mean()-X"                
##  [42] "tGravityAcc-mean()-Y"                
##  [43] "tGravityAcc-mean()-Z"                
##  [44] "tGravityAcc-std()-X"                 
##  [45] "tGravityAcc-std()-Y"                 
##  [46] "tGravityAcc-std()-Z"                 
##  [47] "tGravityAcc-mad()-X"                 
##  [48] "tGravityAcc-mad()-Y"                 
##  [49] "tGravityAcc-mad()-Z"                 
##  [50] "tGravityAcc-max()-X"                 
##  [51] "tGravityAcc-max()-Y"                 
##  [52] "tGravityAcc-max()-Z"                 
##  [53] "tGravityAcc-min()-X"                 
##  [54] "tGravityAcc-min()-Y"                 
##  [55] "tGravityAcc-min()-Z"                 
##  [56] "tGravityAcc-sma()"                   
##  [57] "tGravityAcc-energy()-X"              
##  [58] "tGravityAcc-energy()-Y"              
##  [59] "tGravityAcc-energy()-Z"              
##  [60] "tGravityAcc-iqr()-X"                 
##  [61] "tGravityAcc-iqr()-Y"                 
##  [62] "tGravityAcc-iqr()-Z"                 
##  [63] "tGravityAcc-entropy()-X"             
##  [64] "tGravityAcc-entropy()-Y"             
##  [65] "tGravityAcc-entropy()-Z"             
##  [66] "tGravityAcc-arCoeff()-X,1"           
##  [67] "tGravityAcc-arCoeff()-X,2"           
##  [68] "tGravityAcc-arCoeff()-X,3"           
##  [69] "tGravityAcc-arCoeff()-X,4"           
##  [70] "tGravityAcc-arCoeff()-Y,1"           
##  [71] "tGravityAcc-arCoeff()-Y,2"           
##  [72] "tGravityAcc-arCoeff()-Y,3"           
##  [73] "tGravityAcc-arCoeff()-Y,4"           
##  [74] "tGravityAcc-arCoeff()-Z,1"           
##  [75] "tGravityAcc-arCoeff()-Z,2"           
##  [76] "tGravityAcc-arCoeff()-Z,3"           
##  [77] "tGravityAcc-arCoeff()-Z,4"           
##  [78] "tGravityAcc-correlation()-X,Y"       
##  [79] "tGravityAcc-correlation()-X,Z"       
##  [80] "tGravityAcc-correlation()-Y,Z"       
##  [81] "tBodyAccJerk-mean()-X"               
##  [82] "tBodyAccJerk-mean()-Y"               
##  [83] "tBodyAccJerk-mean()-Z"               
##  [84] "tBodyAccJerk-std()-X"                
##  [85] "tBodyAccJerk-std()-Y"                
##  [86] "tBodyAccJerk-std()-Z"                
##  [87] "tBodyAccJerk-mad()-X"                
##  [88] "tBodyAccJerk-mad()-Y"                
##  [89] "tBodyAccJerk-mad()-Z"                
##  [90] "tBodyAccJerk-max()-X"                
##  [91] "tBodyAccJerk-max()-Y"                
##  [92] "tBodyAccJerk-max()-Z"                
##  [93] "tBodyAccJerk-min()-X"                
##  [94] "tBodyAccJerk-min()-Y"                
##  [95] "tBodyAccJerk-min()-Z"                
##  [96] "tBodyAccJerk-sma()"                  
##  [97] "tBodyAccJerk-energy()-X"             
##  [98] "tBodyAccJerk-energy()-Y"             
##  [99] "tBodyAccJerk-energy()-Z"             
## [100] "tBodyAccJerk-iqr()-X"                
## [101] "tBodyAccJerk-iqr()-Y"                
## [102] "tBodyAccJerk-iqr()-Z"                
## [103] "tBodyAccJerk-entropy()-X"            
## [104] "tBodyAccJerk-entropy()-Y"            
## [105] "tBodyAccJerk-entropy()-Z"            
## [106] "tBodyAccJerk-arCoeff()-X,1"          
## [107] "tBodyAccJerk-arCoeff()-X,2"          
## [108] "tBodyAccJerk-arCoeff()-X,3"          
## [109] "tBodyAccJerk-arCoeff()-X,4"          
## [110] "tBodyAccJerk-arCoeff()-Y,1"          
## [111] "tBodyAccJerk-arCoeff()-Y,2"          
## [112] "tBodyAccJerk-arCoeff()-Y,3"          
## [113] "tBodyAccJerk-arCoeff()-Y,4"          
## [114] "tBodyAccJerk-arCoeff()-Z,1"          
## [115] "tBodyAccJerk-arCoeff()-Z,2"          
## [116] "tBodyAccJerk-arCoeff()-Z,3"          
## [117] "tBodyAccJerk-arCoeff()-Z,4"          
## [118] "tBodyAccJerk-correlation()-X,Y"      
## [119] "tBodyAccJerk-correlation()-X,Z"      
## [120] "tBodyAccJerk-correlation()-Y,Z"      
## [121] "tBodyGyro-mean()-X"                  
## [122] "tBodyGyro-mean()-Y"                  
## [123] "tBodyGyro-mean()-Z"                  
## [124] "tBodyGyro-std()-X"                   
## [125] "tBodyGyro-std()-Y"                   
## [126] "tBodyGyro-std()-Z"                   
## [127] "tBodyGyro-mad()-X"                   
## [128] "tBodyGyro-mad()-Y"                   
## [129] "tBodyGyro-mad()-Z"                   
## [130] "tBodyGyro-max()-X"                   
## [131] "tBodyGyro-max()-Y"                   
## [132] "tBodyGyro-max()-Z"                   
## [133] "tBodyGyro-min()-X"                   
## [134] "tBodyGyro-min()-Y"                   
## [135] "tBodyGyro-min()-Z"                   
## [136] "tBodyGyro-sma()"                     
## [137] "tBodyGyro-energy()-X"                
## [138] "tBodyGyro-energy()-Y"                
## [139] "tBodyGyro-energy()-Z"                
## [140] "tBodyGyro-iqr()-X"                   
## [141] "tBodyGyro-iqr()-Y"                   
## [142] "tBodyGyro-iqr()-Z"                   
## [143] "tBodyGyro-entropy()-X"               
## [144] "tBodyGyro-entropy()-Y"               
## [145] "tBodyGyro-entropy()-Z"               
## [146] "tBodyGyro-arCoeff()-X,1"             
## [147] "tBodyGyro-arCoeff()-X,2"             
## [148] "tBodyGyro-arCoeff()-X,3"             
## [149] "tBodyGyro-arCoeff()-X,4"             
## [150] "tBodyGyro-arCoeff()-Y,1"             
## [151] "tBodyGyro-arCoeff()-Y,2"             
## [152] "tBodyGyro-arCoeff()-Y,3"             
## [153] "tBodyGyro-arCoeff()-Y,4"             
## [154] "tBodyGyro-arCoeff()-Z,1"             
## [155] "tBodyGyro-arCoeff()-Z,2"             
## [156] "tBodyGyro-arCoeff()-Z,3"             
## [157] "tBodyGyro-arCoeff()-Z,4"             
## [158] "tBodyGyro-correlation()-X,Y"         
## [159] "tBodyGyro-correlation()-X,Z"         
## [160] "tBodyGyro-correlation()-Y,Z"         
## [161] "tBodyGyroJerk-mean()-X"              
## [162] "tBodyGyroJerk-mean()-Y"              
## [163] "tBodyGyroJerk-mean()-Z"              
## [164] "tBodyGyroJerk-std()-X"               
## [165] "tBodyGyroJerk-std()-Y"               
## [166] "tBodyGyroJerk-std()-Z"               
## [167] "tBodyGyroJerk-mad()-X"               
## [168] "tBodyGyroJerk-mad()-Y"               
## [169] "tBodyGyroJerk-mad()-Z"               
## [170] "tBodyGyroJerk-max()-X"               
## [171] "tBodyGyroJerk-max()-Y"               
## [172] "tBodyGyroJerk-max()-Z"               
## [173] "tBodyGyroJerk-min()-X"               
## [174] "tBodyGyroJerk-min()-Y"               
## [175] "tBodyGyroJerk-min()-Z"               
## [176] "tBodyGyroJerk-sma()"                 
## [177] "tBodyGyroJerk-energy()-X"            
## [178] "tBodyGyroJerk-energy()-Y"            
## [179] "tBodyGyroJerk-energy()-Z"            
## [180] "tBodyGyroJerk-iqr()-X"               
## [181] "tBodyGyroJerk-iqr()-Y"               
## [182] "tBodyGyroJerk-iqr()-Z"               
## [183] "tBodyGyroJerk-entropy()-X"           
## [184] "tBodyGyroJerk-entropy()-Y"           
## [185] "tBodyGyroJerk-entropy()-Z"           
## [186] "tBodyGyroJerk-arCoeff()-X,1"         
## [187] "tBodyGyroJerk-arCoeff()-X,2"         
## [188] "tBodyGyroJerk-arCoeff()-X,3"         
## [189] "tBodyGyroJerk-arCoeff()-X,4"         
## [190] "tBodyGyroJerk-arCoeff()-Y,1"         
## [191] "tBodyGyroJerk-arCoeff()-Y,2"         
## [192] "tBodyGyroJerk-arCoeff()-Y,3"         
## [193] "tBodyGyroJerk-arCoeff()-Y,4"         
## [194] "tBodyGyroJerk-arCoeff()-Z,1"         
## [195] "tBodyGyroJerk-arCoeff()-Z,2"         
## [196] "tBodyGyroJerk-arCoeff()-Z,3"         
## [197] "tBodyGyroJerk-arCoeff()-Z,4"         
## [198] "tBodyGyroJerk-correlation()-X,Y"     
## [199] "tBodyGyroJerk-correlation()-X,Z"     
## [200] "tBodyGyroJerk-correlation()-Y,Z"     
## [201] "tBodyAccMag-mean()"                  
## [202] "tBodyAccMag-std()"                   
## [203] "tBodyAccMag-mad()"                   
## [204] "tBodyAccMag-max()"                   
## [205] "tBodyAccMag-min()"                   
## [206] "tBodyAccMag-sma()"                   
## [207] "tBodyAccMag-energy()"                
## [208] "tBodyAccMag-iqr()"                   
## [209] "tBodyAccMag-entropy()"               
## [210] "tBodyAccMag-arCoeff()1"              
## [211] "tBodyAccMag-arCoeff()2"              
## [212] "tBodyAccMag-arCoeff()3"              
## [213] "tBodyAccMag-arCoeff()4"              
## [214] "tGravityAccMag-mean()"               
## [215] "tGravityAccMag-std()"                
## [216] "tGravityAccMag-mad()"                
## [217] "tGravityAccMag-max()"                
## [218] "tGravityAccMag-min()"                
## [219] "tGravityAccMag-sma()"                
## [220] "tGravityAccMag-energy()"             
## [221] "tGravityAccMag-iqr()"                
## [222] "tGravityAccMag-entropy()"            
## [223] "tGravityAccMag-arCoeff()1"           
## [224] "tGravityAccMag-arCoeff()2"           
## [225] "tGravityAccMag-arCoeff()3"           
## [226] "tGravityAccMag-arCoeff()4"           
## [227] "tBodyAccJerkMag-mean()"              
## [228] "tBodyAccJerkMag-std()"               
## [229] "tBodyAccJerkMag-mad()"               
## [230] "tBodyAccJerkMag-max()"               
## [231] "tBodyAccJerkMag-min()"               
## [232] "tBodyAccJerkMag-sma()"               
## [233] "tBodyAccJerkMag-energy()"            
## [234] "tBodyAccJerkMag-iqr()"               
## [235] "tBodyAccJerkMag-entropy()"           
## [236] "tBodyAccJerkMag-arCoeff()1"          
## [237] "tBodyAccJerkMag-arCoeff()2"          
## [238] "tBodyAccJerkMag-arCoeff()3"          
## [239] "tBodyAccJerkMag-arCoeff()4"          
## [240] "tBodyGyroMag-mean()"                 
## [241] "tBodyGyroMag-std()"                  
## [242] "tBodyGyroMag-mad()"                  
## [243] "tBodyGyroMag-max()"                  
## [244] "tBodyGyroMag-min()"                  
## [245] "tBodyGyroMag-sma()"                  
## [246] "tBodyGyroMag-energy()"               
## [247] "tBodyGyroMag-iqr()"                  
## [248] "tBodyGyroMag-entropy()"              
## [249] "tBodyGyroMag-arCoeff()1"             
## [250] "tBodyGyroMag-arCoeff()2"             
## [251] "tBodyGyroMag-arCoeff()3"             
## [252] "tBodyGyroMag-arCoeff()4"             
## [253] "tBodyGyroJerkMag-mean()"             
## [254] "tBodyGyroJerkMag-std()"              
## [255] "tBodyGyroJerkMag-mad()"              
## [256] "tBodyGyroJerkMag-max()"              
## [257] "tBodyGyroJerkMag-min()"              
## [258] "tBodyGyroJerkMag-sma()"              
## [259] "tBodyGyroJerkMag-energy()"           
## [260] "tBodyGyroJerkMag-iqr()"              
## [261] "tBodyGyroJerkMag-entropy()"          
## [262] "tBodyGyroJerkMag-arCoeff()1"         
## [263] "tBodyGyroJerkMag-arCoeff()2"         
## [264] "tBodyGyroJerkMag-arCoeff()3"         
## [265] "tBodyGyroJerkMag-arCoeff()4"         
## [266] "fBodyAcc-mean()-X"                   
## [267] "fBodyAcc-mean()-Y"                   
## [268] "fBodyAcc-mean()-Z"                   
## [269] "fBodyAcc-std()-X"                    
## [270] "fBodyAcc-std()-Y"                    
## [271] "fBodyAcc-std()-Z"                    
## [272] "fBodyAcc-mad()-X"                    
## [273] "fBodyAcc-mad()-Y"                    
## [274] "fBodyAcc-mad()-Z"                    
## [275] "fBodyAcc-max()-X"                    
## [276] "fBodyAcc-max()-Y"                    
## [277] "fBodyAcc-max()-Z"                    
## [278] "fBodyAcc-min()-X"                    
## [279] "fBodyAcc-min()-Y"                    
## [280] "fBodyAcc-min()-Z"                    
## [281] "fBodyAcc-sma()"                      
## [282] "fBodyAcc-energy()-X"                 
## [283] "fBodyAcc-energy()-Y"                 
## [284] "fBodyAcc-energy()-Z"                 
## [285] "fBodyAcc-iqr()-X"                    
## [286] "fBodyAcc-iqr()-Y"                    
## [287] "fBodyAcc-iqr()-Z"                    
## [288] "fBodyAcc-entropy()-X"                
## [289] "fBodyAcc-entropy()-Y"                
## [290] "fBodyAcc-entropy()-Z"                
## [291] "fBodyAcc-maxInds-X"                  
## [292] "fBodyAcc-maxInds-Y"                  
## [293] "fBodyAcc-maxInds-Z"                  
## [294] "fBodyAcc-meanFreq()-X"               
## [295] "fBodyAcc-meanFreq()-Y"               
## [296] "fBodyAcc-meanFreq()-Z"               
## [297] "fBodyAcc-skewness()-X"               
## [298] "fBodyAcc-kurtosis()-X"               
## [299] "fBodyAcc-skewness()-Y"               
## [300] "fBodyAcc-kurtosis()-Y"               
## [301] "fBodyAcc-skewness()-Z"               
## [302] "fBodyAcc-kurtosis()-Z"               
## [303] "fBodyAcc-bandsEnergy()-1,8"          
## [304] "fBodyAcc-bandsEnergy()-9,16"         
## [305] "fBodyAcc-bandsEnergy()-17,24"        
## [306] "fBodyAcc-bandsEnergy()-25,32"        
## [307] "fBodyAcc-bandsEnergy()-33,40"        
## [308] "fBodyAcc-bandsEnergy()-41,48"        
## [309] "fBodyAcc-bandsEnergy()-49,56"        
## [310] "fBodyAcc-bandsEnergy()-57,64"        
## [311] "fBodyAcc-bandsEnergy()-1,16"         
## [312] "fBodyAcc-bandsEnergy()-17,32"        
## [313] "fBodyAcc-bandsEnergy()-33,48"        
## [314] "fBodyAcc-bandsEnergy()-49,64"        
## [315] "fBodyAcc-bandsEnergy()-1,24"         
## [316] "fBodyAcc-bandsEnergy()-25,48"        
## [317] "fBodyAcc-bandsEnergy()-1,8"          
## [318] "fBodyAcc-bandsEnergy()-9,16"         
## [319] "fBodyAcc-bandsEnergy()-17,24"        
## [320] "fBodyAcc-bandsEnergy()-25,32"        
## [321] "fBodyAcc-bandsEnergy()-33,40"        
## [322] "fBodyAcc-bandsEnergy()-41,48"        
## [323] "fBodyAcc-bandsEnergy()-49,56"        
## [324] "fBodyAcc-bandsEnergy()-57,64"        
## [325] "fBodyAcc-bandsEnergy()-1,16"         
## [326] "fBodyAcc-bandsEnergy()-17,32"        
## [327] "fBodyAcc-bandsEnergy()-33,48"        
## [328] "fBodyAcc-bandsEnergy()-49,64"        
## [329] "fBodyAcc-bandsEnergy()-1,24"         
## [330] "fBodyAcc-bandsEnergy()-25,48"        
## [331] "fBodyAcc-bandsEnergy()-1,8"          
## [332] "fBodyAcc-bandsEnergy()-9,16"         
## [333] "fBodyAcc-bandsEnergy()-17,24"        
## [334] "fBodyAcc-bandsEnergy()-25,32"        
## [335] "fBodyAcc-bandsEnergy()-33,40"        
## [336] "fBodyAcc-bandsEnergy()-41,48"        
## [337] "fBodyAcc-bandsEnergy()-49,56"        
## [338] "fBodyAcc-bandsEnergy()-57,64"        
## [339] "fBodyAcc-bandsEnergy()-1,16"         
## [340] "fBodyAcc-bandsEnergy()-17,32"        
## [341] "fBodyAcc-bandsEnergy()-33,48"        
## [342] "fBodyAcc-bandsEnergy()-49,64"        
## [343] "fBodyAcc-bandsEnergy()-1,24"         
## [344] "fBodyAcc-bandsEnergy()-25,48"        
## [345] "fBodyAccJerk-mean()-X"               
## [346] "fBodyAccJerk-mean()-Y"               
## [347] "fBodyAccJerk-mean()-Z"               
## [348] "fBodyAccJerk-std()-X"                
## [349] "fBodyAccJerk-std()-Y"                
## [350] "fBodyAccJerk-std()-Z"                
## [351] "fBodyAccJerk-mad()-X"                
## [352] "fBodyAccJerk-mad()-Y"                
## [353] "fBodyAccJerk-mad()-Z"                
## [354] "fBodyAccJerk-max()-X"                
## [355] "fBodyAccJerk-max()-Y"                
## [356] "fBodyAccJerk-max()-Z"                
## [357] "fBodyAccJerk-min()-X"                
## [358] "fBodyAccJerk-min()-Y"                
## [359] "fBodyAccJerk-min()-Z"                
## [360] "fBodyAccJerk-sma()"                  
## [361] "fBodyAccJerk-energy()-X"             
## [362] "fBodyAccJerk-energy()-Y"             
## [363] "fBodyAccJerk-energy()-Z"             
## [364] "fBodyAccJerk-iqr()-X"                
## [365] "fBodyAccJerk-iqr()-Y"                
## [366] "fBodyAccJerk-iqr()-Z"                
## [367] "fBodyAccJerk-entropy()-X"            
## [368] "fBodyAccJerk-entropy()-Y"            
## [369] "fBodyAccJerk-entropy()-Z"            
## [370] "fBodyAccJerk-maxInds-X"              
## [371] "fBodyAccJerk-maxInds-Y"              
## [372] "fBodyAccJerk-maxInds-Z"              
## [373] "fBodyAccJerk-meanFreq()-X"           
## [374] "fBodyAccJerk-meanFreq()-Y"           
## [375] "fBodyAccJerk-meanFreq()-Z"           
## [376] "fBodyAccJerk-skewness()-X"           
## [377] "fBodyAccJerk-kurtosis()-X"           
## [378] "fBodyAccJerk-skewness()-Y"           
## [379] "fBodyAccJerk-kurtosis()-Y"           
## [380] "fBodyAccJerk-skewness()-Z"           
## [381] "fBodyAccJerk-kurtosis()-Z"           
## [382] "fBodyAccJerk-bandsEnergy()-1,8"      
## [383] "fBodyAccJerk-bandsEnergy()-9,16"     
## [384] "fBodyAccJerk-bandsEnergy()-17,24"    
## [385] "fBodyAccJerk-bandsEnergy()-25,32"    
## [386] "fBodyAccJerk-bandsEnergy()-33,40"    
## [387] "fBodyAccJerk-bandsEnergy()-41,48"    
## [388] "fBodyAccJerk-bandsEnergy()-49,56"    
## [389] "fBodyAccJerk-bandsEnergy()-57,64"    
## [390] "fBodyAccJerk-bandsEnergy()-1,16"     
## [391] "fBodyAccJerk-bandsEnergy()-17,32"    
## [392] "fBodyAccJerk-bandsEnergy()-33,48"    
## [393] "fBodyAccJerk-bandsEnergy()-49,64"    
## [394] "fBodyAccJerk-bandsEnergy()-1,24"     
## [395] "fBodyAccJerk-bandsEnergy()-25,48"    
## [396] "fBodyAccJerk-bandsEnergy()-1,8"      
## [397] "fBodyAccJerk-bandsEnergy()-9,16"     
## [398] "fBodyAccJerk-bandsEnergy()-17,24"    
## [399] "fBodyAccJerk-bandsEnergy()-25,32"    
## [400] "fBodyAccJerk-bandsEnergy()-33,40"    
## [401] "fBodyAccJerk-bandsEnergy()-41,48"    
## [402] "fBodyAccJerk-bandsEnergy()-49,56"    
## [403] "fBodyAccJerk-bandsEnergy()-57,64"    
## [404] "fBodyAccJerk-bandsEnergy()-1,16"     
## [405] "fBodyAccJerk-bandsEnergy()-17,32"    
## [406] "fBodyAccJerk-bandsEnergy()-33,48"    
## [407] "fBodyAccJerk-bandsEnergy()-49,64"    
## [408] "fBodyAccJerk-bandsEnergy()-1,24"     
## [409] "fBodyAccJerk-bandsEnergy()-25,48"    
## [410] "fBodyAccJerk-bandsEnergy()-1,8"      
## [411] "fBodyAccJerk-bandsEnergy()-9,16"     
## [412] "fBodyAccJerk-bandsEnergy()-17,24"    
## [413] "fBodyAccJerk-bandsEnergy()-25,32"    
## [414] "fBodyAccJerk-bandsEnergy()-33,40"    
## [415] "fBodyAccJerk-bandsEnergy()-41,48"    
## [416] "fBodyAccJerk-bandsEnergy()-49,56"    
## [417] "fBodyAccJerk-bandsEnergy()-57,64"    
## [418] "fBodyAccJerk-bandsEnergy()-1,16"     
## [419] "fBodyAccJerk-bandsEnergy()-17,32"    
## [420] "fBodyAccJerk-bandsEnergy()-33,48"    
## [421] "fBodyAccJerk-bandsEnergy()-49,64"    
## [422] "fBodyAccJerk-bandsEnergy()-1,24"     
## [423] "fBodyAccJerk-bandsEnergy()-25,48"    
## [424] "fBodyGyro-mean()-X"                  
## [425] "fBodyGyro-mean()-Y"                  
## [426] "fBodyGyro-mean()-Z"                  
## [427] "fBodyGyro-std()-X"                   
## [428] "fBodyGyro-std()-Y"                   
## [429] "fBodyGyro-std()-Z"                   
## [430] "fBodyGyro-mad()-X"                   
## [431] "fBodyGyro-mad()-Y"                   
## [432] "fBodyGyro-mad()-Z"                   
## [433] "fBodyGyro-max()-X"                   
## [434] "fBodyGyro-max()-Y"                   
## [435] "fBodyGyro-max()-Z"                   
## [436] "fBodyGyro-min()-X"                   
## [437] "fBodyGyro-min()-Y"                   
## [438] "fBodyGyro-min()-Z"                   
## [439] "fBodyGyro-sma()"                     
## [440] "fBodyGyro-energy()-X"                
## [441] "fBodyGyro-energy()-Y"                
## [442] "fBodyGyro-energy()-Z"                
## [443] "fBodyGyro-iqr()-X"                   
## [444] "fBodyGyro-iqr()-Y"                   
## [445] "fBodyGyro-iqr()-Z"                   
## [446] "fBodyGyro-entropy()-X"               
## [447] "fBodyGyro-entropy()-Y"               
## [448] "fBodyGyro-entropy()-Z"               
## [449] "fBodyGyro-maxInds-X"                 
## [450] "fBodyGyro-maxInds-Y"                 
## [451] "fBodyGyro-maxInds-Z"                 
## [452] "fBodyGyro-meanFreq()-X"              
## [453] "fBodyGyro-meanFreq()-Y"              
## [454] "fBodyGyro-meanFreq()-Z"              
## [455] "fBodyGyro-skewness()-X"              
## [456] "fBodyGyro-kurtosis()-X"              
## [457] "fBodyGyro-skewness()-Y"              
## [458] "fBodyGyro-kurtosis()-Y"              
## [459] "fBodyGyro-skewness()-Z"              
## [460] "fBodyGyro-kurtosis()-Z"              
## [461] "fBodyGyro-bandsEnergy()-1,8"         
## [462] "fBodyGyro-bandsEnergy()-9,16"        
## [463] "fBodyGyro-bandsEnergy()-17,24"       
## [464] "fBodyGyro-bandsEnergy()-25,32"       
## [465] "fBodyGyro-bandsEnergy()-33,40"       
## [466] "fBodyGyro-bandsEnergy()-41,48"       
## [467] "fBodyGyro-bandsEnergy()-49,56"       
## [468] "fBodyGyro-bandsEnergy()-57,64"       
## [469] "fBodyGyro-bandsEnergy()-1,16"        
## [470] "fBodyGyro-bandsEnergy()-17,32"       
## [471] "fBodyGyro-bandsEnergy()-33,48"       
## [472] "fBodyGyro-bandsEnergy()-49,64"       
## [473] "fBodyGyro-bandsEnergy()-1,24"        
## [474] "fBodyGyro-bandsEnergy()-25,48"       
## [475] "fBodyGyro-bandsEnergy()-1,8"         
## [476] "fBodyGyro-bandsEnergy()-9,16"        
## [477] "fBodyGyro-bandsEnergy()-17,24"       
## [478] "fBodyGyro-bandsEnergy()-25,32"       
## [479] "fBodyGyro-bandsEnergy()-33,40"       
## [480] "fBodyGyro-bandsEnergy()-41,48"       
## [481] "fBodyGyro-bandsEnergy()-49,56"       
## [482] "fBodyGyro-bandsEnergy()-57,64"       
## [483] "fBodyGyro-bandsEnergy()-1,16"        
## [484] "fBodyGyro-bandsEnergy()-17,32"       
## [485] "fBodyGyro-bandsEnergy()-33,48"       
## [486] "fBodyGyro-bandsEnergy()-49,64"       
## [487] "fBodyGyro-bandsEnergy()-1,24"        
## [488] "fBodyGyro-bandsEnergy()-25,48"       
## [489] "fBodyGyro-bandsEnergy()-1,8"         
## [490] "fBodyGyro-bandsEnergy()-9,16"        
## [491] "fBodyGyro-bandsEnergy()-17,24"       
## [492] "fBodyGyro-bandsEnergy()-25,32"       
## [493] "fBodyGyro-bandsEnergy()-33,40"       
## [494] "fBodyGyro-bandsEnergy()-41,48"       
## [495] "fBodyGyro-bandsEnergy()-49,56"       
## [496] "fBodyGyro-bandsEnergy()-57,64"       
## [497] "fBodyGyro-bandsEnergy()-1,16"        
## [498] "fBodyGyro-bandsEnergy()-17,32"       
## [499] "fBodyGyro-bandsEnergy()-33,48"       
## [500] "fBodyGyro-bandsEnergy()-49,64"       
## [501] "fBodyGyro-bandsEnergy()-1,24"        
## [502] "fBodyGyro-bandsEnergy()-25,48"       
## [503] "fBodyAccMag-mean()"                  
## [504] "fBodyAccMag-std()"                   
## [505] "fBodyAccMag-mad()"                   
## [506] "fBodyAccMag-max()"                   
## [507] "fBodyAccMag-min()"                   
## [508] "fBodyAccMag-sma()"                   
## [509] "fBodyAccMag-energy()"                
## [510] "fBodyAccMag-iqr()"                   
## [511] "fBodyAccMag-entropy()"               
## [512] "fBodyAccMag-maxInds"                 
## [513] "fBodyAccMag-meanFreq()"              
## [514] "fBodyAccMag-skewness()"              
## [515] "fBodyAccMag-kurtosis()"              
## [516] "fBodyBodyAccJerkMag-mean()"          
## [517] "fBodyBodyAccJerkMag-std()"           
## [518] "fBodyBodyAccJerkMag-mad()"           
## [519] "fBodyBodyAccJerkMag-max()"           
## [520] "fBodyBodyAccJerkMag-min()"           
## [521] "fBodyBodyAccJerkMag-sma()"           
## [522] "fBodyBodyAccJerkMag-energy()"        
## [523] "fBodyBodyAccJerkMag-iqr()"           
## [524] "fBodyBodyAccJerkMag-entropy()"       
## [525] "fBodyBodyAccJerkMag-maxInds"         
## [526] "fBodyBodyAccJerkMag-meanFreq()"      
## [527] "fBodyBodyAccJerkMag-skewness()"      
## [528] "fBodyBodyAccJerkMag-kurtosis()"      
## [529] "fBodyBodyGyroMag-mean()"             
## [530] "fBodyBodyGyroMag-std()"              
## [531] "fBodyBodyGyroMag-mad()"              
## [532] "fBodyBodyGyroMag-max()"              
## [533] "fBodyBodyGyroMag-min()"              
## [534] "fBodyBodyGyroMag-sma()"              
## [535] "fBodyBodyGyroMag-energy()"           
## [536] "fBodyBodyGyroMag-iqr()"              
## [537] "fBodyBodyGyroMag-entropy()"          
## [538] "fBodyBodyGyroMag-maxInds"            
## [539] "fBodyBodyGyroMag-meanFreq()"         
## [540] "fBodyBodyGyroMag-skewness()"         
## [541] "fBodyBodyGyroMag-kurtosis()"         
## [542] "fBodyBodyGyroJerkMag-mean()"         
## [543] "fBodyBodyGyroJerkMag-std()"          
## [544] "fBodyBodyGyroJerkMag-mad()"          
## [545] "fBodyBodyGyroJerkMag-max()"          
## [546] "fBodyBodyGyroJerkMag-min()"          
## [547] "fBodyBodyGyroJerkMag-sma()"          
## [548] "fBodyBodyGyroJerkMag-energy()"       
## [549] "fBodyBodyGyroJerkMag-iqr()"          
## [550] "fBodyBodyGyroJerkMag-entropy()"      
## [551] "fBodyBodyGyroJerkMag-maxInds"        
## [552] "fBodyBodyGyroJerkMag-meanFreq()"     
## [553] "fBodyBodyGyroJerkMag-skewness()"     
## [554] "fBodyBodyGyroJerkMag-kurtosis()"     
## [555] "angle(tBodyAccMean,gravity)"         
## [556] "angle(tBodyAccJerkMean),gravityMean)"
## [557] "angle(tBodyGyroMean,gravityMean)"    
## [558] "angle(tBodyGyroJerkMean,gravityMean)"
## [559] "angle(X,gravityMean)"                
## [560] "angle(Y,gravityMean)"                
## [561] "angle(Z,gravityMean)"
```

## **activity_labels**  
The second column of this data frame contains the names of the six activities of daily living performed by the volunteers while wearing a smartphone on their waists. These six are values/factors of the variable "Activity" that we will setup later in our tidy data set. Later, we will use these names to replace the integer (1 to 6) values recorded in **Y_train** and **Y_test**.  


```r
str(activity_labels)
```

```
## 'data.frame':	6 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6
##  $ V2: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
```

```r
activity_labels[[2]]
```

```
## [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
## [4] "SITTING"            "STANDING"           "LAYING"
```

## **subject_train**
This object contains 7,352 rows of integer values from 1 to 30. Each row identifies the subject who performed the activity for each window sample in the training set. When we assemble our tidy data set later, we'd like the column name of this data frame to be the variable "Subject".  


```r
str(subject_train)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
```

```r
unique(subject_train[[1]])
```

```
##  [1]  1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
```

## **X_train**  
This training set is a data frame of 7,352 rows over 561 columns/variables/features. In our tidy data set, we'll use the **features_labels** above to replace the peculiar column names of this data frame.  


```r
str(X_train)
```

```
## 'data.frame':	7352 obs. of  561 variables:
##  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
##  $ V11 : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
##  $ V12 : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
##  $ V13 : num  0.853 0.849 0.844 0.844 0.849 ...
##  $ V14 : num  0.686 0.686 0.682 0.682 0.683 ...
##  $ V15 : num  0.814 0.823 0.839 0.838 0.838 ...
##  $ V16 : num  -0.966 -0.982 -0.983 -0.986 -0.993 ...
##  $ V17 : num  -1 -1 -1 -1 -1 ...
##  $ V18 : num  -1 -1 -1 -1 -1 ...
##  $ V19 : num  -0.995 -0.998 -0.999 -1 -1 ...
##  $ V20 : num  -0.994 -0.999 -0.997 -0.997 -0.998 ...
##  $ V21 : num  -0.988 -0.978 -0.965 -0.984 -0.981 ...
##  $ V22 : num  -0.943 -0.948 -0.975 -0.986 -0.991 ...
##  $ V23 : num  -0.408 -0.715 -0.592 -0.627 -0.787 ...
##  $ V24 : num  -0.679 -0.501 -0.486 -0.851 -0.559 ...
##  $ V25 : num  -0.602 -0.571 -0.571 -0.912 -0.761 ...
##  $ V26 : num  0.9293 0.6116 0.273 0.0614 0.3133 ...
##  $ V27 : num  -0.853 -0.3295 -0.0863 0.0748 -0.1312 ...
##  $ V28 : num  0.36 0.284 0.337 0.198 0.191 ...
##  $ V29 : num  -0.0585 0.2846 -0.1647 -0.2643 0.0869 ...
##  $ V30 : num  0.2569 0.1157 0.0172 0.0725 0.2576 ...
##  $ V31 : num  -0.2248 -0.091 -0.0745 -0.1553 -0.2725 ...
##  $ V32 : num  0.264 0.294 0.342 0.323 0.435 ...
##  $ V33 : num  -0.0952 -0.2812 -0.3326 -0.1708 -0.3154 ...
##  $ V34 : num  0.279 0.086 0.239 0.295 0.44 ...
##  $ V35 : num  -0.4651 -0.0222 -0.1362 -0.3061 -0.2691 ...
##  $ V36 : num  0.4919 -0.0167 0.1739 0.4821 0.1794 ...
##  $ V37 : num  -0.191 -0.221 -0.299 -0.47 -0.089 ...
##  $ V38 : num  0.3763 -0.0134 -0.1247 -0.3057 -0.1558 ...
##  $ V39 : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
##  $ V40 : num  0.661 0.579 0.609 0.507 0.599 ...
##  $ V41 : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ V42 : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ V43 : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ V44 : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ V45 : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ V46 : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ V47 : num  -0.985 -0.998 -1 -0.996 -0.998 ...
##  $ V48 : num  -0.984 -0.99 -0.993 -0.981 -0.989 ...
##  $ V49 : num  -0.895 -0.933 -0.993 -0.978 -0.979 ...
##  $ V50 : num  0.892 0.892 0.892 0.894 0.894 ...
##  $ V51 : num  -0.161 -0.161 -0.164 -0.164 -0.167 ...
##  $ V52 : num  0.1247 0.1226 0.0946 0.0934 0.0917 ...
##  $ V53 : num  0.977 0.985 0.987 0.987 0.987 ...
##  $ V54 : num  -0.123 -0.115 -0.115 -0.121 -0.122 ...
##  $ V55 : num  0.0565 0.1028 0.1028 0.0958 0.0941 ...
##  $ V56 : num  -0.375 -0.383 -0.402 -0.4 -0.4 ...
##  $ V57 : num  0.899 0.908 0.909 0.911 0.912 ...
##  $ V58 : num  -0.971 -0.971 -0.97 -0.969 -0.967 ...
##  $ V59 : num  -0.976 -0.979 -0.982 -0.982 -0.984 ...
##  $ V60 : num  -0.984 -0.999 -1 -0.996 -0.998 ...
##  $ V61 : num  -0.989 -0.99 -0.992 -0.981 -0.991 ...
##  $ V62 : num  -0.918 -0.942 -0.993 -0.98 -0.98 ...
##  $ V63 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V64 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V65 : num  0.114 -0.21 -0.927 -0.596 -0.617 ...
##  $ V66 : num  -0.59042 -0.41006 0.00223 -0.06493 -0.25727 ...
##  $ V67 : num  0.5911 0.4139 0.0275 0.0754 0.2689 ...
##  $ V68 : num  -0.5918 -0.4176 -0.0567 -0.0858 -0.2807 ...
##  $ V69 : num  0.5925 0.4213 0.0855 0.0962 0.2926 ...
##  $ V70 : num  -0.745 -0.196 -0.329 -0.295 -0.167 ...
##  $ V71 : num  0.7209 0.1253 0.2705 0.2283 0.0899 ...
##  $ V72 : num  -0.7124 -0.1056 -0.2545 -0.2063 -0.0663 ...
##  $ V73 : num  0.7113 0.1091 0.2576 0.2048 0.0671 ...
##  $ V74 : num  -0.995 -0.834 -0.705 -0.385 -0.237 ...
##  $ V75 : num  0.996 0.834 0.714 0.386 0.239 ...
##  $ V76 : num  -0.996 -0.834 -0.723 -0.387 -0.241 ...
##  $ V77 : num  0.992 0.83 0.729 0.385 0.241 ...
##  $ V78 : num  0.57 -0.831 -0.181 -0.991 -0.408 ...
##  $ V79 : num  0.439 -0.866 0.338 -0.969 -0.185 ...
##  $ V80 : num  0.987 0.974 0.643 0.984 0.965 ...
##  $ V81 : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ V82 : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ V83 : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ V84 : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ V85 : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ V86 : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ V87 : num  -0.994 -0.996 -0.991 -0.994 -0.997 ...
##  $ V88 : num  -0.986 -0.979 -0.979 -0.986 -0.987 ...
##  $ V89 : num  -0.993 -0.991 -0.987 -0.991 -0.991 ...
##  $ V90 : num  -0.985 -0.995 -0.987 -0.987 -0.997 ...
##  $ V91 : num  -0.992 -0.979 -0.979 -0.992 -0.992 ...
##  $ V92 : num  -0.993 -0.992 -0.992 -0.99 -0.99 ...
##  $ V93 : num  0.99 0.993 0.988 0.988 0.994 ...
##  $ V94 : num  0.992 0.992 0.992 0.993 0.993 ...
##  $ V95 : num  0.991 0.989 0.989 0.993 0.986 ...
##  $ V96 : num  -0.994 -0.991 -0.988 -0.993 -0.994 ...
##  $ V97 : num  -1 -1 -1 -1 -1 ...
##  $ V98 : num  -1 -1 -1 -1 -1 ...
##  $ V99 : num  -1 -1 -1 -1 -1 ...
##   [list output truncated]
```

## **Y_train**  
This object contains 7,352 rows of integer values from 1 to 6. Each row identifies the type of the variable "Activity" performed for each window sample in the training set. As mentioned above, in our tidy data set, we'll replace these integer values with their respective descriptive names from **activity_labels**. 


```r
str(Y_train)
```

```
## 'data.frame':	7352 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
unique(Y_train[[1]])
```

```
## [1] 5 4 6 1 3 2
```

## **subject_test**
This object contains 2,947 rows of integer values from 1 to 30. Each row identifies the subject who performed the activity for each window sample in the test set. When we assemble our tidy data set later, we'll append this data frame to the bottom of **subject_train**.  


```r
str(subject_test)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
```

```r
unique(subject_test[[1]])
```

```
## [1]  2  4  9 10 12 13 18 20 24
```

## **X_test**  
This test set is a data frame of 2,947 rows over 561 columns/variables/features. In our tidy data set, we'll append this data frame to the bottom of **X_train**.  


```r
str(X_test)
```

```
## 'data.frame':	2947 obs. of  561 variables:
##  $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
##  $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
##  $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
##  $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
##  $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
##  $ V6  : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
##  $ V7  : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
##  $ V8  : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
##  $ V9  : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
##  $ V10 : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
##  $ V11 : num  -0.555 -0.555 -0.569 -0.569 -0.561 ...
##  $ V12 : num  -0.466 -0.806 -0.799 -0.799 -0.826 ...
##  $ V13 : num  0.717 0.768 0.848 0.848 0.849 ...
##  $ V14 : num  0.636 0.684 0.668 0.668 0.671 ...
##  $ V15 : num  0.789 0.797 0.822 0.822 0.83 ...
##  $ V16 : num  -0.878 -0.969 -0.977 -0.974 -0.975 ...
##  $ V17 : num  -0.998 -1 -1 -1 -1 ...
##  $ V18 : num  -0.998 -1 -1 -0.999 -0.999 ...
##  $ V19 : num  -0.934 -0.998 -0.999 -0.999 -0.999 ...
##  $ V20 : num  -0.976 -0.994 -0.993 -0.995 -0.993 ...
##  $ V21 : num  -0.95 -0.974 -0.974 -0.979 -0.967 ...
##  $ V22 : num  -0.83 -0.951 -0.965 -0.97 -0.976 ...
##  $ V23 : num  -0.168 -0.302 -0.618 -0.75 -0.591 ...
##  $ V24 : num  -0.379 -0.348 -0.695 -0.899 -0.74 ...
##  $ V25 : num  0.246 -0.405 -0.537 -0.554 -0.799 ...
##  $ V26 : num  0.521 0.507 0.242 0.175 0.116 ...
##  $ V27 : num  -0.4878 -0.1565 -0.115 -0.0513 -0.0289 ...
##  $ V28 : num  0.4823 0.0407 0.0327 0.0342 -0.0328 ...
##  $ V29 : num  -0.0455 0.273 0.1924 0.1536 0.2943 ...
##  $ V30 : num  0.21196 0.19757 -0.01194 0.03077 0.00063 ...
##  $ V31 : num  -0.1349 -0.1946 -0.0634 -0.1293 -0.0453 ...
##  $ V32 : num  0.131 0.411 0.471 0.446 0.168 ...
##  $ V33 : num  -0.0142 -0.3405 -0.5074 -0.4195 -0.0682 ...
##  $ V34 : num  -0.106 0.0776 0.1885 0.2715 0.0744 ...
##  $ V35 : num  0.0735 -0.084 -0.2316 -0.2258 0.0271 ...
##  $ V36 : num  -0.1715 0.0353 0.6321 0.4164 -0.1459 ...
##  $ V37 : num  0.0401 -0.0101 -0.5507 -0.2864 -0.0502 ...
##  $ V38 : num  0.077 -0.105 0.3057 -0.0638 0.2352 ...
##  $ V39 : num  -0.491 -0.429 -0.324 -0.167 0.29 ...
##  $ V40 : num  -0.709 0.399 0.28 0.545 0.458 ...
##  $ V41 : num  0.936 0.927 0.93 0.929 0.927 ...
##  $ V42 : num  -0.283 -0.289 -0.288 -0.293 -0.303 ...
##  $ V43 : num  0.115 0.153 0.146 0.143 0.138 ...
##  $ V44 : num  -0.925 -0.989 -0.996 -0.993 -0.996 ...
##  $ V45 : num  -0.937 -0.984 -0.988 -0.97 -0.971 ...
##  $ V46 : num  -0.564 -0.965 -0.982 -0.992 -0.968 ...
##  $ V47 : num  -0.93 -0.989 -0.996 -0.993 -0.996 ...
##  $ V48 : num  -0.938 -0.983 -0.989 -0.971 -0.971 ...
##  $ V49 : num  -0.606 -0.965 -0.98 -0.993 -0.969 ...
##  $ V50 : num  0.906 0.856 0.856 0.856 0.854 ...
##  $ V51 : num  -0.279 -0.305 -0.305 -0.305 -0.313 ...
##  $ V52 : num  0.153 0.153 0.139 0.136 0.134 ...
##  $ V53 : num  0.944 0.944 0.949 0.947 0.946 ...
##  $ V54 : num  -0.262 -0.262 -0.262 -0.273 -0.279 ...
##  $ V55 : num  -0.0762 0.149 0.145 0.1421 0.1309 ...
##  $ V56 : num  -0.0178 0.0577 0.0406 0.0461 0.0554 ...
##  $ V57 : num  0.829 0.806 0.812 0.809 0.804 ...
##  $ V58 : num  -0.865 -0.858 -0.86 -0.854 -0.843 ...
##  $ V59 : num  -0.968 -0.957 -0.961 -0.963 -0.965 ...
##  $ V60 : num  -0.95 -0.988 -0.996 -0.992 -0.996 ...
##  $ V61 : num  -0.946 -0.982 -0.99 -0.973 -0.972 ...
##  $ V62 : num  -0.76 -0.971 -0.979 -0.996 -0.969 ...
##  $ V63 : num  -0.425 -0.729 -0.823 -0.823 -0.83 ...
##  $ V64 : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ V65 : num  0.219 -0.465 -0.53 -0.7 -0.302 ...
##  $ V66 : num  -0.43 -0.51 -0.295 -0.343 -0.482 ...
##  $ V67 : num  0.431 0.525 0.305 0.359 0.539 ...
##  $ V68 : num  -0.432 -0.54 -0.315 -0.375 -0.596 ...
##  $ V69 : num  0.433 0.554 0.326 0.392 0.655 ...
##  $ V70 : num  -0.795 -0.746 -0.232 -0.233 -0.493 ...
##  $ V71 : num  0.781 0.733 0.169 0.176 0.463 ...
##  $ V72 : num  -0.78 -0.737 -0.155 -0.169 -0.465 ...
##  $ V73 : num  0.785 0.749 0.164 0.185 0.483 ...
##  $ V74 : num  -0.984 -0.845 -0.429 -0.297 -0.536 ...
##  $ V75 : num  0.987 0.869 0.44 0.304 0.544 ...
##  $ V76 : num  -0.989 -0.893 -0.451 -0.311 -0.553 ...
##  $ V77 : num  0.988 0.913 0.458 0.315 0.559 ...
##  $ V78 : num  0.981 0.945 0.548 0.986 0.998 ...
##  $ V79 : num  -0.996 -0.911 -0.335 0.653 0.916 ...
##  $ V80 : num  -0.96 -0.739 0.59 0.747 0.929 ...
##  $ V81 : num  0.072 0.0702 0.0694 0.0749 0.0784 ...
##  $ V82 : num  0.04575 -0.01788 -0.00491 0.03227 0.02228 ...
##  $ V83 : num  -0.10604 -0.00172 -0.01367 0.01214 0.00275 ...
##  $ V84 : num  -0.907 -0.949 -0.991 -0.991 -0.992 ...
##  $ V85 : num  -0.938 -0.973 -0.971 -0.973 -0.979 ...
##  $ V86 : num  -0.936 -0.978 -0.973 -0.976 -0.987 ...
##  $ V87 : num  -0.916 -0.969 -0.991 -0.99 -0.991 ...
##  $ V88 : num  -0.937 -0.974 -0.973 -0.973 -0.977 ...
##  $ V89 : num  -0.949 -0.979 -0.975 -0.978 -0.985 ...
##  $ V90 : num  -0.903 -0.915 -0.992 -0.992 -0.994 ...
##  $ V91 : num  -0.95 -0.981 -0.975 -0.975 -0.986 ...
##  $ V92 : num  -0.891 -0.978 -0.962 -0.962 -0.986 ...
##  $ V93 : num  0.898 0.898 0.994 0.994 0.994 ...
##  $ V94 : num  0.95 0.968 0.976 0.976 0.98 ...
##  $ V95 : num  0.946 0.966 0.966 0.97 0.985 ...
##  $ V96 : num  -0.931 -0.974 -0.982 -0.983 -0.987 ...
##  $ V97 : num  -0.995 -0.998 -1 -1 -1 ...
##  $ V98 : num  -0.997 -0.999 -0.999 -0.999 -1 ...
##  $ V99 : num  -0.997 -0.999 -0.999 -0.999 -1 ...
##   [list output truncated]
```

## **Y_test**  
This object contains 2,947 rows of integer values from 1 to 6. Each row identifies the type of the variable "Activity" performed for each window sample in the test set. In our tidy data set, we'll append this column of rows to the bottom of **Y_train**.  


```r
str(Y_test)
```

```
## 'data.frame':	2947 obs. of  1 variable:
##  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
```

```r
unique(Y_test[[1]])
```

```
## [1] 5 4 6 1 3 2
```

# **Step 3: Assembling the Tidy Data Set**  
First, we'll merge/rbind the components of the training and test sets in respective objects named after the variable that their rows represent.   
 

```r
Subject <- rbind(subject_train, subject_test)
Activity <- rbind(Y_train, Y_test)
Features_561 <- rbind(X_train, X_test)
```

Then, we'll add the respective column names of **Features_561** from **features_labels**.  


```r
colnames(Features_561) <- t(features_labels[[2]])
```

And set the column names of **Subject** and **Activity**.  


```r
colnames(Subject) <- "Subject"
colnames(Activity) <- "Activity"
```

Then finally cbind **Subject**, **Activity**, and **Features_561** into **data**. At this point, we'll also remove the unnecessary objects in our environment.  


```r
data <- cbind(Subject, Activity, Features_561)
rm(subject_train, subject_test, Subject, Activity, Y_train, Y_test, Features_561, X_train, X_test, features_labels)
str(data)
```

```
## 'data.frame':	10299 obs. of  563 variables:
##  $ Subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ tBodyAcc-mad()-Z                    : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##  $ tBodyAcc-max()-X                    : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
##  $ tBodyAcc-max()-Y                    : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
##  $ tBodyAcc-max()-Z                    : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
##  $ tBodyAcc-min()-X                    : num  0.853 0.849 0.844 0.844 0.849 ...
##  $ tBodyAcc-min()-Y                    : num  0.686 0.686 0.682 0.682 0.683 ...
##  $ tBodyAcc-min()-Z                    : num  0.814 0.823 0.839 0.838 0.838 ...
##  $ tBodyAcc-sma()                      : num  -0.966 -0.982 -0.983 -0.986 -0.993 ...
##  $ tBodyAcc-energy()-X                 : num  -1 -1 -1 -1 -1 ...
##  $ tBodyAcc-energy()-Y                 : num  -1 -1 -1 -1 -1 ...
##  $ tBodyAcc-energy()-Z                 : num  -0.995 -0.998 -0.999 -1 -1 ...
##  $ tBodyAcc-iqr()-X                    : num  -0.994 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-iqr()-Y                    : num  -0.988 -0.978 -0.965 -0.984 -0.981 ...
##  $ tBodyAcc-iqr()-Z                    : num  -0.943 -0.948 -0.975 -0.986 -0.991 ...
##  $ tBodyAcc-entropy()-X                : num  -0.408 -0.715 -0.592 -0.627 -0.787 ...
##  $ tBodyAcc-entropy()-Y                : num  -0.679 -0.501 -0.486 -0.851 -0.559 ...
##  $ tBodyAcc-entropy()-Z                : num  -0.602 -0.571 -0.571 -0.912 -0.761 ...
##  $ tBodyAcc-arCoeff()-X,1              : num  0.9293 0.6116 0.273 0.0614 0.3133 ...
##  $ tBodyAcc-arCoeff()-X,2              : num  -0.853 -0.3295 -0.0863 0.0748 -0.1312 ...
##  $ tBodyAcc-arCoeff()-X,3              : num  0.36 0.284 0.337 0.198 0.191 ...
##  $ tBodyAcc-arCoeff()-X,4              : num  -0.0585 0.2846 -0.1647 -0.2643 0.0869 ...
##  $ tBodyAcc-arCoeff()-Y,1              : num  0.2569 0.1157 0.0172 0.0725 0.2576 ...
##  $ tBodyAcc-arCoeff()-Y,2              : num  -0.2248 -0.091 -0.0745 -0.1553 -0.2725 ...
##  $ tBodyAcc-arCoeff()-Y,3              : num  0.264 0.294 0.342 0.323 0.435 ...
##  $ tBodyAcc-arCoeff()-Y,4              : num  -0.0952 -0.2812 -0.3326 -0.1708 -0.3154 ...
##  $ tBodyAcc-arCoeff()-Z,1              : num  0.279 0.086 0.239 0.295 0.44 ...
##  $ tBodyAcc-arCoeff()-Z,2              : num  -0.4651 -0.0222 -0.1362 -0.3061 -0.2691 ...
##  $ tBodyAcc-arCoeff()-Z,3              : num  0.4919 -0.0167 0.1739 0.4821 0.1794 ...
##  $ tBodyAcc-arCoeff()-Z,4              : num  -0.191 -0.221 -0.299 -0.47 -0.089 ...
##  $ tBodyAcc-correlation()-X,Y          : num  0.3763 -0.0134 -0.1247 -0.3057 -0.1558 ...
##  $ tBodyAcc-correlation()-X,Z          : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
##  $ tBodyAcc-correlation()-Y,Z          : num  0.661 0.579 0.609 0.507 0.599 ...
##  $ tGravityAcc-mean()-X                : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc-mean()-Y                : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc-mean()-Z                : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tGravityAcc-std()-X                 : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ tGravityAcc-std()-Y                 : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ tGravityAcc-std()-Z                 : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ tGravityAcc-mad()-X                 : num  -0.985 -0.998 -1 -0.996 -0.998 ...
##  $ tGravityAcc-mad()-Y                 : num  -0.984 -0.99 -0.993 -0.981 -0.989 ...
##  $ tGravityAcc-mad()-Z                 : num  -0.895 -0.933 -0.993 -0.978 -0.979 ...
##  $ tGravityAcc-max()-X                 : num  0.892 0.892 0.892 0.894 0.894 ...
##  $ tGravityAcc-max()-Y                 : num  -0.161 -0.161 -0.164 -0.164 -0.167 ...
##  $ tGravityAcc-max()-Z                 : num  0.1247 0.1226 0.0946 0.0934 0.0917 ...
##  $ tGravityAcc-min()-X                 : num  0.977 0.985 0.987 0.987 0.987 ...
##  $ tGravityAcc-min()-Y                 : num  -0.123 -0.115 -0.115 -0.121 -0.122 ...
##  $ tGravityAcc-min()-Z                 : num  0.0565 0.1028 0.1028 0.0958 0.0941 ...
##  $ tGravityAcc-sma()                   : num  -0.375 -0.383 -0.402 -0.4 -0.4 ...
##  $ tGravityAcc-energy()-X              : num  0.899 0.908 0.909 0.911 0.912 ...
##  $ tGravityAcc-energy()-Y              : num  -0.971 -0.971 -0.97 -0.969 -0.967 ...
##  $ tGravityAcc-energy()-Z              : num  -0.976 -0.979 -0.982 -0.982 -0.984 ...
##  $ tGravityAcc-iqr()-X                 : num  -0.984 -0.999 -1 -0.996 -0.998 ...
##  $ tGravityAcc-iqr()-Y                 : num  -0.989 -0.99 -0.992 -0.981 -0.991 ...
##  $ tGravityAcc-iqr()-Z                 : num  -0.918 -0.942 -0.993 -0.98 -0.98 ...
##  $ tGravityAcc-entropy()-X             : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ tGravityAcc-entropy()-Y             : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ tGravityAcc-entropy()-Z             : num  0.114 -0.21 -0.927 -0.596 -0.617 ...
##  $ tGravityAcc-arCoeff()-X,1           : num  -0.59042 -0.41006 0.00223 -0.06493 -0.25727 ...
##  $ tGravityAcc-arCoeff()-X,2           : num  0.5911 0.4139 0.0275 0.0754 0.2689 ...
##  $ tGravityAcc-arCoeff()-X,3           : num  -0.5918 -0.4176 -0.0567 -0.0858 -0.2807 ...
##  $ tGravityAcc-arCoeff()-X,4           : num  0.5925 0.4213 0.0855 0.0962 0.2926 ...
##  $ tGravityAcc-arCoeff()-Y,1           : num  -0.745 -0.196 -0.329 -0.295 -0.167 ...
##  $ tGravityAcc-arCoeff()-Y,2           : num  0.7209 0.1253 0.2705 0.2283 0.0899 ...
##  $ tGravityAcc-arCoeff()-Y,3           : num  -0.7124 -0.1056 -0.2545 -0.2063 -0.0663 ...
##  $ tGravityAcc-arCoeff()-Y,4           : num  0.7113 0.1091 0.2576 0.2048 0.0671 ...
##  $ tGravityAcc-arCoeff()-Z,1           : num  -0.995 -0.834 -0.705 -0.385 -0.237 ...
##  $ tGravityAcc-arCoeff()-Z,2           : num  0.996 0.834 0.714 0.386 0.239 ...
##  $ tGravityAcc-arCoeff()-Z,3           : num  -0.996 -0.834 -0.723 -0.387 -0.241 ...
##  $ tGravityAcc-arCoeff()-Z,4           : num  0.992 0.83 0.729 0.385 0.241 ...
##  $ tGravityAcc-correlation()-X,Y       : num  0.57 -0.831 -0.181 -0.991 -0.408 ...
##  $ tGravityAcc-correlation()-X,Z       : num  0.439 -0.866 0.338 -0.969 -0.185 ...
##  $ tGravityAcc-correlation()-Y,Z       : num  0.987 0.974 0.643 0.984 0.965 ...
##  $ tBodyAccJerk-mean()-X               : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk-mean()-Y               : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ tBodyAccJerk-mean()-Z               : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ tBodyAccJerk-std()-X                : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ tBodyAccJerk-std()-Y                : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ tBodyAccJerk-std()-Z                : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ tBodyAccJerk-mad()-X                : num  -0.994 -0.996 -0.991 -0.994 -0.997 ...
##  $ tBodyAccJerk-mad()-Y                : num  -0.986 -0.979 -0.979 -0.986 -0.987 ...
##  $ tBodyAccJerk-mad()-Z                : num  -0.993 -0.991 -0.987 -0.991 -0.991 ...
##  $ tBodyAccJerk-max()-X                : num  -0.985 -0.995 -0.987 -0.987 -0.997 ...
##  $ tBodyAccJerk-max()-Y                : num  -0.992 -0.979 -0.979 -0.992 -0.992 ...
##  $ tBodyAccJerk-max()-Z                : num  -0.993 -0.992 -0.992 -0.99 -0.99 ...
##  $ tBodyAccJerk-min()-X                : num  0.99 0.993 0.988 0.988 0.994 ...
##  $ tBodyAccJerk-min()-Y                : num  0.992 0.992 0.992 0.993 0.993 ...
##  $ tBodyAccJerk-min()-Z                : num  0.991 0.989 0.989 0.993 0.986 ...
##  $ tBodyAccJerk-sma()                  : num  -0.994 -0.991 -0.988 -0.993 -0.994 ...
##  $ tBodyAccJerk-energy()-X             : num  -1 -1 -1 -1 -1 ...
##   [list output truncated]
```

Before proceeding, it's worth looking whether there are missing values in our assembled data set. In this case, there is no missing data or NAs.  


```r
table(is.na(data))
```

```
## 
##   FALSE 
## 5798337
```

# **Step 4: Extracting the Mean and Standard Deviation Measurements Applied on the Features**     
In this step, we want to select the columns with mean or standard deviation of their features. These have "mean()" or "std()" markers in their column names. We'll use **grep()** to add these column names to the object **selected_variable_names**. We'll also retain the "Subject" and "Activity" columns for our tidy data set.


```r
selected_variable_names <- grep(".*mean\\(\\).*|.*std\\(\\).*" ,colnames(data), value = T)
selected_variable_names <- c("Subject", "Activity", selected_variable_names)
data <- data[, selected_variable_names]
str(data)
```

```
## 'data.frame':	10299 obs. of  68 variables:
##  $ Subject                    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activity                   : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z          : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z           : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tGravityAcc-mean()-X       : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc-mean()-Y       : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc-mean()-Z       : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tGravityAcc-std()-X        : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ tGravityAcc-std()-Y        : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ tGravityAcc-std()-Z        : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ tBodyAccJerk-mean()-X      : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk-mean()-Y      : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ tBodyAccJerk-mean()-Z      : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ tBodyAccJerk-std()-X       : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ tBodyAccJerk-std()-Y       : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ tBodyAccJerk-std()-Z       : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ tBodyGyro-mean()-X         : num  -0.0061 -0.0161 -0.0317 -0.0434 -0.034 ...
##  $ tBodyGyro-mean()-Y         : num  -0.0314 -0.0839 -0.1023 -0.0914 -0.0747 ...
##  $ tBodyGyro-mean()-Z         : num  0.1077 0.1006 0.0961 0.0855 0.0774 ...
##  $ tBodyGyro-std()-X          : num  -0.985 -0.983 -0.976 -0.991 -0.985 ...
##  $ tBodyGyro-std()-Y          : num  -0.977 -0.989 -0.994 -0.992 -0.992 ...
##  $ tBodyGyro-std()-Z          : num  -0.992 -0.989 -0.986 -0.988 -0.987 ...
##  $ tBodyGyroJerk-mean()-X     : num  -0.0992 -0.1105 -0.1085 -0.0912 -0.0908 ...
##  $ tBodyGyroJerk-mean()-Y     : num  -0.0555 -0.0448 -0.0424 -0.0363 -0.0376 ...
##  $ tBodyGyroJerk-mean()-Z     : num  -0.062 -0.0592 -0.0558 -0.0605 -0.0583 ...
##  $ tBodyGyroJerk-std()-X      : num  -0.992 -0.99 -0.988 -0.991 -0.991 ...
##  $ tBodyGyroJerk-std()-Y      : num  -0.993 -0.997 -0.996 -0.997 -0.996 ...
##  $ tBodyGyroJerk-std()-Z      : num  -0.992 -0.994 -0.992 -0.993 -0.995 ...
##  $ tBodyAccMag-mean()         : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tBodyAccMag-std()          : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tGravityAccMag-mean()      : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tGravityAccMag-std()       : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tBodyAccJerkMag-mean()     : num  -0.993 -0.991 -0.989 -0.993 -0.993 ...
##  $ tBodyAccJerkMag-std()      : num  -0.994 -0.992 -0.99 -0.993 -0.996 ...
##  $ tBodyGyroMag-mean()        : num  -0.969 -0.981 -0.976 -0.982 -0.985 ...
##  $ tBodyGyroMag-std()         : num  -0.964 -0.984 -0.986 -0.987 -0.989 ...
##  $ tBodyGyroJerkMag-mean()    : num  -0.994 -0.995 -0.993 -0.996 -0.996 ...
##  $ tBodyGyroJerkMag-std()     : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyAcc-mean()-X          : num  -0.995 -0.997 -0.994 -0.995 -0.997 ...
##  $ fBodyAcc-mean()-Y          : num  -0.983 -0.977 -0.973 -0.984 -0.982 ...
##  $ fBodyAcc-mean()-Z          : num  -0.939 -0.974 -0.983 -0.991 -0.988 ...
##  $ fBodyAcc-std()-X           : num  -0.995 -0.999 -0.996 -0.996 -0.999 ...
##  $ fBodyAcc-std()-Y           : num  -0.983 -0.975 -0.966 -0.983 -0.98 ...
##  $ fBodyAcc-std()-Z           : num  -0.906 -0.955 -0.977 -0.99 -0.992 ...
##  $ fBodyAccJerk-mean()-X      : num  -0.992 -0.995 -0.991 -0.994 -0.996 ...
##  $ fBodyAccJerk-mean()-Y      : num  -0.987 -0.981 -0.982 -0.989 -0.989 ...
##  $ fBodyAccJerk-mean()-Z      : num  -0.99 -0.99 -0.988 -0.991 -0.991 ...
##  $ fBodyAccJerk-std()-X       : num  -0.996 -0.997 -0.991 -0.991 -0.997 ...
##  $ fBodyAccJerk-std()-Y       : num  -0.991 -0.982 -0.981 -0.987 -0.989 ...
##  $ fBodyAccJerk-std()-Z       : num  -0.997 -0.993 -0.99 -0.994 -0.993 ...
##  $ fBodyGyro-mean()-X         : num  -0.987 -0.977 -0.975 -0.987 -0.982 ...
##  $ fBodyGyro-mean()-Y         : num  -0.982 -0.993 -0.994 -0.994 -0.993 ...
##  $ fBodyGyro-mean()-Z         : num  -0.99 -0.99 -0.987 -0.987 -0.989 ...
##  $ fBodyGyro-std()-X          : num  -0.985 -0.985 -0.977 -0.993 -0.986 ...
##  $ fBodyGyro-std()-Y          : num  -0.974 -0.987 -0.993 -0.992 -0.992 ...
##  $ fBodyGyro-std()-Z          : num  -0.994 -0.99 -0.987 -0.989 -0.988 ...
##  $ fBodyAccMag-mean()         : num  -0.952 -0.981 -0.988 -0.988 -0.994 ...
##  $ fBodyAccMag-std()          : num  -0.956 -0.976 -0.989 -0.987 -0.99 ...
##  $ fBodyBodyAccJerkMag-mean() : num  -0.994 -0.99 -0.989 -0.993 -0.996 ...
##  $ fBodyBodyAccJerkMag-std()  : num  -0.994 -0.992 -0.991 -0.992 -0.994 ...
##  $ fBodyBodyGyroMag-mean()    : num  -0.98 -0.988 -0.989 -0.989 -0.991 ...
##  $ fBodyBodyGyroMag-std()     : num  -0.961 -0.983 -0.986 -0.988 -0.989 ...
##  $ fBodyBodyGyroJerkMag-mean(): num  -0.992 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyBodyGyroJerkMag-std() : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
```

# **Step 5: Using Descriptive Activity Names to Name the Activities in the Data Set**  
Recall that the variable "Activity" contains rows of integers from 1 to 6 indicating the type of activity performed. We want to replace these numbers with their respective labels from **activity_labels** and turn the variable class into a factor.  


```r
str(data$Activity)
```

```
##  int [1:10299] 5 5 5 5 5 5 5 5 5 5 ...
```

```r
for (i in 1:6) data[data$Activity == i, 2] <- activity_labels[[2]][[i]]
data$Activity <- as.factor(data$Activity)
str(data$Activity)
```

```
##  Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
```

```r
head(data$Activity, 50)
```

```
##  [1] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
##  [8] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
## [15] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
## [22] STANDING STANDING STANDING STANDING STANDING STANDING SITTING 
## [29] SITTING  SITTING  SITTING  SITTING  SITTING  SITTING  SITTING 
## [36] SITTING  SITTING  SITTING  SITTING  SITTING  SITTING  SITTING 
## [43] SITTING  SITTING  SITTING  SITTING  SITTING  SITTING  SITTING 
## [50] SITTING 
## 6 Levels: LAYING SITTING STANDING WALKING ... WALKING_UPSTAIRS
```

# **Step 6: Labelling the Data Set with Descriptive Variable Names**  
In this step, we'll replace the abbreviated feature/variable names with descriptive names. Recall that:  

- a prefix of "t" indicates *time* domain signals  
- a prefix of "f" indicates *frequency* domain signals  
- "Acc" indicates measurements from the smartphone *accelerometer* which signify linear acceleration  
- "Gyro" indicates measurements from the smartphone *gyroscope* which signify angular velocity    
- "BodyBody" denotes *body* acceleration signals  
- "Mag" indicates the *magnitude* of the three-dimensional signals calculated using the Euclidean norm  

We'll use the italicized words as replacement for their respective abbreviations.  


```r
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)
```

```
##  [1] "Subject"                                       
##  [2] "Activity"                                      
##  [3] "timeBodyAccelerometer-mean()-X"                
##  [4] "timeBodyAccelerometer-mean()-Y"                
##  [5] "timeBodyAccelerometer-mean()-Z"                
##  [6] "timeBodyAccelerometer-std()-X"                 
##  [7] "timeBodyAccelerometer-std()-Y"                 
##  [8] "timeBodyAccelerometer-std()-Z"                 
##  [9] "timeGravityAccelerometer-mean()-X"             
## [10] "timeGravityAccelerometer-mean()-Y"             
## [11] "timeGravityAccelerometer-mean()-Z"             
## [12] "timeGravityAccelerometer-std()-X"              
## [13] "timeGravityAccelerometer-std()-Y"              
## [14] "timeGravityAccelerometer-std()-Z"              
## [15] "timeBodyAccelerometerJerk-mean()-X"            
## [16] "timeBodyAccelerometerJerk-mean()-Y"            
## [17] "timeBodyAccelerometerJerk-mean()-Z"            
## [18] "timeBodyAccelerometerJerk-std()-X"             
## [19] "timeBodyAccelerometerJerk-std()-Y"             
## [20] "timeBodyAccelerometerJerk-std()-Z"             
## [21] "timeBodyGyroscope-mean()-X"                    
## [22] "timeBodyGyroscope-mean()-Y"                    
## [23] "timeBodyGyroscope-mean()-Z"                    
## [24] "timeBodyGyroscope-std()-X"                     
## [25] "timeBodyGyroscope-std()-Y"                     
## [26] "timeBodyGyroscope-std()-Z"                     
## [27] "timeBodyGyroscopeJerk-mean()-X"                
## [28] "timeBodyGyroscopeJerk-mean()-Y"                
## [29] "timeBodyGyroscopeJerk-mean()-Z"                
## [30] "timeBodyGyroscopeJerk-std()-X"                 
## [31] "timeBodyGyroscopeJerk-std()-Y"                 
## [32] "timeBodyGyroscopeJerk-std()-Z"                 
## [33] "timeBodyAccelerometerMagnitude-mean()"         
## [34] "timeBodyAccelerometerMagnitude-std()"          
## [35] "timeGravityAccelerometerMagnitude-mean()"      
## [36] "timeGravityAccelerometerMagnitude-std()"       
## [37] "timeBodyAccelerometerJerkMagnitude-mean()"     
## [38] "timeBodyAccelerometerJerkMagnitude-std()"      
## [39] "timeBodyGyroscopeMagnitude-mean()"             
## [40] "timeBodyGyroscopeMagnitude-std()"              
## [41] "timeBodyGyroscopeJerkMagnitude-mean()"         
## [42] "timeBodyGyroscopeJerkMagnitude-std()"          
## [43] "frequencyBodyAccelerometer-mean()-X"           
## [44] "frequencyBodyAccelerometer-mean()-Y"           
## [45] "frequencyBodyAccelerometer-mean()-Z"           
## [46] "frequencyBodyAccelerometer-std()-X"            
## [47] "frequencyBodyAccelerometer-std()-Y"            
## [48] "frequencyBodyAccelerometer-std()-Z"            
## [49] "frequencyBodyAccelerometerJerk-mean()-X"       
## [50] "frequencyBodyAccelerometerJerk-mean()-Y"       
## [51] "frequencyBodyAccelerometerJerk-mean()-Z"       
## [52] "frequencyBodyAccelerometerJerk-std()-X"        
## [53] "frequencyBodyAccelerometerJerk-std()-Y"        
## [54] "frequencyBodyAccelerometerJerk-std()-Z"        
## [55] "frequencyBodyGyroscope-mean()-X"               
## [56] "frequencyBodyGyroscope-mean()-Y"               
## [57] "frequencyBodyGyroscope-mean()-Z"               
## [58] "frequencyBodyGyroscope-std()-X"                
## [59] "frequencyBodyGyroscope-std()-Y"                
## [60] "frequencyBodyGyroscope-std()-Z"                
## [61] "frequencyBodyAccelerometerMagnitude-mean()"    
## [62] "frequencyBodyAccelerometerMagnitude-std()"     
## [63] "frequencyBodyAccelerometerJerkMagnitude-mean()"
## [64] "frequencyBodyAccelerometerJerkMagnitude-std()" 
## [65] "frequencyBodyGyroscopeMagnitude-mean()"        
## [66] "frequencyBodyGyroscopeMagnitude-std()"         
## [67] "frequencyBodyGyroscopeJerkMagnitude-mean()"    
## [68] "frequencyBodyGyroscopeJerkMagnitude-std()"
```

# **Step 7: Creating a Second Independent Tidy Data Set with the Average of each Variable for each Activity and each Subject**  
For our tidy data set, we want to collapse the data by "Subject" and "Activity" and show the mean/average for each of the variables/features. We'll do this by using the reshape2 package.  

First, we'll melt the data set so that it'll be restructured into a format in which each measured variable/feature is in its own row along with the ID variables ("Subject" and "Activity").  

Then, we'll reshape the melted data into however we want using a formula and the function mean applied to the aggregated data.  


```r
library(reshape2)
mdata <- melt(data, id = c("Subject", "Activity"))
str(mdata)
```

```
## 'data.frame':	679734 obs. of  4 variables:
##  $ Subject : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Activity: Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ variable: Factor w/ 66 levels "timeBodyAccelerometer-mean()-X",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ value   : num  0.289 0.278 0.28 0.279 0.277 ...
```

```r
head(mdata)
```

```
##   Subject Activity                       variable     value
## 1       1 STANDING timeBodyAccelerometer-mean()-X 0.2885845
## 2       1 STANDING timeBodyAccelerometer-mean()-X 0.2784188
## 3       1 STANDING timeBodyAccelerometer-mean()-X 0.2796531
## 4       1 STANDING timeBodyAccelerometer-mean()-X 0.2791739
## 5       1 STANDING timeBodyAccelerometer-mean()-X 0.2766288
## 6       1 STANDING timeBodyAccelerometer-mean()-X 0.2771988
```

```r
data2 <- dcast(mdata, Subject + Activity ~ variable, mean)
str(data2)
```

```
## 'data.frame':	180 obs. of  68 variables:
##  $ Subject                                       : int  1 1 1 1 1 1 2 2 2 2 ...
##  $ Activity                                      : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
##  $ timeBodyAccelerometer-mean()-X                : num  0.222 0.261 0.279 0.277 0.289 ...
##  $ timeBodyAccelerometer-mean()-Y                : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
##  $ timeBodyAccelerometer-mean()-Z                : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
##  $ timeBodyAccelerometer-std()-X                 : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
##  $ timeBodyAccelerometer-std()-Y                 : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
##  $ timeBodyAccelerometer-std()-Z                 : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
##  $ timeGravityAccelerometer-mean()-X             : num  -0.249 0.832 0.943 0.935 0.932 ...
##  $ timeGravityAccelerometer-mean()-Y             : num  0.706 0.204 -0.273 -0.282 -0.267 ...
##  $ timeGravityAccelerometer-mean()-Z             : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
##  $ timeGravityAccelerometer-std()-X              : num  -0.897 -0.968 -0.994 -0.977 -0.951 ...
##  $ timeGravityAccelerometer-std()-Y              : num  -0.908 -0.936 -0.981 -0.971 -0.937 ...
##  $ timeGravityAccelerometer-std()-Z              : num  -0.852 -0.949 -0.976 -0.948 -0.896 ...
##  $ timeBodyAccelerometerJerk-mean()-X            : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
##  $ timeBodyAccelerometerJerk-mean()-Y            : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
##  $ timeBodyAccelerometerJerk-mean()-Z            : num  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
##  $ timeBodyAccelerometerJerk-std()-X             : num  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
##  $ timeBodyAccelerometerJerk-std()-Y             : num  -0.924 -0.981 -0.986 0.067 -0.102 ...
##  $ timeBodyAccelerometerJerk-std()-Z             : num  -0.955 -0.988 -0.992 -0.503 -0.346 ...
##  $ timeBodyGyroscope-mean()-X                    : num  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
##  $ timeBodyGyroscope-mean()-Y                    : num  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
##  $ timeBodyGyroscope-mean()-Z                    : num  0.1487 0.0629 0.0748 0.0849 0.0901 ...
##  $ timeBodyGyroscope-std()-X                     : num  -0.874 -0.977 -0.987 -0.474 -0.458 ...
##  $ timeBodyGyroscope-std()-Y                     : num  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
##  $ timeBodyGyroscope-std()-Z                     : num  -0.908 -0.941 -0.981 -0.344 -0.125 ...
##  $ timeBodyGyroscopeJerk-mean()-X                : num  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
##  $ timeBodyGyroscopeJerk-mean()-Y                : num  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
##  $ timeBodyGyroscopeJerk-mean()-Z                : num  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
##  $ timeBodyGyroscopeJerk-std()-X                 : num  -0.919 -0.992 -0.993 -0.207 -0.487 ...
##  $ timeBodyGyroscopeJerk-std()-Y                 : num  -0.968 -0.99 -0.995 -0.304 -0.239 ...
##  $ timeBodyGyroscopeJerk-std()-Z                 : num  -0.958 -0.988 -0.992 -0.404 -0.269 ...
##  $ timeBodyAccelerometerMagnitude-mean()         : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
##  $ timeBodyAccelerometerMagnitude-std()          : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
##  $ timeGravityAccelerometerMagnitude-mean()      : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
##  $ timeGravityAccelerometerMagnitude-std()       : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
##  $ timeBodyAccelerometerJerkMagnitude-mean()     : num  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
##  $ timeBodyAccelerometerJerkMagnitude-std()      : num  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
##  $ timeBodyGyroscopeMagnitude-mean()             : num  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
##  $ timeBodyGyroscopeMagnitude-std()              : num  -0.819 -0.935 -0.979 -0.187 -0.226 ...
##  $ timeBodyGyroscopeJerkMagnitude-mean()         : num  -0.963 -0.992 -0.995 -0.299 -0.295 ...
##  $ timeBodyGyroscopeJerkMagnitude-std()          : num  -0.936 -0.988 -0.995 -0.325 -0.307 ...
##  $ frequencyBodyAccelerometer-mean()-X           : num  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
##  $ frequencyBodyAccelerometer-mean()-Y           : num  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
##  $ frequencyBodyAccelerometer-mean()-Z           : num  -0.883 -0.959 -0.985 -0.332 -0.226 ...
##  $ frequencyBodyAccelerometer-std()-X            : num  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
##  $ frequencyBodyAccelerometer-std()-Y            : num  -0.834 -0.917 -0.972 0.056 -0.113 ...
##  $ frequencyBodyAccelerometer-std()-Z            : num  -0.813 -0.934 -0.978 -0.28 -0.298 ...
##  $ frequencyBodyAccelerometerJerk-mean()-X       : num  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
##  $ frequencyBodyAccelerometerJerk-mean()-Y       : num  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
##  $ frequencyBodyAccelerometerJerk-mean()-Z       : num  -0.948 -0.986 -0.991 -0.469 -0.288 ...
##  $ frequencyBodyAccelerometerJerk-std()-X        : num  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
##  $ frequencyBodyAccelerometerJerk-std()-Y        : num  -0.932 -0.983 -0.987 0.107 -0.135 ...
##  $ frequencyBodyAccelerometerJerk-std()-Z        : num  -0.961 -0.988 -0.992 -0.535 -0.402 ...
##  $ frequencyBodyGyroscope-mean()-X               : num  -0.85 -0.976 -0.986 -0.339 -0.352 ...
##  $ frequencyBodyGyroscope-mean()-Y               : num  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
##  $ frequencyBodyGyroscope-mean()-Z               : num  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
##  $ frequencyBodyGyroscope-std()-X                : num  -0.882 -0.978 -0.987 -0.517 -0.495 ...
##  $ frequencyBodyGyroscope-std()-Y                : num  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
##  $ frequencyBodyGyroscope-std()-Z                : num  -0.917 -0.944 -0.982 -0.437 -0.238 ...
##  $ frequencyBodyAccelerometerMagnitude-mean()    : num  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
##  $ frequencyBodyAccelerometerMagnitude-std()     : num  -0.798 -0.928 -0.982 -0.398 -0.187 ...
##  $ frequencyBodyAccelerometerJerkMagnitude-mean(): num  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
##  $ frequencyBodyAccelerometerJerkMagnitude-std() : num  -0.922 -0.982 -0.993 -0.103 -0.104 ...
##  $ frequencyBodyGyroscopeMagnitude-mean()        : num  -0.862 -0.958 -0.985 -0.199 -0.186 ...
##  $ frequencyBodyGyroscopeMagnitude-std()         : num  -0.824 -0.932 -0.978 -0.321 -0.398 ...
##  $ frequencyBodyGyroscopeJerkMagnitude-mean()    : num  -0.942 -0.99 -0.995 -0.319 -0.282 ...
##  $ frequencyBodyGyroscopeJerkMagnitude-std()     : num  -0.933 -0.987 -0.995 -0.382 -0.392 ...
```

```r
data2[1:30, 1:3]
```

```
##    Subject           Activity timeBodyAccelerometer-mean()-X
## 1        1             LAYING                      0.2215982
## 2        1            SITTING                      0.2612376
## 3        1           STANDING                      0.2789176
## 4        1            WALKING                      0.2773308
## 5        1 WALKING_DOWNSTAIRS                      0.2891883
## 6        1   WALKING_UPSTAIRS                      0.2554617
## 7        2             LAYING                      0.2813734
## 8        2            SITTING                      0.2770874
## 9        2           STANDING                      0.2779115
## 10       2            WALKING                      0.2764266
## 11       2 WALKING_DOWNSTAIRS                      0.2776153
## 12       2   WALKING_UPSTAIRS                      0.2471648
## 13       3             LAYING                      0.2755169
## 14       3            SITTING                      0.2571976
## 15       3           STANDING                      0.2800465
## 16       3            WALKING                      0.2755675
## 17       3 WALKING_DOWNSTAIRS                      0.2924235
## 18       3   WALKING_UPSTAIRS                      0.2608199
## 19       4             LAYING                      0.2635592
## 20       4            SITTING                      0.2715383
## 21       4           STANDING                      0.2804997
## 22       4            WALKING                      0.2785820
## 23       4 WALKING_DOWNSTAIRS                      0.2799653
## 24       4   WALKING_UPSTAIRS                      0.2708767
## 25       5             LAYING                      0.2783343
## 26       5            SITTING                      0.2736941
## 27       5           STANDING                      0.2825444
## 28       5            WALKING                      0.2778423
## 29       5 WALKING_DOWNSTAIRS                      0.2935439
## 30       5   WALKING_UPSTAIRS                      0.2684595
```

# **Step 8: Writing the output to TidyData.txt**  
Finally, we'll write the aggregated data by "Subject" and "Activity" to a text file.


```r
write.table(data2, file = "tidy_dataset.txt", row.names = FALSE)
```

