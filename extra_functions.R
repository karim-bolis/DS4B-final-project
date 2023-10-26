# This function will be called by the main document to obtain mean annual temperatures for all species in avonet.

# World Mean annual temperature data was downloaded from WorldClim above, who store data from 1970-2000 for the whole world. (Fick & Hijmans 2017) Using the raster package function "extract", I find the temperature for every lat/long spatial point representing the centre of a species living range. I then filter out species with no temperature as a result of their living range being too remote for data collection.

library(raster)
library(sp)

worldclim = getData("worldclim",var="bio",res=2.5, path="raw_data")

worldclim <- worldclim[[1]]

get_mean_annual_temp <- function(climate_data, lat, long) {
  point = SpatialPoints(data.frame(longitude = long, latitude = lat), proj4string = climate_data@crs)
  return(raster::extract(climate_data, point))
}

add_mean_annual_temp <- function(avonet_data) {
  avonet_data = avonet_data %>%
    mutate(mean_annual_temp = get_mean_annual_temp(worldclim, Centroid.Latitude, Centroid.Longitude)/10)
  
  avonet_data = filter(avonet_data, !is.na(mean_annual_temp))
  
  return(avonet_data)
}
