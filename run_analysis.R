## create data directory if needed
if(!file.exists("./Data")){dir.create("./Data")}

## file download variables
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filePath<-"./Data/smartphones.zip"
unzipPath<-

## download if it doesn't already exist
if(!file.exists(filePath)){
	download.file(fileUrl,destfile=filePath)
	}
fileDate<-file.info(filePath)$mtime
## unzip if it doesn't exist
if(!file.exists("./Data/UCI HAR Dataset")){
	unzip(filePath,exdir="./Data")
	}

##read in the data
testSubject<-read.table("./Data/UCI HAR Dataset/test/subject_test.txt", sep="")
testX<-read.table("./Data/UCI HAR Dataset/test/X_test.txt", sep="")
testY<-read.table("./Data/UCI HAR Dataset/test/y_test.txt", sep="")
trainSubject<-read.table("./Data/UCI HAR Dataset/train/subject_train.txt", sep="")
trainX<-read.table("./Data/UCI HAR Dataset/train/X_train.txt", sep="")
trainY<-read.table("./Data/UCI HAR Dataset/train/y_train.txt", sep="")

##subset out some measures (6 means, 6 standard devs), and tag the datasets for when they are later combined
master<-cbind(
	testX[,c(1:6,41:46)],
	datasource='test',
	subjectID=testSubject[,1],
	activityID=testY[,1])
colnames(master)<-c('BodyAcc-mean-X','BodyAcc-mean-Y','BodyAcc-mean-Z',
	'BodyAcc-std-X','BodyAcc-std-Y','BodyAcc-std-Z',
	'GravityAcc-mean-X','GravityAcc-mean-Y','GravityAcc-mean-Z',
	'GravityAcc-std-X','GravityAcc-std-Y','GravityAcc-std-Z',
	colnames(master)[13:15])

###rename the training columns, before attaching them to the end of master
colnames(trainX)[c(1:6,41:46)]<-c('BodyAcc-mean-X','BodyAcc-mean-Y','BodyAcc-mean-Z',
	'BodyAcc-std-X','BodyAcc-std-Y','BodyAcc-std-Z',
	'GravityAcc-mean-X','GravityAcc-mean-Y','GravityAcc-mean-Z',
	'GravityAcc-std-X','GravityAcc-std-Y','GravityAcc-std-Z')

master<-rbind(master,
	cbind(
		trainX[,c(1:6,41:46)],
		datasource='train',
		subjectID=trainSubject[,1],
		activityID=trainY[,1])
	)

##turn activities into factors
master$activityID<-as.factor(master$activityID)


	
