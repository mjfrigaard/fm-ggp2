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
library(patchwork)
options(scipen = 9999999)
# ggplot2 theme ----
# ggplot2::theme_set(
#     ggplot2::theme_minimal(base_size = 16))
source("R/theme_ggp2g.R")
# funs ----
ds538 <- readr::read_rds("data/ds538.rds")
# movies_data ----
movies_data <- readr::read_rds("data/movies_data.rds")
# penguins ----
penguins <- palmerpenguins::penguins
# movies ----
movies <- ggplot2movies::movies


# SCATTER ----------------------------------------------------
penguins <- palmerpenguins::penguins
labs_scatter <- labs(title = "Bill Length vs. Flipper Length",
                      x = "Bill Length (mm)", 
                      y = "Flipper length (mm)")

ggp2_scatter <- penguins |> 
  ggplot(aes(x = bill_length_mm, y = flipper_length_mm)) + 
  geom_point() 

ggp2_scatter + 
  labs_scatter


# GROUPED SCATTER -----------------------------------------------
penguins <- palmerpenguins::penguins
labs_grp_scatter <- labs(title = "Bill Length vs. Flipper Length",
                      x = "Bill Length (mm)", 
                      y = "Flipper length (mm)", 
                      color = "Penguin species")

ggp2_grp_scatter <- penguins |> 
  ggplot(aes(x = bill_length_mm, 
             y = flipper_length_mm)) + 
  geom_point(aes(color = species)) 

ggp2_grp_scatter + 
  labs_grp_scatter

# BUBBLE GRAPH ----------------------------------------------------
penguins <- palmerpenguins::penguins
labs_bubble <- labs(title = "Bill Length vs. Flipper Length",
                      x = "Bill Length (mm)",
                      y = "Flipper length (mm)", 
                      size = "Body Mass (g)")

ggp2_bubble <- penguins |> 
  ggplot(aes(x = bill_length_mm, 
             y = flipper_length_mm)) + 
  geom_point(aes(size = body_mass_g), 
             alpha = 1/3) + 
  scale_size(
    range = c(.1, 10), 
    name = "Body Mass (g)")

ggp2_bubble + 
  labs_bubble

# GROUPED BUBBLE GRAPH -------------------------------------
labs_grp_bubble <- labs(
    title = "Bill Length vs. Flipper Length",
    x = "Bill Length (mm)", 
    y = "Flipper length (mm)", 
    size = "Body Mass (g)")

ggp2_grp_bubble <- penguins |> 
  ggplot(aes(
    x = bill_length_mm, 
    y = flipper_length_mm)) + 
  geom_point(
    aes(size = body_mass_g, 
        fill = species), 
          alpha = 2/3,
          shape = 21, 
          color = "black") + 
  scale_size(range = c(.04, 8), 
             name = "Body Mass (g)") + 
  labs_grp_bubble

ggp2_grp_bubble + 
  labs_grp_bubble

# ALLUVIAL WIDE --------------------------------------------------
# convert to wide
peng_wide <- penguins |> 
  tidyr::drop_na() |> 
  count(year, island, sex, species) |> 
  dplyr::mutate(year = factor(year)) |> 
  rename(freq = n)

# labels
labs_alluvial <- ggtitle(label = "Palmer Penguins", 
    subtitle = "Stratified by year, island and species")
labs_alluvial_y <- ylab("Frequency") 
labs_alluvial_fill <- labs(fill = "Sex")

# plot with wide data
ggp2_alluvial_w <- ggplot(data = peng_wide,
  aes(axis1 = year,
      axis2 = island,
      axis3 = species,
      y = freq)) +
  scale_x_discrete(
    limits = c("Year", "Island", "Species"),
    expand = c(0.1, .07)) +
  geom_alluvium(aes(fill = sex)) +
  geom_stratum() +
  geom_text(stat = "stratum", 
    aes(label = after_stat(stratum)))

ggp2_alluvial_w + 
  labs_alluvial + 
  labs_alluvial_y + 
  labs_alluvial_fill

# ALLUVIAL LODES --------------------------------------------------
peng_lodes <- penguins |> 
  select(Year = year, Island = island, 
         Species = species, Sex = sex) |> 
  tidyr::drop_na() |> 
  dplyr::count(Year, Island, Species, Sex) |> 
  dplyr::mutate(Year = factor(Year)) |> 
  dplyr::rename(Freqency = n) |> 
  ggalluvial::to_lodes_form(key = "Measure", axes = 1:3)  
  
ggp2_alluvial_lf <- ggplot(data = peng_lodes,
  aes(x = Measure,
      y = Freqency,
      stratum = stratum,
      alluvium = alluvium,
      label = stratum)) +
  ggalluvial::geom_alluvium(aes(fill = Sex)) +
  ggalluvial::geom_stratum() +
  geom_stratum(width = 0.45) +
  geom_text(stat = "stratum")

ggp2_alluvial_lf + 
  labs_alluvial


# BUMP CHART --------------------------------------------------

# devtools::install_github("davidsjoberg/ggbump")
# install.packages("pacman")
# pacman::p_load(padr, hablar, jsonlite, ggbump, 
#                httr, xml2, lubridate, tidyverse)
# library(ggbump)
# pacman::p_load(tidyverse, cowplot, wesanderson)
# df <- tibble(
#     country = c("India", "India", "India",
#       "Sweden", "Sweden", "Sweden",
#       "Germany", "Germany", "Germany",
#       "Finland", "Finland", "Finland"),
#     year = c(2011, 2012, 2013, 2011, 2012,
#       2013, 2011, 2012, 2013, 2011, 2012, 2013),
#     value = c(492, 246, 246, 369, 123, 
#       492, 246, 369, 123, 123, 492, 369))

fivethirtyeight::tv_hurricanes |> 
  filter(date > lubridate::as_date("2017-09-15")) |> 
  pivot_longer(cols = -date, names_to = 'hurricane', 
    values_to = 'value') |> 
  group_by(date) |>
  mutate(rank = rank(value, ties.method = "random")) |> 
  ungroup() -> tidy_hurricanes

labs_bump <- labs(title = "TV News Hurricane Mentions",   
  subtitle = "Between Sep 15-25th, 2017", 
  x = "Date", y = "Rank", 
  color = "Hurricanes")

ggp2_bump <- ggplot(tidy_hurricanes, 
    aes(date, rank, color = hurricane)) +
    ggbump::geom_bump()

ggp2_bump + 
  labs_bump


# PARALLEL SETS -----------------------------------------------------
remotes::install_github("thomasp85/ggforce")
library(ggforce)
ggplot2::theme_set(
    ggplot2::theme_void(base_size = 16) + 
        theme(axis.title.y = element_text(size = 12), 
              axis.text.y = element_text(size = 10),
              axis.text.x = element_text(size = 10)))
peng_wide <- palmerpenguins::penguins |> 
  drop_na() |> 
  count(island, species, sex) |> 
  rename(value = n)
para_set_peng <- ggforce::gather_set_data(
                            data = peng_wide, 
                            x = 1:3)
labs_psets <- labs(
        title = "Categories of Palmer Penguins", 
        y = "Count", fill = "Sex")

ggp2_psets <- ggplot(data = para_set_peng, 
    mapping = aes(x = x, 
        id = id, 
        split = y, 
        value = value)) +
  geom_parallel_sets(aes(fill = sex), 
        alpha = 0.3, 
        axis.width = 0.07) 

ggp2_psets_axes <- ggp2_psets +
  geom_parallel_sets_axes(
        axis.width = 0.07) 

ggp2_psets_labs <- ggp2_psets_axes +
  geom_parallel_sets_labels(
        size = 2.0, 
        color = '#ffffff') +
  scale_x_continuous(
        breaks = c(1, 2, 3), 
        labels = c("Island", "Species", "Sex")) +
  theme(legend.position = "bottom", 
        axis.title.x = element_blank())

ggp2_psets_labs +
    labs_psets
## labels ----
ggp2_psets_axes + 
  geom_parallel_sets_labels(
      size = 2.0, 
      colour = 'black',
      angle = 0, 
      nudge_x = 0.1, 
      hjust = 0) + 
  scale_x_continuous(
        limits = c(0.9, 3.2),
        breaks = c(1, 2, 3), 
        labels = c("Island", "Species", "Sex")) + 
  theme(legend.position = "bottom", 
        axis.title.x = element_blank()) + 
    labs_psets



# SLOPE GRAPHS ------------------------------------------------------
library(palmerpenguins)

# we need data with two time-points, summarizing some value across groups
peng_slope <- palmerpenguins::penguins |>
    dplyr::filter(year < 2009) |>
    dplyr::group_by(year, island) |>
    dplyr::summarise(across(
        .cols = contains("mm"), 
        .fns = mean, 
            na.rm = TRUE, 
        .names = "avg_{.col}")) |>
    dplyr::ungroup()
glimpse(peng_slope)

labs_slope <- labs(
        title = "Changes in Bill Depth of Palmer Penguins", 
        subtitle = "Years 2007 & 2008",
        x = "Year", y = "Bill Depth (mm)", 
        color = "Island")

ggp2_slope <- ggplot(data = peng_slope, 
    mapping = aes(x = year,
                  y = avg_bill_depth_mm, 
              group = island)) +
  geom_line(aes(color = island), alpha = 1, size = 2, 
      show.legend = FALSE) +
  geom_point(aes(color = island), alpha = 1, size = 4) + 
  scale_x_continuous(breaks = c(2007, 2008), position = "top")

ggp2_slope + 
    labs_slope

# we can also use facets 
peng_grp_slope <- palmerpenguins::penguins |>
    dplyr::select(year, sex, island,
                  contains("mm")) |> 
    tidyr::drop_na() |> 
    dplyr::filter(year != 2007) |>
    dplyr::group_by(year, sex, island) |>
    dplyr::summarise(across(
        .cols = contains("mm"), 
        .fns = mean, 
            na.rm = TRUE, 
        .names = "avg_{.col}")) |>
    dplyr::ungroup()
glimpse(peng_grp_slope)

## facets ----
labs_grp_slope <- labs(
    title = "Changes in Bill Depth of Palmer Penguins", 
    subtitle = "Years 2008 & 2009",
    x = "", 
    color = "Island")

ggp2_grp_slope <- ggplot(data = peng_grp_slope, 
    mapping = aes(x = year,
                  y = avg_bill_depth_mm, 
              group = island)) +
  geom_line(aes(color = island), alpha = 1, size = 2, 
      show.legend = FALSE) +
  geom_point(aes(color = island), alpha = 1, size = 4) + 
  scale_x_continuous(breaks = c(2008, 2009), position = "top") + 
  scale_y_continuous(
    name = "Bill Depth (mm)",
    sec.axis = dup_axis(name = "Bill Depth (mm)")) + 
    facet_wrap(. ~ sex) + 
    theme(legend.position = "bottom")

ggp2_grp_slope + 
    labs_grp_slope


# DENSITY CONTOURS -------------------------------------------------
# use penguins data 
peng_dnsty_2d <- palmerpenguins::penguins |> 
    filter(!is.na(bill_length_mm) & 
            !is.na(flipper_length_mm) & 
            !is.na(species)) |> 
    mutate(species = factor(species))
glimpse(peng_dnsty_2d)

## full_code_display ---- 
# x limits
x_min <- min(peng_dnsty_2d$bill_length_mm) - 5
x_max <- max(peng_dnsty_2d$bill_length_mm) + 5
# y limits
y_min <- min(peng_dnsty_2d$flipper_length_mm) - 10
y_max <- max(peng_dnsty_2d$flipper_length_mm) + 10
labs_dnsty_2d <- labs(
  title = "Bill Length vs. Flipper Length",
  x = "Bill Length (mm)",
  y = "Flipper length (mm)"
)
ggp2_dnsty_2d_fill <- ggplot(
  data = peng_dnsty_2d,
  mapping = aes(
    x = bill_length_mm,
    fill = after_stat(level),
    y = flipper_length_mm
  )
) +
  # expand limits
  expand_limits(
    x = c(x_min, x_max),
    y = c(y_min, y_max)
  ) +
  # stat polygon
  stat_density_2d(
    geom = "polygon",
    color = "#000000",
    linewidth = 0.15
  ) +
  # gradient
  scale_fill_gradient(
    low = "#02577A",
    high = "#ffffff",
    guide = "none"
  )
ggp2_dnsty_2d_fill +
  labs_dnsty_2d

## create_graph_geom_density_2d ----
# x limits
x_min <- min(peng_dnsty_2d$bill_length_mm) - 5
x_max <- max(peng_dnsty_2d$bill_length_mm) + 5
# y limits
y_min <- min(peng_dnsty_2d$flipper_length_mm) - 10
y_max <- max(peng_dnsty_2d$flipper_length_mm) + 10

# labels
labs_dnsty_2d <- labs(
  title = "Bill Length vs. Flipper Length",
  x = "Bill Length (mm)",
  y = "Flipper length (mm)"
)

ggp2_dnsty_2d <- ggplot(
  data = peng_dnsty_2d,
  mapping = aes(
    x = bill_length_mm,
    y = flipper_length_mm
  )
) +
  # use our stored values
  expand_limits(
    x = c(x_min, x_max),
    y = c(y_min, y_max)
  ) +
  geom_density_2d()
# plot
ggp2_dnsty_2d +
  labs_dnsty_2d

## code_graph_base_layer ----
labs_sdens_2d <- labs(
  title = "Bill Length vs. Flipper Length",
  x = "Bill Length (mm)",
  y = "Flipper length (mm)",
  color = "Species"
)
# base
base_sdens_2d <- ggplot(
  data = peng_dnsty_2d,
  mapping = aes(
    x = bill_length_mm,
    y = flipper_length_mm
  )
) +
  expand_limits(
    x = c(x_min, x_max),
    y = c(y_min, y_max)
  )
base_sdens_2d +
  labs_sdens_2d

## code_graph_stat_layer ----
stat_sdens_2d <- base_sdens_2d +
  stat_density_2d(
    aes(fill = after_stat(level)),
    geom = "polygon",
    color = "#000000",
    linewidth = 0.35
  )
stat_sdens_2d +
  labs_sdens_2d

ggp1 <- stat_sdens_2d +
  labs(
    x = "Bill Length (mm)",
    y = "Flipper length (mm)"
  ) +
  theme(
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 6),
    legend.text = element_text(size = 7),
    legend.title = element_text(size = 9, face = "bold")
  )
ggp1

## code_graph_fill_layer ----
fill_sdens_2d <- stat_sdens_2d +
  scale_fill_gradient(
    low = "#ffffff",
    high = "#404040",
    guide = "legend"
  )
fill_sdens_2d +
  labs_sdens_2d

## code_graph_fill_layer_pw ----
fill_sdens_2d <- stat_sdens_2d +
  scale_fill_gradient(
    low = "#ffffff",
    high = "#404040",
    guide = "legend"
  )
# patchwork plot 2
ggp2 <- fill_sdens_2d +
  labs(
    x = "Bill Length (mm)",
    y = "Flipper length (mm)"
  ) +
  theme(
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 6),
    legend.text = element_text(size = 6),
    legend.title = element_text(size = 7, face = "bold")
  )
# patch
ggp1 + patchwork::guide_area() +
  ggp2 + patchwork::guide_area() +
  patchwork::plot_layout(ncol = 2, guides = "keep") +
  plot_annotation(
    title = "stat_density_2d() +  scale_fill_gradient()"
  )

## code_graph_points_layer ----
pnts_sdens_2d <- fill_sdens_2d +
  geom_point(aes(color = species),
    size = 2,
    alpha = 2 / 3
  )
# final
pnts_sdens_2d +
  labs_sdens_2d

### other density option ---------------------------------------
# ggp2_dnsty_2d_fill <- ggplot(data = peng_dnsty_2d,
#     mapping = aes(x = bill_length_mm,
#         fill = after_stat(level),
#         y = flipper_length_mm)) +
#     # expand limits 
#     expand_limits(x = c(x_min, x_max),
#         y = c(y_min, y_max)) +
#     # stat polygon
#     stat_density_2d(
#         geom = "polygon",
#         contour_var = "density",
#         color = "#000000",
#         linewidth = 0.15) +
#     # gradient
#     scale_fill_gradient(low = "#02577A",
#         high = "#ffffff",
#         guide = "none") 
# ggp2_dnsty_2d_fill + labs_dnsty_2d 


# 2-D HISTOGRAMS -----------------------------------------------
# this is a point plot with a histogram overlay
penguins <- palmerpenguins::penguins
penguins_2dhist <- penguins |> 
    dplyr::select(flipper_length_mm, 
        bill_length_mm, species, sex, island) |> 
    tidyr::drop_na()
glimpse(penguins_2dhist)

labs_2dhist <- labs(
    title = "Adult Foraging Penguins", 
    subtitle = "Near Palmer Station, Antarctica", 
    x = "Bill length (mm)", 
    y = "Flipper length (mm)")

ggp2_2dhist <- ggplot(data = penguins_2dhist, 
    mapping = aes(x = bill_length_mm, 
                  y = flipper_length_mm)) + 
    geom_bin2d()
            
ggp2_2dhist + 
    labs_2dhist

## bins -------------------------------------------
ggp2_base <- ggplot(data = penguins_2dhist, 
    mapping = aes(x = bill_length_mm, 
                  y = flipper_length_mm)) 
ggp2_2dbins15 <- ggp2_base + 
                    geom_bin2d(bins = 15) 
ggp2_2dbins15 + 
     labs_2dhist 
## palettes -------------------------------------------
ggp2_2dbins15 + 
    scale_fill_continuous_sequential(
        palette = "Mako", 
        rev = TRUE) +
    labs_2dhist 

ggp2_2dbins15 + 
    scale_fill_continuous_sequential(
        palette = "Mako", 
        rev = FALSE) +
    labs_2dhist 

## Options -------------------------------------------
ggp2_2dbins15 + 
    scale_fill_continuous_sequential(
        palette = "SunsetDark",
        rev = TRUE,
        begin = 0.7, end = 0.2) +
    geom_point(color = "#007bff",
        fill = "#FFFFFF", shape = 21,
        size = 2.2, alpha = 0.75) +
    labs_2dhist

### patchwork graphs -----
ggp2_y_hist <- ggplot(data = penguins_2dhist,
    mapping = aes(x = flipper_length_mm)) + 
    geom_histogram(alpha = 2/3) + 
    theme_void() + 
    coord_flip() + 
    theme(axis.text.y = element_text(size = 11)) +
    labs(x = "Flipper length (mm)")

ggp2_x_hist <- ggplot(data = penguins_2dhist,
    mapping = aes(x = bill_length_mm)) + 
    geom_histogram(alpha = 2/3) + 
    theme_void() + 
    theme(axis.text.x = element_text(size = 11)) +
    labs(x = "Bill length (mm)")

ggp2_y_hist + ggp2_x_hist + 
    patchwork::plot_layout(nrow = 1)
     

# HEX BINS ---------------------------------------------------
# load penguins data (remove missing from sex and species)
## data ----
penguins_hex <- palmerpenguins::penguins |> 
    dplyr::select(flipper_length_mm, bill_depth_mm,
        bill_length_mm, species, sex, island) |> 
    tidyr::drop_na()
glimpse(penguins_hex)
## labs ----
labs_hex <- labs(
    title = "Adult Foraging Penguins", 
    subtitle = "Near Palmer Station, Antarctica", 
    x = "Bill length (mm)", 
    y = "Flipper length (mm)")
## graph ----
ggp2_hex <- ggplot(data = penguins_hex, 
    aes(x = bill_length_mm, y = flipper_length_mm)) + 
    geom_hex()

ggp2_hex + 
    labs_hex
## bins ----
ggp2_hex_b20 <- ggplot(data = penguins_hex,
    aes(x = bill_length_mm, y = flipper_length_mm)) +
    geom_hex(bins = 20)

ggp2_hex_b20 + 
    labs_hex

ggp2_hex_b15 <- ggplot(data = penguins_hex,
    aes(x = bill_length_mm, y = flipper_length_mm)) +
    geom_hex(bins = 15)

ggp2_hex_b15 +
    labs_hex

# labs 2 
labs_hex2 <- labs(
    title = "Adult Foraging Penguins", 
    subtitle = "Near Palmer Station, Antarctica", 
    x = "Bill length (mm)", 
    y = "Flipper length (mm)",
    fill = "Sex")
# fill 
ggplot(data = penguins_hex, 
    aes(x = bill_length_mm, 
        y = flipper_length_mm)) + 
    geom_hex(aes(fill = sex), 
             bins = 15, 
             alpha = 3/4) + 
    scale_color_discrete_sequential(
        aesthetics = "fill", 
        rev = FALSE,
        palette = "Viridis") +
    labs_hex2
# labs 3
labs_hex3 <- labs(
    title = "Adult Foraging Penguins", 
    subtitle = "Near Palmer Station, Antarctica", 
    x = "Bill length (mm)", 
    y = "Flipper length (mm)",
    fill = "Species")
# fill 3
ggplot(data = penguins_hex, 
    aes(x = bill_length_mm, 
        y = flipper_length_mm, 
        fill = species)) + 
    geom_hex(binwidth = c(1.2, 4.5),
        linewidth = 0.5, 
        alpha = 3/4,
        color = "#000000") + 
    scale_color_discrete_sequential(
        aesthetics = "fill", 
        palette = "Dark Mint") +
    labs_hex3
