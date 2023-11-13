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
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 16))
# funs ----
ds538 <- readr::read_rds("data/ds538.rds")
# movies_data ----
movies_data <- readr::read_rds("data/movies_data.rds")
# penguins ----
penguins <- palmerpenguins::penguins
# movies ----
movies <- ggplot2movies::movies


# BAR-GRAPHS --------------------------------------------------------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_bar <- labs(
  title = "IMDB movie information/user ratings",
  x = "MPAA rating", y = "Count", 
  fill = "MPAA")
ggp2_bar <- ggplot(data = movies_data, 
       aes(x = mpaa)) + 
    geom_bar(aes(fill = mpaa)) 
## GRAPH ----
ggp2_bar + 
  labs_bar


# HISTOGRAMS --------------------------------------------------------------

## DATA ----
penguins |> glimpse()
## CODE ----
# Create labels with `labs()` 
labs_histogram <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)")
# create plot 
ggp2_hist <- ggplot(data = penguins,
     aes(x = flipper_length_mm)) + 
     geom_histogram()

## GRAPH ----
ggp2_hist + 
  labs_histogram


# FREQUENCY POLYGONS ------------------------------------------------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_freqpoly <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)")
ggp2_freqpoly <- ggplot(data = penguins,
      aes(x = flipper_length_mm)) + 
    geom_freqpoly()
## GRAPH ----
ggp2_freqpoly + 
  labs_freqpoly



# DOT-PLOTS ---------------------------------------------------------------

## DATA ----
penguins |> glimpse()

## CODE ----
labs_dotplot <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)")
ggp2_dotplot <- ggplot(data = penguins,
      aes(x = flipper_length_mm)) + 
    geom_dotplot(dotsize = 0.5) 

## GRAPH ----
ggp2_dotplot + 
  labs_dotplot

# DENSITY PLOTS -----------------------------------------------------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_density <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)")
ggp2_density <- ggplot(data = penguins, 
        aes(x = flipper_length_mm)) + 
      geom_density() 
## GRAPH ----
ggp2_density +
  labs_density

# VIOLIN PLOTS ------------------------------------------------------------

## DATA ----
penguins <- palmerpenguins::penguins
glimpse(penguins)
## CODE ----
labs_violin <- labs(
  title = "Adult foraging penguins",
  subtitle = "Distribution of flipper length",
  x = "",
  y = "Flipper length (millimeters)")
ggp2_violin <- ggplot(data = penguins,
       aes(x = '', 
           y = flipper_length_mm)) +
       geom_violin() 
## GRAPH ----
ggp2_violin + 
  labs_violin

# BOX-PLOTS --------------------------------------------------------
  # group_by(species) |> 
  # mutate(bill_ratio = bill_length_mm / bill_depth_mm) |>  
  # filter(!is.na(bill_ratio))
## DATA ----
penguins <- palmerpenguins::penguins 
glimpse(penguins)


## CODE ----
labs_boxplot <- labs(
  title = "Adult foraging penguins",
  subtitle = "Distribution of flipper length",
  x = NULL,
  y = "Flipper length (millimeters)")
ggp2_boxplot <- ggplot(data = penguins,
           aes(x = "", 
               y = flipper_length_mm)) +
        geom_boxplot() 

## GRAPH ----
ggp2_boxplot + 
  labs_boxplot


movies_box <- ggplot2movies::movies |> 
                dplyr::filter(year > 2000 & 
                                mpaa != "" & 
                                    !is.na(budget))
glimpse(movies_box)

labs_boxplot <- labs(
  title = "IMDB Movie information and user ratings",
  y = "Movie length (min)", x = "")
ggp2_boxplot <- ggplot(data = movies_box, 
           aes(x = " ", 
               y = length)) +
        geom_boxplot() 

ggp2_boxplot + 
  labs_boxplot

ggp2_pnts <- ggplot(data = movies_box, 
           aes(x = " ", 
               y = length)) +
        geom_point() + 
    labs(y = "Movie length (min)", x = "") + 
    theme_void() + 
    theme(axis.text.y = element_text(size = 12),
          axis.title.y = element_text(size = 14, 
              face = "bold", 
              angle = 90))
ggp2_freqpoly <- ggplot(data = movies_box, 
           aes(x = length)) + 
        geom_freqpoly() + 
    coord_flip() + 
    labs(y = "", x = "") + 
    theme_void() 
ggp2_hist <- ggplot(data = movies_box, 
           aes(x = length)) +
        geom_histogram() + 
    coord_flip() +
    labs(y = "", x = "") + 
    theme_void() 
ggp2_density <- ggplot(data = movies_box, 
           aes(x = length)) +
        geom_density() + 
    coord_flip() +
    labs(y = "", x = "") + 
    theme_void() 
ggp2_box <- ggplot(data = movies_box, 
           aes(x = " ", 
               y = length)) +
        geom_boxplot(show.legend = FALSE) + 
    labs(x = "", y = "") + 
    theme_void() + 
   theme(axis.text.y = element_text(size = 12)) + 
    scale_y_continuous(position = "right")

ggp2_pnts + ggp2_freqpoly + 
    ggp2_hist + ggp2_density + ggp2_box + 
    patchwork::plot_layout(ncol = 5) + 
    patchwork::plot_annotation(title = "IMDB Movie information and user ratings")
