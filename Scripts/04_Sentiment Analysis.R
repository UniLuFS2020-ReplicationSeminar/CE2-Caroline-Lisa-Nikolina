# Install and load required packages
install.packages("tidytext")
install.packages("textdata")
install.packages("dplyr")
library(tidytext)
library(textdata)
library(readr)
library(dplyr)
library(tidyr)

# Load the data
all_articles <- read_csv("all_articles.csv")

all_articles <- as_tibble(all_articles)

# Tokenize the titles
title_tokens <- all_articles %>%
  unnest_tokens(word, title)

# Load the Bing lexicon for sentiment analysis
bing <- get_sentiments("bing")

# Perform sentiment analysis
sentiment_scores <- title_tokens %>%
  inner_join(bing) %>%
  count(word, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment_score = positive - negative)

# View the sentiment scores
head(sentiment_scores)
View(sentiment_scores)
