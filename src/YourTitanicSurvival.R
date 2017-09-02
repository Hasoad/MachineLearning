library(ggplot2)
library(VIM)
library(mice)

####Setting upt the working directory####

setwd("Your Working dir")

####setting the trainData and testData####
baseDataRaw<-read.csv(file='data/dataSet.csv',header = TRUE,sep=',')
baseDataRawTest<-read.csv(file='data/testdata.csv',header = TRUE,sep=',')

#### Before to execute the algorithm, its mandatory to check NA/empty is available in DATASET.####
NAPlot <- aggr(baseDataRaw, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.7, gap=3, ylab=c("Histogram of missing data","Pattern"))

### check for NA is availabd in particular column ###
is.na(baseDataRaw$homeDest[baseDataRaw$homeDest =='']) <- TRUE
sum(is.na(baseDataRaw$homeDest))

###using replace function to replace NA by 'S' in baseDataRaw$embarked###
baseDataRaw$homeDest <- replace(baseDataRaw$homeDest, which(is.na(baseDataRaw$homeDest)), 'S')

####plot the basic graph####
plot(baseDataRaw$age ~ baseDataRaw$pclass, data = baseDataRaw,
     xlab="Travelling Class" ,
     ylab="Age Factor" ,
     main = "Titanic Passenger Age with Survived Ratio")

### Plot the Bar diagram ###
counts <- table(baseDataRaw$survived,baseDataRaw$pclass)
barplot(counts, main="Survived based on passenger Class",
        xlab="Passenger Class", col=c("red","green"),
        legend = rownames(counts))

### Plot the Bar diagram ###
counts <- table(baseDataRaw$survived,baseDataRaw$sex)
barplot(counts, main="Survived based on passenger Gender ratio",
        xlab="Passenger Gender Ratio", col=c("red","yellow"),
        legend = rownames(counts))

### Check for the survived column can able to factor ####
baseDataRaw$survived= as.factor(baseDataRaw$survived)

### Traing the system and create dataSet ###
train = baseDataRaw[1:1310,]

#show(train)

### Test data declaration ###
test=baseDataRawTest

#show(test)
show(baseDataRaw)

#implementing the logistic Algorithm with required data)
modelSurv <- glm(survived ~ pclass+sex+age, family = binomial("logit"),data = train,maxit=100)

#summary(modelSurv)

### Predict the test against the trainned data ###
fitted.results <- predict(modelSurv,test,type = 'response')

### Fit the resule with 0.5,1,0 ###
fitted.results <- ifelse(fitted.results > 0.5,1,0)

#show(fitted.results)

### Check the mean between the fittedResult with given model data ###
misclasificError <- mean(fitted.results != test$survived)

### Print the accuracy ###
#print(paste('Accuracy',1-misclasificError))

### Condition to check if our test data can able to survive in TITANIC Ship ### 
if(! is.na(fitted.results) && fitted.results >= 1){
  
  print(paste(test$name,'You can have a chance of survive in the Titanic ship'))
} else{
  
  print(paste(test$name,'OOPS!! YOU Are DEAD'))
}
### HAVE A FUN ###
