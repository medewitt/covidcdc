#!/usr/bin/Rscript

slugify_date <- function(x){
	x <- stringi::stri_replace_all_regex(x,"[^\\P{P}-]","")
	x <- gsub(x, pattern = " ", replacement = "-")
	x
}
ping_time <- slugify_date(Sys.time())

try(download.file(
  "https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data",
sprintf("data/county-covid/%s.json", ping_time),
quiet = TRUE,
cacheOK = FALSE
))

download.file(
	"https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_by_state_fips_37",
#"https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data",
sprintf("data/county-detail/%s.json", ping_time),
quiet = TRUE,
cacheOK = FALSE
)
