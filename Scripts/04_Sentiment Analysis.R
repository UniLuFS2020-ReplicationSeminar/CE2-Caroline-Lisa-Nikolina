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

# Sort by descending sentiment scores (highest to lowest)
sentiment_scores_desc <- sentiment_scores %>%
  arrange(desc(sentiment_score))

# Display the head of the sorted tibble
head(sentiment_scores_desc)

# Sort by ascending sentiment scores (lowest to highest)
sentiment_scores_asc <- sentiment_scores %>%
  arrange(sentiment_score)

# Display the head of the sorted tibble
head(sentiment_scores_asc)

# Summarize sentiments
sentiment_summary <- sentiment_scores %>%
  summarise(total_positive = sum(positive),
            total_negative = sum(negative))

# Calculate the net sentiment score
sentiment_summary <- sentiment_summary %>%
  mutate(net_sentiment = total_positive - total_negative)

# Determine if the overall sentiment is positive, negative, or neutral
if (sentiment_summary$net_sentiment > 0) {
  conclusion <- "Overall sentiment is positive."
} else if (sentiment_summary$net_sentiment < 0) {
  conclusion <- "Overall sentiment is negative."
} else {
  conclusion <- "Overall sentiment is neutral."
}

# Print the sentiment summary and conclusion
print(sentiment_summary)
print(conclusion)


