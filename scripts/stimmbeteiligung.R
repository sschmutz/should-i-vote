library(tidyverse)

stimmbeteiligung <-
  read_delim("data/stimmbeteiligung.tsv", "\t", escape_double = FALSE, col_types = cols(Stimmberechtigte = col_integer()), trim_ws = TRUE) %>%
  mutate(Beteiligung = Beteiligung /100)

stimmbeteiligung_plot <-
  ggplot(stimmbeteiligung, aes(x = Jahr, y = Beteiligung)) +
  geom_line(size = 1) +
  labs(x = "year", y = "voter participation") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  theme_minimal()

stimmbeteiligung_plot

ggsave(filename = "data/stimmbeteiligung.png", plot = stimmbeteiligung_plot, width = 5, height = 2.5)
