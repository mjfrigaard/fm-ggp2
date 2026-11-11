set.seed(1014)
# knitr settings ----
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE,
  fig.retina = 2,
  fig.width = 9,
  out.width = "100%",
  fig.asp = 2/3,
  fig.show = "hold",
  fig.showtext = TRUE # draw showtext fonts at knitr's figure resolution
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
suppressMessages(fmutils::add_fonts("Ubuntu"))

# add theme ----
# the original book theme now lives in fmutils as theme_fmggp2()
theme_ggp2g <- fmutils::theme_fmggp2

# book helpers ----
library(fmutils) # %nin%, status(), and co_box()
library(ggrewindr) # the 90s themes

options(width = 50L,
  pillar.width = 50L)

