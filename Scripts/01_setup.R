library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)
library(readr)
library(here)  # For file path management

# Load credentials
theguardian_cred <- readr::read_csv(file = here::here("credentials.csv"))

# Base URL for The Guardian API
base_url <- "https://content.guardianapis.com/search"

# API key
api_key <- theguardian_cred$api_key

# Set up storage for all articles
all_articles <- tibble()

# Set the total number of pages
total_pages <- 5057  # Adjust based on the total results divided by results per page

# Loop through all pages
for (page in 1:total_pages) {
  # Construct the query for each page
  query_list <- list('q' = 'open AI', 'api-key' = api_key, 'page' = as.character(page), 'page-size' = '10')
  
  # Make the GET request
  response <- GET(url = base_url, query = query_list)
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the response
    article_data <- content(response, as = "text") %>%
      fromJSON()
    
    # Extract the articles
    articles <- article_data$response$results %>% 
      select(title = webTitle, url = webUrl, date = webPublicationDate, section = sectionName)
    
    # Append the articles to the all_articles tibble
    all_articles <- bind_rows(all_articles, articles)
  } else {
    print(paste("Failed to fetch data for page", page))
  }
  
  # Optional: a polite delay to avoid hitting the server too hard
  Sys.sleep(2)
}

# View the structure of the collected articles
print(all_articles)

# Save the data to a CSV file
write_csv(all_articles, "all_articles.csv") 