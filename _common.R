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

# import font ----
extrafont::font_import(
    paths = "assets/Ubuntu/",
    prompt = FALSE)

# add font ----
sysfonts::font_add(
    family =  "Ubuntu", 
    regular = "assets/Ubuntu/Ubuntu-Regular.ttf")

# add theme ----
source("R/theme_ggp2g.R")

# Not in ----
"%nin%" <- function(x, y) {
  return( !(x %in% y) )
}


status <- function(type) {
  status <- switch(type,
    polish = "should be readable but is currently undergoing final polishing",
    dev = "is still in development and may be confusing or incomplete",
    draft = "is currently a dumping ground for ideas, and we don't recommend reading it",
    complete = "is largely complete and just needs final proof reading",
    stop("Invalid `type`", call. = FALSE)
  )

  class <- switch(type,
    polish = "note",
    dev = "warning",
    draft = "caution",
    complete = "tip"
  )

  cat(paste0(
    "\n",
    "::: {.callout-", class, " appearance='simple'", " icon=false}", "\n",
    "***This graph ", status, ".*** ", "\n",
    ":::", "\n"
  ))
}