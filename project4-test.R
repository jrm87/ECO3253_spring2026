
#DATA ANALYSIS
library(dplyr)
library(here)

# Load data:
train<- readRDS(gzcon(url("https://raw.githubusercontent.com/jrm87/ECO3253_repo/master/data/atlas_train.rds")))
test<-readRDS(gzcon(url("https://raw.githubusercontent.com/jrm87/ECO3253_repo/master/data/atlas_test.rds")))

# Check out all the possible variables in this new dataset:
names(train)

#Multiple Linear Regression with 10 variables
mlr_model<-lm(kfr_pooled_p25 ~ share_hisp2010+CountGedOrAlternativeCredential_2020+Count_NotAUSCitizen_2020+
                mean_commutetime2000+poor_share2010+emp2000+jobs_highpay_5mi_2015+ec_zip+civic_organizations_zip+
                GenderIncomeInequality_2018, data=train)
summary(mlr_model)
#The adjusted R squared of the model is 0.4635, meaning that the model explains 46.35% of the variation in upward mobility.


#MSE for model - in sample
mean(mlr_model$residuals^2)
#RMSE - in sample
sqrt(mean(mlr_model$residuals^2))
#RMSE = 5957.09
#Now I will see how this model  performs in the testing dataset
library(caret)
predict_mlr_model<-predict(mlr_model,test)
#MSE for model  out-of-sample
actual_values<- test$kfr_pooled_p25
rmse_mlrmodel_outsample <- sqrt(mean((actual_values - predict_mlr_model)^2, na.rm=TRUE))
rmse_mlrmodel_outsample
#RMSE = 5880.183


#Decision Tree
#Loading required libraries for decision tree
library(rpart)
library(rpart.plot)

#Calculating the decision tree with all the variables in the train data set
#Using kfr_pooled_p25 as dependent variable
tree <- rpart(kfr_pooled_p25 ~., data = train)
#Plotting the regression tree
rpart.plot(tree)

# What is wrong with this decision tree? What are the main predictors of mobility?

#What if you did not have measures of mobility to use in your prediction?

#Complexity parameters for the tree
printcp(tree)
plotcp(tree)

#In-sample prediction
p <- predict(tree, train)
#Root mean squared error = 1944.108 (in sample)
sqrt(mean((train$kfr_pooled_p25-p)^2))
#R squared = 0.8238
(cor(train$kfr_pooled_p25,p))^2


#Out of sample prediction
pred_tree_outofsample<-predict(tree,test)
#RMSE out of sample = 5965.278
sqrt(mean((test$kfr_pooled_p25-pred_tree_outofsample)^2, na.rm=TRUE ))




#Random Forest
library(randomForest)

#Dropping certain varibles not to be included in the random  forest
#(I drop percent of people with diabetes because the model showed some issues when this variable was included)
train<-train%>%
  select(-tract, -`County Name`, -county,-state, -cz, -czname, -'Value:Percent_Person_WithDiabetes_2018')
#Omit NA values
train<-na.omit(train)

#Random forest calculation
rf <- randomForest(kfr_pooled_p25~., data=train, proximity=TRUE)
print(rf)

#The random forest explains 69.95% of variation in our dependent variable.

# in sample Prediction & Confusion Matrix
p1 <- predict(rf, train)
#RMSE - in sample = 848.5397
sqrt(mean((train$kfr_pooled_p25-p1)^2))

#out of sample prediction
p2 <- predict(rf, test)
#rmse - out of sample = 3409.84
sqrt(mean((test$kfr_pooled_p25-p2)^2 , na.rm = TRUE))




