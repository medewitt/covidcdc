# Purpose: Create Longitudinal Data from CDC Scrapes

library(stringr)
library(dplyr)
library(purrr)

h <- here::here

county_details <- fs::dir_ls(h("data", "county-covid"), glob = "*.json")

pull_time <- lubridate::as_datetime(str_remove(basename(county_details), "\\.json"))

pull_date <- lubridate::date(pull_time)

dat_information <- data.frame(
  county_details= unname(county_details),
  pull_time,
  pull_date
) %>%
  group_by(pull_date) %>%
  filter(pull_time==max(pull_time))

quick_json_read <- function(x){
  RcppSimdJson::fload(x)$vaccination_county_condensed_data
}

dat_raw <- map(dat_information$county_details, quick_json_read)

b <- data.table::rbindlist(dat_raw, fill = TRUE)

dat_out <- b[StateName=="North Carolina"]

dat_out <- dat_out[,County:=stringr::str_remove(County, " County")][,1:12]

data.table::fwrite(dat_out, h("output", "nc-county-vax.csv"))
