library(pacman)
p_load(here, tidyverse, readxl, stringr, stringi, tidylog, Hmisc)
# tidylog is usefull to see results of merges

#Project 3 Data

# Description of the data:
# https://s3.us-east-1.amazonaws.com/hdx-production-filestore/resources/fbe5b0b9-e81c-41c7-a9f2-3ebf8212cf64/data_release_readme_31_07_2022_nomatrix.pdf?AWSAccessKeyId=AKIAXYC32WNARK756OUG&Signature=vyBWvlmisWshnN2B26dI%2FgPf7VU%3D&Expires=1666197435

# 23028 zip codes in social K data:
socialcap<-read_csv(here("data", "social_capital_zip.csv"))

# 73278 tracts in atlas data:
atlas <- readRDS(gzcon(url("https://raw.githubusercontent.com/jrm87/ECO3253_repo/master/data/atlas.rds")))

# Data from HUD on crosswalk between ZIP and tract: https://www.huduser.gov/portal/datasets/usps/ZIP_TRACT_122010.xlsx
# https://www.huduser.gov/portal/datasets/usps_crosswalk.html
# Have the option of using the ZIP to TRACT or the TRACT to ZIP crosswalk. In this case, given that we want to assign a ZIP for each tract in atlas, we use the TRACT to ZIP:

# 172177 observations in crosswalk.
# length(unique(crosswalk$zip)): 39324 ZIP;
# length(unique(crosswalk$tract)): 73472 TRACT
crosswalk<-read_xlsx(here("data", "TRACT_ZIP_122021.xlsx"))

# Variable res_ratio is the share of all residential addresses in tract that belong to that ZIP

#Renaming zip code in crosswalk data
crosswalk<- rename(crosswalk, TRACT=tract)

#Separating the last 6 digits from TRACT in the crosswalk data to have the census tract codes
crosswalk$tract<-str_sub(crosswalk$TRACT,-6,-1)
#Separating the county id
crosswalk$county<-str_sub(crosswalk$TRACT,3,5)
#Same for state
crosswalk$state<-str_sub(crosswalk$TRACT,1,2)

#Eliminating other variables
crosswalk<-crosswalk%>%
  select(-bus_ratio, -oth_ratio, -tot_ratio)


#Adding leading 0s to tract variable in the atlas data
atlas$tract<- stri_pad_left(atlas$tract, 6, 0)
atlas$county<- stri_pad_left(atlas$county, 3, 0)
atlas$state<- stri_pad_left(atlas$state, 2, 0)

# Select only the variables for merge, as this will be the basis of a collapse by tract later on, and then to be merged back with the original atlas data
atlas_obs<-atlas%>%
  select(tract, county, state)


#Left merge:
# only in x: 218; only in y: 722; matched: 171455
# there are now multiple rows for each tract in case it has more than one ZIP
atlas2<-atlas_obs %>% left_join(crosswalk,by=c("tract","county", "state"))

#Adding a leading 0 to zip code in social capital data
socialcap$zip<- stri_pad_left(socialcap$zip, 5, 0)

# drop county varieble (it exists in atlas)
socialcap<-socialcap%>%
  select(-county)

#Merging atlas and social capital
# only in x: 24547; only in y: 12; merged: 147126
atlas_socialcap<-atlas2 %>% left_join(socialcap,by= "zip")

# Collapse data by tract, so the final observation is at the tract level:

atlas_socialcap_bytract<-atlas_socialcap%>%
  group_by(tract,county, state)%>%
  summarise(num_below_p50=wtd.mean(num_below_p50, res_ratio, na.rm=TRUE),
            ec_zip=wtd.mean(ec_zip, res_ratio, na.rm=TRUE),
            ec_se_zip=wtd.mean(ec_se_zip, res_ratio, na.rm=TRUE),
            nbhd_ec_zip=wtd.mean(nbhd_ec_zip, res_ratio, na.rm=TRUE),
            ec_grp_mem_zip=wtd.mean(ec_grp_mem_zip, res_ratio, na.rm=TRUE),
            ec_high_zip=wtd.mean(ec_high_zip, res_ratio, na.rm=TRUE),
            ec_high_se_zip=wtd.mean(ec_high_se_zip, res_ratio, na.rm=TRUE),
            nbhd_ec_high_zip=wtd.mean(nbhd_ec_high_zip, res_ratio, na.rm=TRUE),
            ec_grp_mem_high_zip=wtd.mean(ec_grp_mem_high_zip, res_ratio, na.rm=TRUE),
            exposure_grp_mem_zip=wtd.mean(exposure_grp_mem_zip, res_ratio, na.rm=TRUE),
            exposure_grp_mem_high_zip=wtd.mean(exposure_grp_mem_high_zip, res_ratio, na.rm=TRUE),
            nbhd_exposure_zip=wtd.mean(nbhd_exposure_zip, res_ratio, na.rm=TRUE),
            bias_grp_mem_zip=wtd.mean(bias_grp_mem_zip, res_ratio, na.rm=TRUE),
            bias_grp_mem_high_zip=wtd.mean(bias_grp_mem_high_zip, res_ratio, na.rm=TRUE),
            nbhd_bias_zip=wtd.mean(nbhd_bias_zip, res_ratio, na.rm=TRUE),
            nbhd_bias_high_zip=wtd.mean(nbhd_bias_high_zip, res_ratio, na.rm=TRUE),
            clustering_zip=wtd.mean(clustering_zip, res_ratio, na.rm=TRUE),
            support_ratio_zip=wtd.mean(support_ratio_zip, res_ratio, na.rm=TRUE),
            volunteering_rate_zip=wtd.mean(volunteering_rate_zip, res_ratio, na.rm=TRUE),
            civic_organizations_zip=wtd.mean(civic_organizations_zip, res_ratio, na.rm=TRUE))


# Merge back with atlas data:
# only in x:0; only in y: 0; matched: 73278
atlas_socialcap_final<-atlas%>%
  left_join(atlas_socialcap_bytract, by=c("tract","county", "state"))

# Revert tract, county and state to int:
atlas_socialcap_final<-atlas_socialcap_final%>%
  mutate(tract=as.numeric(tract), county=as.numeric(county), state=as.numeric(state))

#save as csv
write.csv(atlas_socialcap_final,here("data", "atlas_socialk_tract.csv"), row.names = FALSE)
# save as RDS
saveRDS(atlas_socialcap_final, here("data", "atlas_socialk_tract.rds"))


