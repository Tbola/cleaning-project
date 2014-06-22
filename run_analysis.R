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
featureNames<-read.table("./Data/UCI HAR Dataset/features.txt", sep="")

myIDs<-c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,
		266:271,345:350,424:429,503:504,516:517,529:530,542:543)
myNames<-as.character(featureNames[myIDs,2])


##subset out mean and STD measures, and tag the datasets for when they are later combined
master<-cbind(
	testX[,myIDs],
	subjectID=testSubject[,1],
	activityID=testY[,1])
colnames(master)<-c(myNames,
	colnames(master)[67:68])

###rename the training columns, before attaching them to the end of master
colnames(trainX)[myIDs]<-myNames

master<-rbind(master,
	cbind(
		trainX[,myIDs],
		subjectID=trainSubject[,1],
		activityID=trainY[,1])
	)

##turn activities into factors
master$activityID<-as.factor(master$activityID)

##name the levels appropriately
levels(master$activityID)[levels(master$activityID)=="1"]<-"WALKING"
levels(master$activityID)[levels(master$activityID)=="2"]<-"WALKING UPSTAIRS"
levels(master$activityID)[levels(master$activityID)=="3"]<-"WALKING DOWNSTAIRS"
levels(master$activityID)[levels(master$activityID)=="4"]<-"SITTING"
levels(master$activityID)[levels(master$activityID)=="5"]<-"STANDING"
levels(master$activityID)[levels(master$activityID)=="6"]<-"LAYING"

tidy<-aggregate(master[,1:(ncol(master)-2)],
	by=list(activityID=master$activityID,subjectID=master$subjectID),mean,simplify=TRUE,na.action=na.omit)

write.csv(tidy,'./Data/CourseProject.txt',row.names=FALSE)

