##Setting packages#
library(rvest)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
##############################
##Scraping data from website##
##     Data wrangling       ##
##############################

#Setting URL
url <- "https://coinmarketcap.com/all/views/all/"

## Scraping cryptocurrency names
Crypto <- read_html(url) %>% 
  html_nodes(".currency-name-container") %>% 
  html_text() %>% 
  data.frame()

#naming column
colnames(Crypto) <- "Name"

##Scraping crypto's symbol
Symbol <- read_html(url) %>% 
  html_nodes(".text-left.col-symbol") %>% 
  html_text() %>% 
  data.frame()

##Scraping market's capital
Market_cap <- read_html(url) %>% 
  html_nodes("#currencies-all .market-cap") %>% 
  html_text () %>%
  data.frame()

#Changing unwanted characters (?) to empty
Market_cap$. <- gsub(pattern = "([?])", replacement = "", x = Market_cap$.)


##scraping current price
Price <- read_html(url) %>% 
  html_nodes(".price") %>% 
  html_text() %>% 
  data.frame()

#Changing unwanted characters (?) to empty
Price$. <- gsub(pattern = "([?])", replacement = "", x = Price$.)

##scraping circulating supply
Circulation_Supply <- read_html(url) %>% 
  html_nodes(".circulating-supply") %>% 
  html_text() %>% 
  data.frame()

#Changing unwanted characters (?) to empty
Circulation_Supply$. <- gsub(pattern = "([?])", replacement = "", x = Circulation_Supply$.)

# Is the cryptocurrency mineable
Circulation_Supply$Mineable <- as.numeric(grepl("[*]", Circulation_Supply$.))

# Erasing * character from circulating supply variable
Circulation_Supply$. <- gsub(pattern = "([*])", replacement = "", x = Circulation_Supply$.)

# renaming columns
colnames(Circulation_Supply) <- c("Circulating_Supply","Mineable")

##scraping volume
Volume <- read_html(url) %>% 
  html_nodes(".circulating-supply+ .text-right") %>% 
  html_text() %>% 
  data.frame(stringsAsFactors = FALSE)

#Changing unwanted characters (?) to empty
Volume$. <- gsub(pattern = "([?]|Low|Vol)", replacement = "", x = Volume$.)


## Scraping variation % in 1 hour
one_hour <- read_html(url) %>% 
  html_nodes("td:nth-child(8)") %>% 
  html_text() %>% 
  data_frame()

#Changing unwanted characters (?) to empty
one_hour$. <- gsub(pattern = "([?])", replacement = "", x = one_hour$.)

## craping variation % in 24 hours
twenty_four <- read_html(url) %>% 
  html_nodes("td:nth-child(9)") %>% 
  html_text() %>% 
  data.frame()

#Changing unwanted characters (?) to empty
twenty_four$. <- gsub(pattern = "([?])", replacement = "", x = twenty_four$.)

## Scraping variation % in7 days
seven_days <- read_html(url) %>% 
  html_nodes("td:nth-child(10)") %>% 
  html_text() %>% 
  data.frame()

#Changing unwanted characters (?) to empty
seven_days$. <- gsub(pattern = "([?])", replacement = "", x = seven_days$.)

##merging into one dataframe
Crypto["Symbol"]<- data.frame(Symbol)
Crypto["Market_cap"]<- data.frame(Market_cap)
Crypto["Price"]<- data.frame(Price)
Crypto["Circulation_Supply"]<- data.frame(Circulation_Supply$Circulating_Supply)
Crypto["Mineable"]<- data.frame(Circulation_Supply$Mineable)
Crypto["Volume(24h)"]<- data.frame(Volume)
Crypto["Var%1hour"]<- data.frame(one_hour)
Crypto["Var%24hours"]<- data.frame(twenty_four)
Crypto["Var%7days"]<- data.frame(seven_days)
