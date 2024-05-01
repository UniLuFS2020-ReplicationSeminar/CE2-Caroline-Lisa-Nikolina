# Install and load required packages
install.packages("tm")
install.packages("wordcloud")
install.packages("udpipe")
library(tm)
library(wordcloud)
library(readr)
library(udpipe)
library(NLP)
library(RColorBrewer)
library(SnowballC)

# Convert titles to a corpus
all_articles <- read_csv("Data/all_articles.csv")
titles_corpus <- Corpus(VectorSource(all_articles$title))

# Function for stemming
stemmer <- function(word) wordStem(word, language = "english")

#Function for lemmitization
lemmatizer <- function(sentence) {
  udpipe_model <- udpipe_download_model(language = "english")
  udpipe_annotate(udpipe_model, x = sentence, doc_id = 1)$lemma
}

# Preprocess the text: remove punctuation, convert to lowercase, remove stopwords
titles_corpus <- tm_map(titles_corpus, content_transformer(tolower))
titles_corpus <- tm_map(titles_corpus, removePunctuation)
titles_corpus <- tm_map(titles_corpus, removeWords, stopwords("en"))

# Stem the words
titles_corpus <- tm_map(titles_corpus, content_transformer(stemmer))

# Lemmatize the words
titles_corpus <- tm_map(titles_corpus, content_transformer(lemmatizer))

# Create a document term matrix
dtm <- DocumentTermMatrix(titles_corpus)

# Convert the document term matrix to a matrix
m <- as.matrix(dtm)

# Get word frequencies
word_freq <- colSums(m)

# Set the size of the plot
png("wordcloud.png", width = 1200, height = 1200)

# Create a word cloud with the 100 most frequent words
wordcloud(names(word_freq), word_freq, max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

# Save the plot
dev.off()
