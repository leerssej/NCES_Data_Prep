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

path <- "/Users/Koyot/Documents/NCES_datastore/" # PC
path = ("/Users/jensleerssen/Google Drive/NCES_datastore_gdrive/") # mac
# mac
dim_NCES_schl_demo <-
    read_csv(paste0(path, "ELSI_csv_export_Demo.csv"), col_types = cols(.default = "c"))
# PC
# dim_NCES_schl_demo <- read_csv(paste0(path, "ELSI_csv_export_Demo.csv"), col_types = cols(.default = "c"))
glimpse(dim_NCES_schl_demo)

# General taming
dim_NCES_schl_demo <-
    dim_NCES_schl_demo %>%
    mutate(public = TRUE,
           sy = '2015')


# Pull header titles to earth
colnames(dim_NCES_schl_demo) %<>% gsub("\\[Public School\\]", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("(Latest available year)|20\\d\\d-\\d\\d", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+Students", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+-\\s+", "", .)
colnames(dim_NCES_schl_demo) %<>% gsub("^.*\\s+School", " School", ., ignore.case = T)
colnames(dim_NCES_schl_demo) %<>% tolower
colnames(dim_NCES_schl_demo) %<>% trimws
colnames(dim_NCES_schl_demo) %<>% gsub("\\s+", "_", .)
glimpse(dim_NCES_schl_demo)

# Fix the column names further
dim_NCES_schl_demo %<>%
    rename(nces_id = school_idnces_assigned,
           fl = free_lunch_eligible,
           rl = `reduced-price_lunch_eligible`,
           frl = free_and_reduced_lunch,
           ttl_stdnts = `total_all_grades_(includes_ae)`)
glimpse(dim_NCES_schl_demo)

# get NA variants and extra leading value packaging peeled out.
# old variant
# dim_NCES_schl_demo_clean <-
#     dim_NCES_schl_demo %>%
#     # mutate_all(funs(gsub("\\D+", NA, .))) # the all powerful variant that pulls all non numbers out.
#     mutate_all(funs(gsub("^=\\\"", "", .))) %>%
#     mutate_all(funs(gsub("\\\"$", "", .))) %>%
#     mutate_at(vars(nces_id:female), funs(gsub("\\D+", NA, .)))
# glimpse(dim_NCES_schl_demo_clean)

# pull digits and then snag lonely-nothings symbols
dim_NCES_schl_demo_nums_only <-
    dim_NCES_schl_demo %>%
    # mutate_all(funs(gsub(".*?(\\d+).*", "\\1", ., perl = T))) # all powerfulm
    mutate_at(vars(nces_id:female), funs(gsub(".*?(\\d+).*", "\\1", ., perl = T))) %>%
    mutate_at(vars(nces_id:female), funs(gsub("\\D+", NA, .)))
glimpse(dim_NCES_schl_demo_nums_only)

# save data, and write into a .csv for later restart
save(dim_NCES_schl_demo_nums_only, file = paste0(path, "dim_NCES_schl_demo_nums_only"))
write_csv(dim_NCES_schl_demo_nums_only, paste0(path, "dim_NCES_schl_demo_nums_only.csv"), na = "")
load(paste0(path, "dim_NCES_schl_demo_nums_only"))
glimpse(dim_NCES_schl_demo_nums_only)
