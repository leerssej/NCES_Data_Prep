# R Script - dplyr predominant
# Author: leerssej
# Date:  Wed Jun 07 16:22:21 2017 
 
# Desc: Clean Up the NCES Demographic Data
# Desc: Pulling just numbers and NA'ing all their NA symbols into NA's
# Desc: 
# Desc: 


library(tidyverse)
library(magrittr)
# library(RPostgres)
# library(googlesheets)
# library(readxl)
# library(ggmap)
# library(geosphere)
# library(stringdist)
# library(RecordLinkage)

###### 1. Load Data ######
## Note that the Header & Footer Schmutz must be removed either by hand, or with Bash Script
### I've tried everywhichwaytoSunday to get the data to ignore that crap, but readr just can't
### help but get all tangled up in its silliness.

path <- "/Users/Koyot/Documents/NCES_datastore/"
dim_NCES_schl_demo <- read_csv(paste0(path, "ELSI_csv_export_Demo.csv"), col_types = cols(.default = "c"))
glimpse(dim_NCES_schl_demo)

dim_NCES_schl_demo <- 
    dim_NCES_schl_demo %>% 
    mutate(public = TRUE,
           sc_yr = '2015')

colnames(dim_NCES_schl_demo) %<>% gsub("\\[Public School\\]", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("(Latest available year)|20\\d\\d-\\d\\d", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+Students", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+-\\s+", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("^.*\\s+School", "School", ., ignore.case = T)
colnames(dim_NCES_schl_demo) %<>% tolower
colnames(dim_NCES_schl_demo) %<>% trimws
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+", "_", .)
glimpse(dim_NCES_schl_demo)    

