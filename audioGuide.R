#' ----
#' title: " A script for getting Contentful data from the audioguide space"
#' author: "Daniel Pett"
#' date: "28/10/2016"
#' output: csv_document
#' ----

# Set up working directory
setwd("~/Documents/research/contentful/") #MacOSX

# List of packages needed
list.of.packages <- c("rjson", "RCurl","jsonlite")

# Install packages if not already
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Initiate libraries
library(RCurl)
library(rjson)
library(jsonlite)


# Set up tokens and types (move to external file)
keys <- fromJSON('keys.json')
apiToken <- keys$apitoken
apiUrl <- 'https://cdn.contentful.com/spaces/'
apiSpace <- keys$apiSpace
type <- keys$type

# Define Url for query to be made
allEntries <- paste0(
  apiUrl,apiSpace,
  '/entries?access_token=',
  apiToken,
  '&content_type=',
  type
  )

data <- getURL(allEntries)
rawJson <- fromJSON(data)
total <- rawJson$total
payload <- rawJson$items

# Work out pagination
pagination <- ceiling(total/100)

# Paginate through data
for (i in seq(from=1, to=2, by=1)){
  skip <- i * 100
  url <- paste0(allEntries,'&skip=',skip)
  print(url)
  moreData <- getURL(url)
  jsonPaged <- fromJSON(moreData)
  assign(paste0("a", i), jsonPaged$items) 
}

# Messy bit for working out the pages to append
final <- append(payload, a1)
finalData <- append(final, a2)

# Get the required data
extract2 <- sapply(finalData, "[", c(1,2))
test3 <- as.data.frame(t(extract2))

# Get system attributes
sys <- as.data.frame(t(sapply(test3$sys, "[", c(2,4,5,6))))
sys$key <- 1:nrow(sys)

# Get field attributes
fields <- as.data.frame(t(sapply(test3$fields, "[", c('number','oldStopNumber','title'))))
fields$key <- 1:nrow(fields)

# Set up the export 
export <- merge(x = sys, y = fields, by = 'key')

# Flatten any crappy lists
export$title <- vapply(export$title, paste, collapse = ", ", character(1L))

# Order the data fields
preforder <- c(
  'key',"title", "id", "number", "oldStopNumber", 
  'revision', 'createdAt', 'updatedAt'
)  

# Set prefered order
export <- export[ ,preforder]

# Convert to matrix
export = as.matrix(export)

# Set filename
filename <- 'contentfulAudioGuide.csv'

# Write csv file
write.csv(export, file=filename,row.names=FALSE, na="")