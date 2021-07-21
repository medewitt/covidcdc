# Purpose: Create Longitudinal Data from CDC Scrapes

library(stringr)
library(dplyr)
library(purrr)

h <- here::here

county_details <- fs::dir_ls(h("data", "county-detail"), glob = "*.json")

pull_time <- lubridate::as_datetime(str_remove(basename(county_details), "\\.json"))

pull_date <- lubridate::date(pull_time)

dat_information <- data.frame(
  county_details= unname(county_details),
  pull_time,
  pull_date
) %>%
  group_by(pull_date) %>%
  filter(pull_time==max(pull_time))

dat_raw <- map(dat_information$county_details, jsonlite::read_json)

a <- lapply(dat_raw, `[[`, 2)
b <- data.table::rbindlist(lapply(a, data.table::rbindlist, fill = TRUE), fill = TRUE)

dat_out <- b[State_name=="North Carolina"]
str(dat_out)
dat_out <- dat_out[,County:=stringr::str_remove(County, " County")]

data.table::fwrite(dat_out, h("output", "nc-county-detail.csv"))
