# pkgs ----
library(tidyverse)
library(scales)
library(knitr)
library(kableExtra)
library(colorblindr)
library(downlit)
library(xml2)
library(reactable)
library(palmerpenguins)
library(ggplot2movies)
library(ggalluvial)
library(fivethirtyeight)
library(babynames)

# options ----
options(scipen = 9999999)


# fonts ----
library(extrafont)
library(sysfonts)
# import font
extrafont::font_import(
    paths = "assets/Ubuntu/",
    prompt = FALSE)
# add font
sysfonts::font_add(
    family =  "Ubuntu", 
    regular = "assets/Ubuntu/Ubuntu-Regular.ttf")
# use font
showtext::showtext_auto()
# add theme
source("R/theme_ggp2g.R")
# set theme
ggplot2::theme_set(theme_ggp2g(
    base_size = 13))

# penguins ----
penguins <- palmerpenguins::penguins
penguins_raw <- palmerpenguins::penguins_raw
peng_full <- janitor::clean_names(penguins_raw) 



# movies ----
movies <- ggplot2movies::movies

# babynames -------
babynames <- babynames::babynames


# alluvial charts -------------------------------------------------
peng_alluvial <- palmerpenguins::penguins_raw |> 
  janitor::clean_names() |> 
  dplyr::mutate(year = lubridate::year(date_egg),
         year = factor(year),
         individual_id = factor(individual_id),
         island = factor(island)) |> 
  dplyr::select(year, individual_id, island)
dplyr::glimpse(peng_alluvial)
# labels
labs_alluvial <- labs(title = "Penguin measurements across three years")
# alluvial geom_flow() ----
ggp2_alluvial_flow <- ggplot(data = peng_alluvial, 
  mapping = aes(x = year, stratum = island, 
                alluvium = individual_id,
                fill = island, label = island)) +
  scale_fill_brewer(type = "qual", palette = "Pastel2") +
  geom_flow(stat = "alluvium", lode.guidance = "frontback",
            color = "darkgray") 

ggp2_alluvial_flow
# alluvial geom_stratum() ----
ggp2_alluvial_stratum <- ggp2_alluvial_flow +
  geom_stratum() 
ggp2_alluvial_stratum
# alluvial legend.position = "bottom" ----
ggp2_alluvial_stratum + 
  labs_alluvial + 
  theme(legend.position = "bottom")


library(ggalluvial)
data(majors)

majors$curriculum <- as.factor(majors$curriculum)
glimpse(majors)
majors |> count(student)
ggplot(majors,
       aes(x = semester, stratum = curriculum, alluvium = student,
           fill = curriculum, label = curriculum)) +
  scale_fill_brewer(type = "qual", palette = "Set2") +
  geom_flow(stat = "alluvium", lode.guidance = "frontback",
            color = "darkgray") +
  geom_stratum() +
  theme(legend.position = "bottom") +
  ggtitle("student curricula across several semesters")