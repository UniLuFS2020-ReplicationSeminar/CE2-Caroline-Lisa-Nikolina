library(tidyverse)
library(httr)
library(rvest)

# Set up credentials
theguardian_cred <- readr::read_csv(file = here::here("credentials.csv"))

# Base URL for The Guardian API
base_url <- "https://content.guardianapis.com/search?q=open%20AI&api-key=c30f9048-1c79-4e1e-800a-93693df18f9c"

# API key
api_key <- theguardian_cred$api_key

# Make the GET request
response <- GET(url = base_url, query = list('api-key' = api_key))

# Parse the response
library(jsonlite)

article_data <- content(response, as = "text") %>%
  fromJSON()

articles <- article_data$response$results