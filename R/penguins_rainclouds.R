library(palmerpenguins)
library(ggtext)
library(colorspace)
library(ragg)

url <- "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/master/man/figures/lter_penguins.png"
img <- magick::image_read((url))
pic <- grid::rasterGrob(img, interpolate = TRUE)

pal <- c("#FF8C00", "#A034F0", "#159090")

add_sample <- function(x){
   return(c(y = max(x) + .025, 
            label = length(x)))
}

penguins %>% 
  group_by(species) %>% 
  mutate(bill_ratio = bill_length_mm / bill_depth_mm) %>% 
  filter(!is.na(bill_ratio)) %>% 
  ggplot(aes(x = fct_rev(species), y = bill_ratio)) + 
  ggdist::stat_halfeye(
    aes(color = species,
        fill = after_scale(lighten(color, .5))),
    adjust = .5, 
    width = .75, 
    .width = 0,
    justification = -.4, 
    point_color = NA) + 
  geom_boxplot(
    aes(color = species,
        color = after_scale(darken(color, .1, space = "HLS")),
        fill = after_scale(desaturate(lighten(color, .8), .4))),
    width = .42, 
    outlier.shape = NA
  ) +
  geom_point(
    aes(color = species,
        color = after_scale(darken(color, .1, space = "HLS"))),
    fill = "white",
    shape = 21,
    stroke = .4,
    size = 2,
    position = position_jitter(seed = 1, width = .12)
  ) + 
  geom_point(
    aes(fill = species),
    color = "transparent",
    shape = 21,
    stroke = .4,
    size = 2,
    alpha = .3,
    position = position_jitter(seed = 1, width = .12)
  ) + 
  stat_summary(
    geom = "text",
    fun = "median",
    aes(label = round(..y.., 2),
        color = species,
        color = after_scale(darken(color, .1, space = "HLS"))),
    family = "Roboto Mono",
    fontface = "bold",
    size = 4.5,
    vjust = -3.5
  ) +
  stat_summary(
    geom = "text",
    fun.data = add_sample,
    aes(label = paste("n =", ..label..),
        color = species,
        color = after_scale(darken(color, .1, space = "HLS"))),
    family = "Roboto Condensed",
    size = 4,
    hjust = 0
  ) +
  coord_flip(xlim = c(1.2, NA), clip = "off") +
  annotation_custom(pic, ymin = 2.9, ymax = 3.85, xmin = 2.7, xmax = 4.7) +
  scale_y_continuous(
    limits = c(1.57, 3.8),
    breaks = seq(1.6, 3.8, by = .2),
    expand = c(.001, .001)
  ) +
  scale_color_manual(values = pal, guide = "none") +
  scale_fill_manual(values = pal, guide = "none") +
  labs(
    x = NULL,
    y = "Bill ratio",
    title = "Bill Ratios of Brush–Tailed Penguins (*Pygoscelis* spec.)",
    subtitle = "Distribution of bill ratios, estimated as bill length divided by bill depth.",
    caption = "Gorman, Williams & Fraser (2014) *PLoS ONE* DOI: 10.1371/journal.pone.0090081<br>Visualization: Cédric Scherer  &bull;    Illustration: Allison Horst"
  ) +
  theme_minimal(base_family = "Zilla Slab", base_size = 15) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_text(family = "Roboto Mono"),
    axis.text.y = element_text(
      color = rev(darken(pal, .1, space = "HLS")), 
      size = 18
    ),
    axis.title.x = element_text(margin = margin(t = 10),
                                size = 16),
    plot.title = element_markdown(face = "bold", size = 21),
    plot.subtitle = element_text(
      color = "grey40", hjust = 0,
      margin = margin(0, 0, 20, 0)
    ),
    plot.title.position = "plot",
    plot.caption = element_markdown(
      color = "grey40", lineheight = 1.2,
      margin = margin(20, 0, 0, 0)),
    plot.margin = margin(15, 15, 10, 15)
  )