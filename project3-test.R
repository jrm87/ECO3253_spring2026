# Project 3 test:

library(pacman)
p_load(here, tidyverse, Hmisc)
# tidylog is usefull to see results of merges

atlas_socialk<-readRDS( here("data", "atlas_socialk_tract.rds"))



atlas_socialk%>%
  ggplot( aes(x=ec_zip, y=kfr_pooled_p25))+
  geom_point()
