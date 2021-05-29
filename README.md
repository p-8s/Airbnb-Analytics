# Analytics of Airbnb

This repository contains our team's data analytics project on Airbnb listings.

## The Problem 

The motivation behind our interest lies in the fact that there is a sizeable group of people interested to rent their homes through a service such as Airbnb - and a huge majority believes renting their homes on Airbnb is a good money making-strategy. 

A previous approach found online regressed prices against various attributes and found that prices positively correlate with locations amongst other factors. Property prices and upkeep vary with location, so it may be difficult to judge true profit from prices alone. Our project will seek to explore another response variable: popularity. We would like to check for possible relationships between popular listings and our variables at hand, and see if there are any insights available. 

## The Analysis

We created several graphs to demonstrate the univariate relationship between popularity and variables, which included maps and wordclouds. We also utilised methods such as logistic regression, decision tree, bagging and random forest to build explanatory models. 


## The Data

Our data is sourced from [insideAirbnb](https://www.insideAirbnb.com/), which has detailed scraped information obtained from Airbnb listings across multiple cities. We will use a snapshot of Airbnb listings data from London in 2019. There are 106 columns within a single dataset, so we removed 59 irrelevant columns in excel prior to loading the data into RStudio for further cleansing.   

