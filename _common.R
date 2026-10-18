set.seed(1014)
# knitr settings ----
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE,
  fig.retina = 2,
  fig.width = 6,
  fig.asp = 2/3,
  fig.show = "hold"
)
# options  ----
options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  stringr.view_n = 10,
  # Activate crayon output - temporarily disabled for quarto
  # crayon.enabled = TRUE,
  pillar.bold = TRUE,
  width = 60, # 80 - 3 for #> comment
  scipen = 9999
)

# add font ----
suppressMessages(fmggp2::add_fonts("Ubuntu"))

# add theme ----
# the original book theme now lives in fmggp2 as theme_fmggp2()
theme_ggp2g <- fmggp2::theme_fmggp2

# book helpers ----
library(fmggp2) # %nin%, status(), co_box(), and the 90s themes

options(width = 50L,
  pillar.width = 50L)

