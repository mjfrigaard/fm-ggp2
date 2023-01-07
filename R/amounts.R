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
    base_size = 16))

# penguins ----
penguins <- palmerpenguins::penguins
# movies ----
movies <- ggplot2movies::movies



# BASIC BAR-GRAPHS -----
labs_bar <- labs(
  title = "Adult foraging penguins",
  subtitle = "Distribution of flipper length",
  x = "Species", y = "Count", 
  fill = "Species")
ggp2_bar <- ggplot(data = penguins_bar,
       aes(x = species)) +
    geom_bar(aes(fill = species), 
        show.legend = FALSE)
ggp2_bar +
  labs_bar
# Stat count
ggp2_geom_bar <- ggplot(data = penguins_bar,
       aes(x = species)) +
    geom_bar(aes(fill = species), 
        stat = "count") + 
    labs(title = "geom_bar(stat = 'count')")
ggp2_geom_bar
ggp2_stat_count <- ggplot(data = penguins_bar,
       aes(x = species)) +
    stat_count(aes(fill = species), 
        geom = "bar") + 
    labs(title = "stat_count(geom = 'bar')")
ggp2_stat_count
# geom_col() bars
penguins_bar |> 
    # create column of counts 
    dplyr::count(species, name = "count") |> 
    # map into x and y
    ggplot(mapping = aes(x = species, y = count)) +
    geom_col(aes(fill = species), 
        show.legend = FALSE) + 
    labs_bar +
    labs(caption = "*created with geom_col()")

# GROUPED BAR-GRAPHS -----
peng_grp_col <- palmerpenguins::penguins |> 
    dplyr::select(body_mass_g, island) |> 
    tidyr::drop_na() |> 
    # divide the mass value by 1000
    dplyr::mutate(
        body_mass_kg = body_mass_g / 1000
    )
# Create labels with `labs()`
labs_grp_col <- labs(
    title = "Total Penguin Mass",
    subtitle = "How many kilograms of penguin per Island?",
    x = "Island",
    y = "Total Penguin Body Mass (kg)")
ggp2_grp_col <- ggplot(data = peng_grp_col,
    aes(x = island,
        y = body_mass_kg)) +
    geom_col(aes(fill = island), 
        show.legend = FALSE)  
ggp2_grp_col + 
    labs_grp_col

# total (sum) table
movies_sum_budget <- movies_data |>
  group_by(mpaa) |>
  summarise(tot_bud = sum(budget, na.rm = TRUE),
    tot_bud = scales::dollar(tot_bud)) |>
  ungroup() |>
  select(MPAA = mpaa,
    `Total budget` = tot_bud)
movies_sum_budget

# GROUPED COLUMN-GRAPHS 2 --------------------
# average bar graph data
peng_sum_col <- palmerpenguins::penguins |>
    dplyr::select(body_mass_g, island) |> 
    tidyr::drop_na() |> 
    dplyr::group_by(island) |>
    dplyr::summarise(
        avg_body_mass_g = mean(body_mass_g)
        ) |>
    dplyr::ungroup()
# Create labels with `labs()`
labs_sum_col <- labs(
    title = "Average Penguin Mass",
    subtitle = "What's the average mass of penguins per Island?",
    x = "Island",
    y = "Average penguin body mass (g)")
ggp2_sum_col <- ggplot(data = peng_sum_col,
              aes(x = island, 
                  y = avg_body_mass_g)) + 
        geom_col(aes(fill = island),
            show.legend = FALSE)
ggp2_sum_col + 
    labs_sum_col

# OVERLAPPING BAR GRAPHS --------------------
penguins_ovrlp <- filter(penguins,
                      !is.na(species) & 
                            island == "Dream")
glimpse(penguins_ovrlp)

labs_bar_ovrlp <- labs(
  title = "Adult foraging penguins",
  subtitle = "Penguins on Dream island",
  x = "Flipper length (millimeters)",
  y = "Count",
  fill = "Species")
ggp2_bar_ovrlp <- ggplot(data = penguins_ovrlp,
          aes(x = flipper_length_mm, fill = species)) +
                geom_bar() 
ggp2_bar_ovrlp + 
  labs_bar_ovrlp

## DODGE BAR GRAPHS --------------------
labs_bar_dodge <- labs(
  title = "Adult foraging penguins",
  subtitle = "Penguins on Dream island",
  x = "Flipper length (millimeters)",
  y = "Count",
  fill = "Species",
  caption = "position = 'dodge'")
ggp2_bar_dodge <- ggplot(data = penguins_ovrlp,
                    aes(x = flipper_length_mm, 
                        group = species, 
                        fill = species)) +
                    geom_bar(
                        position = "dodge")
ggp2_bar_dodge +
  labs_bar_dodge

## DODGE2 BAR GRAPHS --------------------
# dodge2 preserves the total width of the elements.
labs_bar_dodge2 <- labs(
  title = "Adult foraging penguins",
  subtitle = "Penguins on Dream island",
  x = "Flipper length (millimeters)",
  y = "Count",
  fill = "Species",
  caption = "position = 'dodge2'")
ggp2_bar_dodge2 <- ggplot(data = penguins_ovrlp,
                    aes(x = flipper_length_mm, 
                        group = species, 
                        fill = species)) +
                    geom_bar(
                        position = "dodge2")
ggp2_bar_dodge2 +
  labs_bar_dodge2

# WAFFLE CHART ------------------------
devtools::install_github("liamgilbey/ggwaffle")
library(ggwaffle)
penguins <- palmerpenguins::penguins
penguins <- dplyr::mutate(penguins, 
              species = as.character(species))
waffle_peng <- ggwaffle::waffle_iron(penguins,
                      ggwaffle::aes_d(group = species))

glimpse(waffle_peng)

labs_waffle <- labs(
  title = "Waffle chart of palmer penguin species",
  x = "", y = "", fill = "Species")
ggp2_waffle <- ggplot(data = waffle_peng, 
       aes(x = x, 
           y = y, 
           fill = group)) + 
  ggwaffle::geom_waffle() 
ggp2_waffle + 
  labs_waffle +
  ggwaffle::theme_waffle()

# HEATMAPS ------------------------------
glimpse(movies_data)

heatmap_ross <- fivethirtyeight::bob_ross |>
  tidyr::pivot_longer(-c(episode, season,
    episode_num, title),
    names_to = "object",
    values_to = "present") |>
  dplyr::mutate(present = as.logical(present),
    object = stringr::str_replace_all(object, "_", " ")) |>
  dplyr::arrange(episode, object) |>
  dplyr::filter(
    object %in% c('conifer', 'trees', 'tree',
      'snow', 'palm trees', 'grass',
      'flowers', 'cactus', 'bushes',
      'cirrus', 'cumulus', 'deciduous',
      'clouds', 'fog')) |>
  dplyr::group_by(season, object) |>
  dplyr::summarise(count = sum(present)) |>
  dplyr::ungroup()

# create labels
labs_heatmap_raster <- labs(title = "Bob Ross' plants & clouds",
  x = "Season",
  y = "Plant/Cloud Object",
  fill = "Occurances")
# create plot
ggp2_heatmap_raster <- ggplot(data = heatmap_ross,
  aes(x = season,
    y = object,
    fill = count)) +
  geom_raster()

ggp2_heatmap_raster +
  theme_ggp2g(base_size = 12) +
  labs_heatmap_raster

# create labels
labs_heatmap_tile <- labs(
    title = "Bob Ross' plants & clouds",
    x = "Season",
    y = "Plant/Cloud Object",
    fill = "Occurances")
# create plot
ggp2_heatmap_tile <- ggplot(data = heatmap_ross,
                        aes(x = season,
                            y = object,
                         fill = count)) +
                        geom_tile()

ggp2_heatmap_tile +
  theme_ggp2g(base_size = 12) +
  labs_heatmap_tile


# CLEVELAND DOT PLOTS --------------------------
source("R/theme_ggp2g.R")
# set theme
ggplot2::theme_set(theme_ggp2g(
    base_size = 16))

peng_clev_dots <- palmerpenguins::penguins |>
    dplyr::filter(!is.na(sex) & !is.na(flipper_length_mm)) |>
    dplyr::group_by(sex, island) |>
    dplyr::summarise(
        med_flip_length_mm = median(flipper_length_mm)
        ) |>
    dplyr::ungroup()
glimpse(peng_clev_dots)

labs_clev_dots <- labs(
    title = "Flipper Length Differences",
    subtitle = "Male and female penguins",
    x = "Median Flipper Length",
    y = "Island",
    color = "Sex"
)

ggp2_clev_dots <- ggplot(data = peng_clev_dots,
    mapping = aes(x = med_flip_length_mm, y = fct_rev(island))) +
        geom_line(aes(group = island), linewidth = 0.75) + 
        geom_point(aes(color = sex), size = 2.25) 

ggp2_clev_dots + 
    labs_clev_dots

peng_clev_dots2 <- palmerpenguins::penguins |>
    dplyr::filter(!is.na(sex) & !is.na(flipper_length_mm)) |>
    dplyr::group_by(sex, island) |>
    dplyr::summarise(
        `Median Flipper Length` = median(flipper_length_mm),
        `Median Bill Length` = median(bill_length_mm),
        `Median Bill Depth` = median(bill_depth_mm)
        ) |>
    dplyr::ungroup() |> 
    tidyr::pivot_longer(cols = starts_with("Med"), 
        names_to = "median_measure", 
        values_to = "median_value") |> 
    dplyr::mutate(median_measure = factor(median_measure))
glimpse(peng_clev_dots2)
        
labs_clev_dots2 <- labs(
    title = "Penguin Measurements Differences",
    subtitle = "Male and female penguins",
    x = "Median Flipper/Bill Length & Bill Depth (mm)",
    y = "Island",
    color = "Sex"
)

ggp2_clev_dots2 <- ggplot(data = peng_clev_dots2,
        mapping = aes(x = median_value, y = fct_rev(island))) +
        geom_line(aes(group = island), linewidth = 0.75) +
    geom_point(aes(color = sex), size = 2.25) +
    facet_wrap(. ~ median_measure, 
        shrink = TRUE, scales = "free_x")

ggp2_clev_dots2 +
    labs_clev_dots2
