library(tidyverse)
library(httr)
library(rvest)

# Set up credentials
theguardian_cred <- readr::read_csv(file = here::here("credentials.csv"))

# Base URL for The Guardian API
base_url <- "https://content.guardianapis.com/search?q=open%20AI&api-key=c30f9048-1c79-4e1e-800a-93693df18f9c"

# API key (replace 'your_api_key' with your actual API key)
api_key <- theguardian_cred$api_key

# Make the GET request
response <- GET(url = base_url, query = list('api-key' = api_key))


# Check the status of the response
if (status_code(response) == 200) {
  # If request is successful, parse the response
  content_data <- content(response, "parsed")
  
  #Print content data
  print(content_data)
 
} else {
  # If the request failed, print the status code
  print(paste("Failed to retrieve data:", status_code(response)))
}

# Get the list of section names
section_names <- unique(sapply(content_data$response$results, function(article) article$sectionName))

# Loop through each section
for (section_name in section_names) {
  # Count the number of articles in the current section
  num_articles <- sum(sapply(content_data$response$results, function(article) article$sectionName == section_name))
  
  # Print the section name and the number of articles
  cat("Section:", section_name, "- Number of articles:", num_articles, "\n")
}

# Parse the response
library(jsonlite)

article_data <- content(response, as = "text") %>%
  fromJSON()

articles <- article_data$response$results