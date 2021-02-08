library(tidyverse)
library(car)
library(ggplot)
library(readxl)
library(ggmap)

listings <- read_excel("9_Dec_2019_Listings.xlsx")
summary(listings)

listings2 <- read_excel("9Dec2019_PriceAmenitiesRatings.xlsx")

location <- listings[c("zipcode", "latitude", "longitude")]
summary(location)
min(location$latitude) #bottom = 51.29479 
max(location$latitude) #top = 51.68169
min(location$longitude) #left = -0.4966
max(location$longitude) #right = 0.285

bbox <- c(left = -0.49, bottom = -0.29, right = 51.7, top = 51.2)
map <- get_stamenmap(bbox, zoom = 6, maptype = "terrain-background", color = "color")
ggmap(map)

hist(listings2$review_scores_rating, breaks = 50)
summary(listings2$review_scores_rating)
length(which(listings2$review_scores_rating > 95)) # 
dim(listings2)
summary(lm1)
# reviews_per_month
# number_of_reviews_ltm
