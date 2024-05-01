# Create a bar plot comparing the articles by section
library(readr)

all_articles <- read_csv("Data/all_articles.csv")
View(all_articles)

all_articles %>%
  count(section) %>%
  ggplot(aes(x = fct_reorder(section, n), y = n)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(title = '"OpenAI" Articles by Section',
       x = "Sections",
       y = "Number of Articles") +
  theme_minimal()

# Save the plot
ggsave("Plots/Articles_by_Section.png", width = 10, height = 6, dpi = 300)
