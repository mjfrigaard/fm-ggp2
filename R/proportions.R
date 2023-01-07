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

# options ----
options(scipen = 9999999)


# ggplot2 theme ----
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 18))
# funs ----
ds538 <- readr::read_rds("slides/data/ds538.rds")
# movies_data ----
movies_data <- readr::read_rds("slides/data/movies_data.rds")
# penguins ----
penguins <- palmerpenguins::penguins
# movies ----
movies <- ggplot2movies::movies


# PIE-CHARTS --------------------------------------------------------------

movie_pie <- movies_data |> 
  dplyr::group_by(mpaa) |> 
  summarise(cnt = n()) |> 
  mutate(
    perc = round(cnt / sum(cnt), 3),
    mpaa = factor(mpaa, 
          levels = c("PG", "PG-13", "R")))

labs <- paste0(movie_pie$mpaa, " (", 
               (100*movie_pie$perc), "%)")
labs_pie <- labs(
  title = "Percent MPAA ratings for IMDB movies",
  x = "Percent MPAA rating")

ggp2_pie <- ggpubr::ggpie(movie_pie, 
          x = "perc", label = labs, 
          lab.pos = "in", lab.font = "white",
          fill = "mpaa", color = "white") + 
    theme(legend.position = "none")  
    
ggp2_pie + 
  labs_pie


# DIVERGING BAR GRAPHS ----------------------------------------------------

# If you have two proportions that contain positive and negative values, 
# consider using diverging bars with geom_bar()

## DATA --------------------------------------------------------------------
## Create trump_approval_diverg from the 
## fivethirtyeight::trump_approval_trend dataset.

fivethirtyeight::trump_approval_trend |> 
  dplyr::filter(subgroup == "All polls") |> 
  dplyr::mutate(
    month = lubridate::month(modeldate,
                label = TRUE, abbr = TRUE),
    approve = approve_estimate*0.01,
    disapprove = disapprove_estimate*0.01,
    disapprove = disapprove * -1) |> 
  tidyr::pivot_longer(cols = c(approve, disapprove), 
    names_to = "poll", values_to = "values") |> 
  dplyr::group_by(month, poll) |> 
    dplyr::summarise(
      month_avg = mean(values, na.rm = TRUE)
    ) |> 
  dplyr::ungroup() -> trump_approval_diverg
glimpse(trump_approval_diverg)

## CODE --------------------------------------------------------------------

labs_geom_bar_diverg <- labs(
  title = "Trump Approval Ratings",
  subtitle = "From 'How Popular is Donald Trump'",
  x = "Month",
  y = "Monthly average percent",
  fill = "Estimate")
ggp2_bars_diverg <- ggplot(
  data = trump_approval_diverg, 
    aes(x = month, y = month_avg)) +
  geom_bar(aes(fill = poll),
    stat = "identity", width = .5) + 
  scale_y_continuous(limits = c(-1, 1), 
    labels = scales::percent) 



## GRAPH --------------------------------------------------------------------
ggp2_bars_diverg + 
  labs_geom_bar_diverg

# DIVERGING BAR GRAPHS (VERTICAL) -------

labs_geom_bar_diverg_vert <- labs(
  title = "Trump Approval Ratings",
  subtitle = "From 'How Popular is Donald Trump'",
  x = "Monthly average percent",
  y = "Month",
  fill = "Estimate")
ggp2_bar_diverg_vert <- ggplot(
  data = trump_approval_diverg,
      aes(x = month_avg, y =  month)) +
  geom_bar(
      aes(fill = poll), 
        stat = "identity", width = .5) + 
  scale_x_continuous(limits = c(-1, 1), 
        labels = scales::percent)

ggp2_bar_diverg_vert + 
  labs_geom_bar_diverg_vert
