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

# options ----
options(scipen = 9999999)


# ggplot2 theme ----
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 18))
# funs ----
ds538 <- readr::read_rds("data/ds538.rds")
# movies_data ----
movies_data <- readr::read_rds("data/movies_data.rds")
# penguins ----
penguins <- palmerpenguins::penguins
# movies ----
movies <- ggplot2movies::movies

# OVERLAPPING HISTOGRAM -------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_ovrlp_hist <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)", 
  fill = "Species")
ggp2_ovrlp_hist <- ggplot(data = penguins,
     aes(x = flipper_length_mm, 
         fill = species)) + 
     geom_histogram(alpha = 2/3) 
## GRAPH ----
ggp2_ovrlp_hist + 
  labs_ovrlp_hist

# OVERLAPPING FREQUENCY POLYGONS --------------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_ovrlp_freq_poly <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)",
  color = "Species")
ggp2_ovrlp_freq_poly <- ggplot(data = penguins, 
       aes(x = flipper_length_mm,
           group = species)) + 
  geom_freqpoly(
    aes(color = species))
## GRAPH ----
ggp2_ovrlp_freq_poly + 
  labs_ovrlp_freq_poly

# OVERLAPPING DOT-PLOTS ------------------

## DATA ----
peng_dotplot <- filter(penguins, !is.na(sex))
glimpse(peng_dotplot)

## CODE ----
labs_ovrlp_dotplot <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)",
  fill = "Species")
ggp2_ovrlp_dotplot <- ggplot(data = peng_dotplot, 
    aes(x = flipper_length_mm,
        fill = factor(species))) +
  geom_dotplot(
    method = "histodot",
    binwidth = 1,
    binpositions = "all")

## GRAPH ----
ggp2_ovrlp_dotplot + 
  labs_ovrlp_dotplot

# BEE-SWARM PLOTS ----------------

## DATA ----
penguins |> glimpse()
## CODE ----
labs_beeswarm <- labs(
  title = "Adult Foraging Penguins",
  x = "Penguin Species",
  y = "Body mass (grams)")
ggp2_beeswarm <- ggplot(data = penguins, 
       aes(x = species, 
           y = body_mass_g, 
           color = species)) + 
  ggbeeswarm::geom_beeswarm(
      alpha = 2/3, 
    show.legend = FALSE) 
## GRAPH ----
ggp2_beeswarm + 
  labs_beeswarm

# OVERLAPPING (OR STACKED) DENSITY PLOTS -----------

## DATA ----
peng_density <- filter(penguins, !is.na(sex))
glimpse(peng_density)
## CODE ----
labs_ovrlp_density <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)",
  fill = "Penguin sex")
ggp2_ovrlp_density <- ggplot(data = peng_density, 
       aes(x = flipper_length_mm, 
           fill = sex)) +
      geom_density(alpha = 1/3) 
## GRAPH ----
ggp2_ovrlp_density + 
  labs_ovrlp_density

# STACKED DENSITY PLOTS -------------

## DATA ----
peng_density <- filter(penguins, !is.na(sex))
glimpse(peng_density)
## CODE ----
labs_stack_density <- labs(
  title = "Adult foraging penguins",
  x = "Flipper length (millimeters)", 
  fill = "Sex")
ggp2_stack_density <- ggplot(data = peng_density, 
       aes(x = flipper_length_mm, 
           after_stat(count),
           fill = sex)) +
      geom_density(position = "stack", 
                   alpha = 1/3) 
## GRAPH ----
ggp2_stack_density + 
  labs_stack_density

# RIDGELINE PLOTS ------------------

## DATA ----
peng_ridges <- filter(penguins, !is.na(island))
glimpse(peng_ridges)
## CODE ----
labs_ridges <- labs(
  title = "Adult foraging penguins",
  x = "Bill length (millimeters)",
  y = "Island", fill = "Island")
ggp2_ridges <- ggplot(data = peng_ridges,
       aes(x = bill_length_mm, 
           y = island, 
        fill = island)) +
  ggridges::geom_density_ridges(alpha = 2/3) 
## GRAPH ----
ggp2_ridges + 
  labs_ridges

# GROUPED BOX-PLOTS  ----------------

## DATA ----
glimpse(movies_data)
## CODE ----
labs_boxplots <- labs(
  title = "IMDB MPAA Movie Ratings vs. Length",
  x = "MPAA", fill = "MPAA", y = "Length")
ggp2_boxplots <- ggplot(data = movies_data, 
           aes(x = mpaa, 
               y = length,
               fill = mpaa)) +
        geom_boxplot(alpha = 2/3)
## GRAPH ----
ggp2_boxplots + 
  labs_boxplots

## DATA ----
peng_box <- filter(penguins, !is.na(island))
## CODE ----
labs_grp_boxplots <- labs(
  title = "Adult foraging penguins", 
  subtitle = "Palmer Archipelago, Antarctica",
  x = "Island",
  y = "Bill length (millimeters)")
ggp2_grp_boxplots <- ggplot(data = peng_box,
       aes(x = island, 
           y = bill_length_mm, 
        fill = island)) +
  geom_boxplot(alpha = 2/3) 
## GRAPH ----
ggp2_grp_boxplots + 
  labs_grp_boxplots



# GROUPED VIOLIN PLOTS ---------
## DATA ----
glimpse(movies_data)
## CODE ----
labs_violins <- labs(
  title = "IMDB MPAA Movie Ratings vs. Length",
  x = "MPAA", fill = "MPAA", y = "Length")
ggp2_violins <- ggplot(data = movies_data, 
           aes(x = mpaa, 
               y = length,
               fill = mpaa)) +
        geom_violin(alpha = 2/3)
## GRAPH ----
ggp2_violins + 
  labs_violins

## DATA ----
peng_violin <- filter(penguins, !is.na(island))
glimpse(peng_violin)
## CODE ----
labs_grp_violin <- labs(
  title = "Adult foraging penguins", 
  subtitle = "Palmer Archipelago, Antarctica",
  x = "Island", fill = "Island",
  y = "Bill length (millimeters)")
ggp2_grp_violin <- ggplot(data = peng_violin,
       aes(x = island, 
           y = bill_length_mm, 
        fill = island)) +
  geom_violin(alpha = 2/3) 
## GRAPH ----
ggp2_grp_violin + 
  labs_grp_violin


# RAINCLOUD PLOTS ---------------------------------------------------------
# remotes::install_github('jorvlan/raincloudplots')
library(raincloudplots)
library(ggbeeswarm)
library(ggforce)
library(ggdist)
library(gghalves)
peng_raincloud <- palmerpenguins::penguins
raincloud_data <- peng_raincloud  |> 
    group_by(species) |> 
    mutate(bill_ratio = bill_length_mm / bill_depth_mm) |> 
    filter(!is.na(bill_ratio)) |> 
    rename(value = bill_ratio, 
        group = species)

## Box ---------------------------------------------------------------------
ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_boxplot(fill = "grey92")

## Box + jitter -------------------------------------------------------------
ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_boxplot(fill = "grey92") +
  ## use either geom_point() or geom_jitter()
  geom_point(
    ## draw bigger points
    size = 2,
    ## add some transparency
    alpha = .3,
    ## add some jittering
    position = position_jitter(
      ## control randomness and range of jitter
      seed = 1, width = .2
    )
  )


## ggbeeswarm::geom_quasirandom --------------------------------------------

ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_boxplot(fill = "grey92") + 
  ggbeeswarm::geom_quasirandom(
    ## draw bigger points
    size = 2,
    ## add some transparency
    alpha = .3,
    width = 0.1
  )


## ggforce::geom_sina ----------------------
ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_boxplot(fill = "grey92") + 
  ggforce::geom_sina(
    ## draw bigger points
    size = 2,
    ## add some transparency
    alpha = .3,
    maxwidth = 0.26
  )


## Violin ---------------------------------------------------------------


ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_violin(fill = "grey92")


## scale = "count", bandwidth ----------------------------------------------

ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_violin(fill = "grey92", scale = "count", bw = 0.01)

ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_violin(fill = "grey92", scale = "count", bw = 0.03)

ggplot(raincloud_data, aes(x = group, y = value)) +
  geom_violin(fill = "grey92", scale = "count", bw = 1)



## ggdist::stat_halfeye ----------------------------------------------------
ggp2_stat_halfeye <- ggplot(raincloud_data,
    aes(x = group, y = value)) + 
  ## add half-violin from {ggdist} package
  ggdist::stat_halfeye(
    ## custom bandwidth
    adjust = .5, 
    ## adjust height
    width = .6, 
    ## move geom to the right
    justification = -.2, 
    ## remove slab interval
    .width = 0, 
    size = 0.1,
    point_colour = NA
  ) 

ggp2_stat_halfeye + 
    coord_flip()

## ggdist::stat_halfeye + geom_boxplot() -----------------------------------
ggp2_stat_halfeye_box <- ggp2_stat_halfeye + 
  geom_boxplot(
    width = .12,
    ## remove outliers
    outlier.color = NA ## `outlier.shape = NA` works as well
  )

ggp2_stat_halfeye_box 

ggp2_stat_halfeye_box + coord_flip()


## ggdist::stat_dots -------------------------------------------------------
ggp2_stat_halfeye_box + 
  ## add dot plots from {ggdist} package
  ggdist::stat_dots(
    dotsize = 0.05,
    ## orientation to the left
    side = "left",
    ## move geom to the left
    justification = 1.1,
    ## adjust grouping (binning) of observations
    binwidth = .12
  ) +
  ## remove white space on the left
  coord_cartesian(xlim = c(1.2, NA)) + coord_flip()


## gghalves::geom_half_point -----------------------------------------------
ggp2_stat_halfeye_box + 
  ## add justified jitter from the {gghalves} package
  gghalves::geom_half_point(
    ## draw jitter on the left
    side = "l", 
    ## control range of jitter
    range_scale = .3, 
    ## add some transparency
    alpha = .3
  ) +
  coord_cartesian(xlim = c(1.2, NA), clip = "off") + coord_flip()

## geom_point(position = position_jitter()) -------
ggp2_stat_halfeye_box +
  geom_point(
    size = 1.3,
    alpha = .3,
    position = position_jitter(
      seed = 321, width = .03,
    )
  ) + 
  coord_cartesian(xlim = c(1.2, NA), clip = "off") + coord_flip()

## horizontal lines instead of points -------
ggp2_stat_halfeye_box +
geom_point(
    ## draw horizontal lines instead of points
    shape = 95,
    size = 10,
    alpha = .2
  ) +
  coord_cartesian(xlim = c(1.2, NA), clip = "off") 

