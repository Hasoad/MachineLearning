#install.packages("readr")
#install.packages("party")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("ROCR")
#install.packages("curl")

library(readr)
library(dplyr)
library(party)
library(rpart)
library(rpart.plot)
library(ROCR)
library(curl)
library(magrittr)
set.seed(100)

#loading the workSpace
setwd("Your Working Dir")

#Here we are using the magrittr to implement the pipe operator.
# First load the dataSet from the location, 
# Extract the csv
# Select survived, embarked, sex sibsp,parch,fare from the datSet
# mutate the embarked and sex as a factoral form

titanicDataSet <- "data/titanic_DataSet.csv" %>%
  read_csv %>% # read in the data
  select(survived, embarked, sex, 
         sibsp, parch, fare) %>%
  mutate(embarked = factor(embarked),
         sex = factor(sex))

# Re_ordering the data using sample. this can split the data for training and test
dataForming <- c("training", "test") %>%
  sample(nrow(titanicDataSet), replace = T) %>%
  split(titanicDataSet, .)


# rpart is used for decision tree formation
# We have given survived as a LHS and training as RHS
rtree_fit <- rpart(survived ~ .,dataForming$training) 

# plot the decision Tree
rpart.plot(rtree_fit)

tree_roc <- rtree_fit %>%
  predict(newdata = dataForming$test) %>%
  prediction(dataForming$test$survived) %>%
  performance("tpr", "fpr")

#plot the roc
plot(tree_roc)
