library(ggforce)
library(tidyverse)
library(palmerpenguins)

melted_titanic <- reshape2::melt(Titanic)
parallel_sets_titanic <- gather_set_data(data = melted_titanic, x = 1:4)

peng_wide <- penguins |> 
  drop_na() |> 
  count(year, island, sex, species) |> 
  mutate(year = factor(year)) |> 
  rename(value = n)
parallel_sets_penguins <- gather_set_data(data = peng_wide, x = 1:4)

ggplot(data = parallel_sets_penguins, 
    mapping = aes(x, id = id, split = y, value = value)) +
  geom_parallel_sets(aes(fill = sex), 
      alpha = 0.3, axis.width = 0.07) +
  geom_parallel_sets_axes(axis.width = 0.07) +
  geom_parallel_sets_labels(size = 3.5, colour = 'white') +
  scale_x_continuous(labels = c("Year", "Island", "Sex", "Species")) +
    labs(title = "Parallel Sets of Penguins Data", 
        x = "", y = "Count") + 
    theme_minimal(base_size = 14)

ggplot(parallel_sets_titanic, aes(x, id = id, split = y, value = value)) +
  geom_parallel_sets(aes(fill = Sex, color = Sex), 
      alpha = 0.3, 
      axis.width = 0.1) +
  geom_parallel_sets_axes(axis.width = 0.1) +
  geom_parallel_sets_labels(
      size = 3.5, 
      colour = 'black',
      angle = 0, 
      nudge_x = 0.1, 
      hjust = 0) + 
  scale_x_continuous(labels = c("Class", "Sex", "Age", "Survived")) + 
    labs(title = "Parallel Sets of Penguins Data", 
        x = "", y = "Count") + 
    theme_minimal(base_size = 14)


