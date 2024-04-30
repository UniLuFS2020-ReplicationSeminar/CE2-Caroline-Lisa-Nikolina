# Install and load required packages
install.packages("tm")
install.packages("wordcloud")
library(tm)
library(wordcloud)
library(readr)

# Convert titles to a corpus
all_articles <- read_csv("all_articles.csv")
titles_corpus <- Corpus(VectorSource(all_articles$title))

# Preprocess the text: remove punctuation, convert to lowercase, remove stopwords
titles_corpus <- tm_map(titles_corpus, content_transformer(tolower))
titles_corpus <- tm_map(titles_corpus, removePunctuation)
titles_corpus <- tm_map(titles_corpus, removeWords, stopwords("en"))

# Create a document term matrix
dtm <- DocumentTermMatrix(titles_corpus)

# Convert the document term matrix to a matrix
m <- as.matrix(dtm)

# Get word frequencies
word_freq <- colSums(m)

# Create a word cloud
wordcloud(names(word_freq), word_freq, max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
