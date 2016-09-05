#####Copyright IBM Corp. 2016 All Rights Reserved

#####################################
# Big R / Machine Learning Case Study
#####################################

# In this example, we will access a dataset on HDFS and will do some statistical analysis and modeling.
# We are interested in modeling the arrival delay (ArrDelay) of the flights, using the flight day, time,
# and distance as predictors. First, we calculate descriptive statistics on the dataset, and then we
# build a Support Vector Machine model for the arrival delay.

############################
# 1. Accessing data on HDFS
############################

# Establish a connection with BigInsights
bigr.connect(host="bdvs1345.svl.ibm.com", user="bigr", password="bigr")
#bigr.connect(host="hdtest167.svl.ibm.com", port=7052, database="tpch", user="biadmin", password="P@ssw0rd")

# Clean up older executions
bigr.rmfs("/user/bigr/tutorial/*")

######################
# 2. Data preparation
######################

# Create a bigr.frame to point to the dataset
air <- bigr.frame(dataPath = "/user/bigr/examples/airline_demo.csv",
                  dataSource = "DEL",
                  delimiter=",", header = T,
                  coltypes = ifelse(1:29 %in% c(9,11,17,18,23),
                                    "character", "integer"),
                  useMapReduce = F)


# Project some relevant columns for modeling / statistical analysis 
airlineFiltered <- air[, c("Month", "DayofMonth", "DayOfWeek", "CRSDepTime", "Distance", "ArrDelay")]

# Discretize the ArrDelay column into three categories: Low, Medium, and High. These will be the classes to be
# predicted
airlineFiltered$Delay <- ifelse(airlineFiltered$ArrDelay > 15, "Delayed", ifelse(airlineFiltered$ArrDelay < 0, "Early", "On-time"))

# Explore the distribution of the flights that have been delayed less than 1 hour 
barplot(summary(airlineFiltered$Delay))

# Remove continuous version of the arrival delay
airlineFiltered$ArrDelay <- NULL

# See how the filtered data looks like now
str(airlineFiltered)

# Find out which columns have missing values
bigr.which.na.cols(airlineFiltered)

# Machine learning algorithms take as input objects from class bigr.matrix, which are purely numeric datasets persisted on HDFS.
# Therefore, we need to invoke bigr.transform() to recode non-numeric columns.
airlineMatrix <- bigr.transform(airlineFiltered, outData="/user/bigr/tutorial/airlinef.sample.matrix", 
                                dummycodeAttrs=c("DayOfWeek"),
                                recodeAttrs=c("DayOfWeek"), 
                                missingAttrs=c("Distance"),
                                imputationMethod=c("global_mode"),
                                transformPath="/user/bigr/tutorial/airline.sample.transform", outDataFormat = "csv")

# See how the recoded data looks like. Notice that column ???Delay??? was recoded into
# numeric values {1, 2, 3} corresponding to {???Low???, ???Medium???, ???High???}
str(airlineMatrix)


######################################
# 3. Calculate descriptive statistics
######################################

# Get univariate descriptive statistics for each column of the dataset
summary(airlineMatrix)[c("Month", "DayofMonth", "CRSDepTime", "Distance", "Delay")]

# Compute the Pearson's correlation between the predictors and the response
# variable (i.e., ArrDelay)
bigr.bivariateStats(airlineMatrix, c("DayofMonth", "CRSDepTime", "Distance"), 
                    cols2=c("Delay"))


######################################
# 4. Create training and testing sets
######################################

# Create a training a testing set by sampling the data
samples <- bigr.sample(airlineMatrix, perc=c(0.7, 0.3))
train <- samples[[1]]
test <- samples[[2]]

# Check that the training and testing sets have the correct size
nrow(train) / nrow(airlineMatrix)
nrow(test) / nrow(airlineMatrix)

##################################################
# 6. Building a Support Vector Machine classifier
##################################################

# Build an SVM model
svmModel <- bigr.svm(formula=Delay ~ ., data=train, is.binary.class=F, directory="/user/bigr/tutorial/svm.airline")

# Display the coefficients of the model
coef(svmModel)

# Calculate predictions on the testing set (labeled)
predSVM <- predict(svmModel, test, "/user/bigr/tutorial/svm.preds.airline", returnScores=T)

predSVM

########################################
############## The End #################
########################################



#############################
# Appendix (loading data)
############################




# In order to try out any example, first run the following steps to upload
# the aforementioned dataset to a BigInsights cluster.
airfile <- system.file("extdata", "airline.zip", package="bigr")
airfile <- unzip(airfile, exdir = tempdir())
airR <- read.csv(airfile, stringsAsFactors=F)

# Upload the data to the BigInsights server. This may take 15-20 seconds
air <- as.bigr.frame(airR)
air <- bigr.persist(air, dataSource="DEL", dataPath="/user/bigr/examples/airline_demo.csv",
                    header=T, delimiter=",", useMapReduce=F)

###########################
# 2. Accessing data on HDFS
###########################

# Once uploaded, one merely needs to instantiate a big.frame object,
# commonly referenced as "air" in the examples, to access the dataset via
# the Big R API.
air <- bigr.frame(dataPath = "/user/bigr/examples/airline_demo.csv",
                  dataSource = "DEL",
                  delimiter=",", header = T,
                  coltypes = ifelse(1:29 %in% c(9,11,17,18,23),
                                    "character", "integer"),
                  useMapReduce = F)
