library(tidyverse)
library(httr)
library(rvest)

# Set up credentials
theguardian_cred <- readr::read_csv(file = here::here("credentials.csv"))

client_id <- theguardian_cred$client_id
client_secret <-  theguardian_cred$client_secret

