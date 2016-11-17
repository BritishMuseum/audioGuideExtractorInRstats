#' ----
#' title: " A script for getting visits data from the MySQL audioguide API"
#' author: "Daniel Pett"
#' date: "17/11/2016"
#' output: csv_document
#' Tested on R 3.3.2 "Sincere Pumpkin Patch"
#' ----

# Set up working directory
setwd('/Users/danielpett/Documents/audioGuideExtractorInRstats') #MacOSX
# List of packages needed
list.of.packages <- c("RMySQL", "DBI","jsonlite")

# Install packages if not already
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RMySQL)
library(DBI)
library(jsonlite)
# Set up tokens and types (move to external file)
keys <- fromJSON('keys.json')
con <-  dbConnect(RMySQL::MySQL(), 
                  username = keys$mysqlUserName, 
                  password = keys$mysqlPassword,
                  host = keys$mysqlHost, 
                  port = keys$mysqlPort, 
                  dbname = keys$mysqlDbName
)
dbListTables(con)

# Extract data will take time ~ 80MB - this is just a dump of the table
visits <- dbReadTable(conn = con, name = keys$mysqlTable)
# Set filename
filename <- 'audioGuideVisits.csv'

# Write csv file
write.csv(visits, file=filename,row.names=FALSE, na="")

#' ----
# You could ignore below this point if you wanted to.
#' ----
# Count the number of visits
count <- dbSendQuery(con, "select COUNT(*) AS number from visits;")
data <- fetch(count, n=1)
print(data)
dbClearResult(data)
locales <- dbSendQuery(con, "SELECT locale, COUNT( * ) AS visits FROM  visits GROUP BY locale")
localeCount <- fetch(locales)
print(localeCount)
# Create an awful pie chart(have not spent time on this)
pie(localeCount$visits, labels =localeCount$locale, main="Pie Chart of locales for audio devices")