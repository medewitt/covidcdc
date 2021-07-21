#!/usr/bin/Rscript
download.file(
  "https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=vaccinati
on_county_condensed_data",
sprintf("data/county-covid/%s.json", slugify::slugify(Sys.time())),
quiet = TRUE,
cacheOK = FALSE
)

download.file(
"https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=integrated_county_latest_external_data",
sprintf("data/county-detail/%s.json", slugify::slugify(Sys.time())),
quiet = TRUE,
cacheOK = FALSE
)
