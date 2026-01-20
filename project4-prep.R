#Project 4 data

library(tidylog)



#Loading data
#with here
atlas_socialcap_bytract <-read_csv(here("data", "atlas_socialk_tract.csv"))
datacommons<-read_csv(here("data", "United States of America_County-2.csv"))

#with path
#atlas_socialcap_bytract <- read_csv("/Users/asaravia/Downloads/atlas_socialk_tract.csv")
#datacommons<-read_csv("/Users/asaravia/Downloads/United States of America_County-2.csv")


#Selecting county code from County variable and renaming the county variable
datacommons$County<-str_sub(datacommons$County,-5,-1)
datacommons<- rename(datacommons, county = County)


#Separating the last 3 digits from county in the datacommons data to have the state  codes
datacommons$state<-str_sub(datacommons$county,1,2)
#Same for county code
datacommons$county<-str_sub(datacommons$county,3,5)

#Adding leading 0s to atlas data for proper merge
atlas_socialcap_bytract$county<- stri_pad_left(atlas$county, 3, 0)
atlas_socialcap_bytract$state<- stri_pad_left(atlas$state, 2, 0)

#Using tidylog to merge the new data to atlas_socialcap 
atlas_datacommons_final<-atlas_socialcap_bytract %>% left_join(datacommons,by= c("county", "state"))
#rows only in x = 0, rows only in y = 2, matched rows = 73,278. 
#total rows = 73278

#download data
#with here
write.csv(atlas_datacommons_final,here("data", "atlas_datacommons_tract"), row.names = FALSE)

#with path
#write.csv(atlas_datacommons_final,"/Users/asaravia/Downloads/atlas_datacommons_tract.csv")

#DATA ANALYSIS
library(dplyr)
#Creating an id variable to divide data into test and training
atlas_datacommons_final$id <- 1:nrow(atlas_datacommons_final)

#use 70% of dataset as training set and 30% as test set 
train <- atlas_datacommons_final %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(atlas_datacommons_final, train, by = 'id')

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




