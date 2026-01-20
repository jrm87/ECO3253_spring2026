
#DATA ANALYSIS
library(dplyr)
library(here)
# Load data:

atlas_datacommons_final<-read.csv(here("data","atlas_datacommons_tract.csv"))

# Some of the variables in the data create problems (allegedly)
atlas_datacommons_final<-atlas_datacommons_final%>%
  select(-c('Value.Percent_Person_WithDiabetes_2018'))

# Show variables:
names(atlas_datacommons_final)

# Drop variable that gives some problems or have too long names:
atlas_datacommons_final<-atlas_datacommons_final%>%
  rename(count_hh_bachhigher_married_belowp2019=Count_Household_HouseholderEducationalAttainmentBachelorsDegreeOrHigher_MarriedCoupleFamilyHousehold_BelowPovertyLevelInThePast12Months_2019)

atlas_datacommons_final<-atlas_datacommons_final%>%
  select(-X, cz)

# set up seed:
set.seed(12345)

#Creating an id variable to divide data into test and training
atlas_datacommons_final$id <- 1:nrow(atlas_datacommons_final)

#use 70% of dataset as training set and 30% as test set
train <- atlas_datacommons_final %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(atlas_datacommons_final, train, by = 'id')

# Save training and testing dataset:
saveRDS(train, here("data","atlas_train.rds"))
saveRDS(test, here("data","atlas_test.rds"))

