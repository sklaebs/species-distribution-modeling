#gbif.R
# query species occurrence data from GBIF
# clean up the data
#save it to a csv file
#create a map to display the species occurrence points

# Fun way to load packages (and not get tripped up)
# list of packages
packages <- c("tidyverse", "rgbif", "usethis", "CoordinateCleaner", "leaflet", "mapview")
# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
# Packages loading
invisible(lapply(packages, library, character.only = TRUE))


spiderBackbone<-name_backbone(name='Habronattus americanus')
#look at result
speciesKey<-spiderBackbone$speciesKey

occ_download(pred("taxonKey", speciesKey),format = "SIMPLE_CSV")

# <<gbif download>>
# Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0003699-240216155721649
# Most downloads finish within 15 min.
# Check status with
# occ_download_wait('0003699-240216155721649')
# After it finishes, use
# d <- occ_download_get('0003699-240216155721649') %>%
#   occ_download_import()
# to retrieve your download.
# Download Info:
#   Username: sklaebs
# E-mail: lc22-0566@lclark.edu
# Format: SIMPLE_CSV
# Download key: 0003699-240216155721649
# Created: 2024-02-19T23:09:25.798+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
# https://www.gbif.org/citation-guidelines
# DOI: 10.15468/dl.szdnhu
# Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.szdnhu Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-19

d <- occ_download_get('0003699-240216155721649',path="data/") %>%
    occ_download_import()

write_csv(d, "data/rawdata.csv")
#data cleaning

fData<- d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData<-fData %>%
  filter(countryCode %in% c("US", "MX", "CA"))

#fData <- fData %>%
#  filter(countryCode == "US"|countryCode == "MX"|countryCode == "CA")

fData<-fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

fData <- fData %>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")


# remove duplicates
fData <- fData %>%
  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)


#one fell swoop
# cleanData <- d %>%
#   filter(!is.na(decimalLatitude), !is.na(decimalLongitude)) %>%
#   filter(countryCode %in% c("US", "MX", "CA")) %>%
#   filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN")) %>%
#   cc_sea(lon="decimalLongitude", lat="decimalLatitude") %>%
#   distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)

write_csv(fData, "data/cleanData.csv")


  