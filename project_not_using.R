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

summary(listings1$reviews_per_month)
hist(listings1$reviews_per_month)
# reviews_per_month > 8 
# number_of_reviews_ltm


## 2. Mod1.1: glm - superhost

```{r}
logi.m1 <- glm(superhost_n~., family = binomial(link = "logit"), data = listings2)
summary(logi.m1)
ct.op <- function(predicted, observed) {
  df.op <- data.frame(predicted = predicted, observed = observed)
  # create a table
  op.tab <- table(df.op)
  # use the prop.table function to obtain the rows we need and stack them on
  # top of each other with rbind
  op.tab <- rbind(op.tab, c(round(prop.table(op.tab, 2)[1, 1], 2), round((prop.table(op.tab, 2)[2, 2]), 2)))
  # name the rows
  rownames(op.tab) <- c("pred=0", "pred=1", "%corr")
  # name the columns
  colnames(op.tab) <- c("obs=0", "obs=1")
  # return the table
  op.tab
}


pred.pk<-as.numeric(logi.m1$fitted.values>0.5)
which(is.na(listings2$reviews_per_month)) #

#pass the fitted values and the observed values to ct.op
ct.op(pred.pk,listings2$superhost_n[-c(14100, 22677)])
```

too many signals for non superhost but too few for superhosts?
  

summary(listings2$superhost_n)
listings_T <- listings2[listings2$superhost_n == T,]
listings_F <- listings2[listings2$superhost_n == F,]
Fsam_index <- sample(dim(listings_F)[1], size = dim(listings_T)[1])
listings_Fsam <- listings_F[Fsam_index,]

listings_bal <- rbind(listings_T, listings_Fsam)

logi.m2 <- glm(superhost_n~., family = binomial(link = "logit"), data = listings_bal)
summary(logi.m2)

pred.m2<-as.numeric(logi.m2$fitted.values>0.5)
ct.op(pred.m2,listings_bal$superhost_n)
```



## 3. Mod1.2: decision tree - superhost
```{r}
tree.sup1 <- tree(superhost_n ~ ., data=listings2)
summary(tree.sup1)
#this is expected because we know only superhosts are those who fulfil the following requirement [see below]

#without the variables that form the requirement for becoming a superhost
tree.sup2 <- tree(superhost_n ~ .-review_scores_rating - reviews_per_month - host_response_time_n - host_response_rate_n, data=listings2)
summary(tree.sup2) #error in training data = 0.1967
plot(tree.sup2) #plot tree
text(tree.sup2, pretty=0, cex=0.6)
#all false

#tree on balanced dataset
tree.sup3 <- tree(superhost_n ~ .-review_scores_rating - reviews_per_month - host_response_time_n - host_response_rate_n, data=listings_bal)
summary(tree.sup3) #misclassification = 0.3479
plot(tree.sup3) 
text(tree.sup3, pretty=0, cex=0.6)

#assess perfomance of tree.sup3 on new data
nrow(listings_bal) * 0.8
set.seed(1)
train.index=sample(1:nrow(listings_bal), 16203) #80% of original data used for training
train.dat <- listings_bal[train.index,]
test.dat <- listings_bal[-train.index,]
superhost_test <- listings_bal$superhost_n[-train.index]
tree.sup4 <- tree(superhost_n ~.-review_scores_rating - reviews_per_month - host_response_time_n - host_response_rate_n, data=train.dat)
tree.sup4.predict <- predict(tree.sup4, test.dat, type="class")
table(tree.sup4.predict, superhost_test)

summary(tree.sup3) #misclassification = 0.3479
plot(tree.sup3) 
text(tree.sup3, pretty=0, cex=0.6)
```

## 4. Mod2.1: glm - popular

## 5. Mod3: mlr- price

```{r}
lm1 <- lm(price_n~., data=listings2)
summary(lm1) #0.09

lm2 <- lm(price_n ~ mil_to_centre_n + property_type_n + bed_type_n + room_type, data=listings2)
summary(lm2)

#with original price
lm3 <- lm(price ~ mil_to_centre_n + property_type_n + bed_type_n + room_type + superhost_n + amen_count, data=listings3)
summary(lm3)

```

## 6. Mod4: mlr-no. of reviews

```{r}
lm.r.n <- lm(reviews_per_month ~ 1, data=listings2)
lm.r.f <- lm(reviews_per_month ~ ., data=listings2)
lm.r.fit <- step()
summary(lm.r1)
```


#
Superhost requirements
- Completed at least 10 trips OR completed 3 reservations that total at least 100 nights
- Maintained a 90% response rate or higher
- Maintained a 1% percent cancellation rate (1 cancellation per 100 reservations) or lower, with exceptions made for those that fall under our Extenuating Circumstances policy
- Maintained a 4.8 overall rating (this rating looks at the past 365 days of reviews, based on the date the guest left a review, not the date the guest checked out)

