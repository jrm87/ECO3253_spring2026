library(dplyr)
#once you have pacman, you don't need to worry about what is installed and what is not.
#install.packages("lifecycle")
#install.packages("caret")
#install.packages("skimr")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("randomForest")

library(caret)
library(dplyr)
library(skimr)
library(rpart)
library(rpart.plot)
library(randomForest)

#stop on error
options(error=recover)

# Load data:
train<- readRDS(gzcon(url("https://raw.githubusercontent.com/jrm87/ECO3253_repo/master/data/atlas_train.rds")))
test<-readRDS(gzcon(url("https://raw.githubusercontent.com/jrm87/ECO3253_repo/master/data/atlas_test.rds")))

# Check out all the possible variables in this new dataset:
names(train)

#Multiple Linear Regression with 10 variables (professors)
mlr_model<-lm(kfr_pooled_p25 ~ share_hisp2010+CountGedOrAlternativeCredential_2020+Count_NotAUSCitizen_2020+
                mean_commutetime2000+poor_share2010+emp2000+jobs_highpay_5mi_2015+ec_zip+civic_organizations_zip+
                GenderIncomeInequality_2018, data=train)
summary(mlr_model)
#The adjusted R squared of the model is 0.4635, meaning that the model explains 46.35% of the variation in upward mobility.

##my 10 variables
mlr_model1<-lm(kfr_pooled_p25 ~ frac_coll_plus2010+gsmn_math_g3_2013+ec_zip+GenderIncomeInequality_2018+CountHouseholdInternetWithoutSubscription_2020+Median_Cost_HousingUnit_WithMortgage_2020+nbhd_exposure_zip+PersonWithDisability_2019+MedianIncomePerson_2020+nbhd_exposure_zip
               , data=train)
summary(mlr_model1)
#The adjusted R squared of the model is 0.4328, meaning that the model explains 43.28% of the variation in upward mobility.


#MSE for model - in sample
mean(mlr_model$residuals^2)
#RMSE - in sample
sqrt(mean(mlr_model$residuals^2))
#RMSE = 5928.903


#Now I will see how this model  performs in the testing dataset

predict_mlr_model<-predict(mlr_model,test)
#MSE for model  out-of-sample
actual_values<- test$kfr_pooled_p25
rmse_mlrmodel_outsample <- sqrt(mean((actual_values - predict_mlr_model)^2, na.rm=TRUE))
rmse_mlrmodel_outsample
#RMSE = 5946.008

#transform the state data to categorical
#train$state <- as.factor(train$state)
#test$state <- as.factor(test$state)
#train$county <- as.factor(train$county)
#test$county <- as.factor(test$county)
#train$tract <- as.factor(train$tract)
#test$tract <- as.factor(test$tract)

## A first machine learning model: Decision trees

# let's rename some of the super long variables:
train<-train%>%
  rename(edBacHigherMarriedBelowPov2019=Count_Household_HouseholderEducationalAttainmentBachelorsDegreeOrHigher_MarriedCoupleFamilyHousehold_BelowPovertyLevelInThePast12Months_2019)

test<-test%>%
  rename(edBacHigherMarriedBelowPov2019=Count_Household_HouseholderEducationalAttainmentBachelorsDegreeOrHigher_MarriedCoupleFamilyHousehold_BelowPovertyLevelInThePast12Months_2019)

train<-train%>%
  rename(foodstamp_pop2019=Household_WithFoodStampsInThePast12Months_AbovePovertyLevelInThePast12Months_2019)

test<-test%>%
  rename(foodstamp_pop2019=Household_WithFoodStampsInThePast12Months_AbovePovertyLevelInThePast12Months_2019)


#Calculating the decision tree with all the variables in the train data set
#Using kfr_pooled_p25 as dependent variable
tree <- rpart(kfr_pooled_p25 ~., data = train)
#Plotting the regression tree
rpart.plot(tree)


# second tree without mobility measures.
train2<-train%>%
  select(-c("kfr_natam_p25","kfr_natam_p75","kfr_natam_p100", "kfr_asian_p25", "kfr_asian_p75", "kfr_asian_p100", "kfr_black_p25", "kfr_black_p75", "kfr_black_p100", "kfr_hisp_p25", "kfr_hisp_p75", "kfr_hisp_p100", "kfr_pooled_p75", "kfr_pooled_p100", "kfr_white_p25", "kfr_white_p75", "kfr_white_p100"))

tree2 <- rpart(kfr_pooled_p25 ~., data = train2)
#Plotting the regression tree
rpart.plot(tree2)

# Let's drops variables that have names: County.Name, czname

train3<-train2%>%
  select(-c("County.Name", "czname"))

train3<-train3%>%
  filter(!is.na(kfr_pooled_p25))

tree3 <- rpart(kfr_pooled_p25 ~., data = train3)
#Plotting the regression tree
rpart.plot(tree3)

#Complexity parameters for the tree
printcp(tree3)
plotcp(tree3)

#In-sample prediction
p <- predict(tree3, train3)
#Root mean squared error = 1944.108 (in sample)
sqrt(mean((train3$kfr_pooled_p25[!is.na(train3$kfr_pooled_p25)]-p[!is.na(p)])^2))
#R squared = 50.62%
(cor(train3$kfr_pooled_p25,p))^2

# We see that CZ gets picked up, but this should not be the case. CZ is just a name.
# Let's tell R that cz is a name, but we won't be able to plot a nice tree =/

# (>^^)> <(^^)> <(^^<)

train3$cz<-as.factor(train3$cz)

# Let's re-run the tree and see the prediction

tree3 <- rpart(kfr_pooled_p25 ~., data = train3)

p <- predict(tree3, train3)
# Mean Square Error: 5520.712
sqrt(mean((train3$kfr_pooled_p25[!is.na(train3$kfr_pooled_p25)]-p[!is.na(p)])^2))
#R squared = 54.50%
(cor(train3$kfr_pooled_p25,p))^2

# Now the for the TRUE MEASUREMENT ERROR!

# Testing for out of sample:

# Let's tranform the test data as the train data:
test2<-test%>%
  select(-c("kfr_natam_p25","kfr_natam_p75","kfr_natam_p100", "kfr_asian_p25", "kfr_asian_p75", "kfr_asian_p100", "kfr_black_p25", "kfr_black_p75", "kfr_black_p100", "kfr_hisp_p25", "kfr_hisp_p75", "kfr_hisp_p100", "kfr_pooled_p75", "kfr_pooled_p100", "kfr_white_p25", "kfr_white_p75", "kfr_white_p100"))

test3<-test2%>%
  select(-c("County.Name", "czname"))

test3<-test3%>%
  filter(!is.na(kfr_pooled_p25))

test3$cz<-as.factor(test3$cz)

# now the prediction out of sample:

p <- predict(tree3, test3)

# You will notice an error: there are 5 CZ that are in the train data, but not in the test data/
# it does not know what to do with those.
# so, let's remove them .

test4<-test3%>%
  filter(cz!=26402 & cz!=28602 & cz!=34101 & cz!=34104 & cz!=34804)

# an alternative way of doing the above, is this:
test4<-test3%>%
  filter( !(cz %in% c(26402, 28602, 34101, 34104, 34804, NA)))

p <- predict(tree3, test4)
# Mean Square Error: 5593.47 (as compered to 5520.712 in sample)
sqrt(mean((test4$kfr_pooled_p25[!is.na(test4$kfr_pooled_p25)]-p[!is.na(p)])^2))
#R squared = 52.62% (as compared to 54.50% in sample)
(cor(test4$kfr_pooled_p25,p))^2

#-----------------------------------------------
# -------Now let's estimate a RANDOM FOREST!----
#-----------------------------------------------

# Random forest

#Omit NA values
train4<-na.omit(train3)

train4<-train4%>%
  select(-cz)

#Random forest calculation
rf <- randomForest(kfr_pooled_p25~., data=train4, proximity=TRUE)
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
