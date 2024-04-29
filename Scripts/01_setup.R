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
  print(content_data)
} else {
  # If the request failed, print the status code
  print(paste("Failed to retrieve data:", status_code(response)))
}
