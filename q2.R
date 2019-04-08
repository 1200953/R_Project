library(ggmap) 
library(ggplot2) 
library(maps) 
library(mapproj)
library(shiny)

#read data into R
mdata <- read.csv("assignment-02-data-formated.csv") 
#check if data is loaded
dim(mdata)

plot1 <- ggplot(mdata, aes(year, value)) + geom_point(aes(color = year))
plot2 <- plot1 + facet_grid(coralType~reorder(location, +latitude))#reorder location based on latitude
plot3 <- plot2 + ggtitle("Bleaching for each kind and site over 8 years")#add title
plot4 <- plot3 + geom_smooth(aes(group = 1),#add smoother
                             method = "lm",
                             color = "red",
                             formula = y~x,
                             se = FALSE)
plot4

