# pkgs ----
library(tidyverse)
library(lubridate)
library(scales)
library(knitr)
library(kableExtra)
library(colorblindr)
library(downlit)
# fonts ----
library(extrafont)
library(sysfonts)
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
# use font
showtext::showtext_auto()
# set theme
ggplot2::theme_set(theme_ggp2g(
    base_size = 15))

# install.packages("ggdag")
library(ggdag)
library(ggplot2)
library(dagitty)
library(waldo)

# basics ------------------------------------------------------------------
# from the package vignette, first we get an introduction to daggity

g <- dagitty::dagitty("dag{ 
  a -> b b -> c c -> d
 }")
g

dag <- dagitty("dag{y <- z -> x}")
dag
tidy_dagitty(dag)
# waldo::compare(x = tidy_dagitty(dag), y = tidy_dagitty(dag2))

dagified <- ggdag::dagify(
  x ~ z,
  y ~ z,
  exposure = "x",
  outcome = "y"
)
dagified
ggdag::tidy_dagitty(dagified)
ggdag(dag, layout = "circle") + 
  ggdag::theme_dag_blank(base_size = 16, base_family = "bold")

dagify(
  # y ~ x
  output ~ input
) %>%
  ggplot(aes(x = x, y = y, 
    xend = xend, 
    yend = yend)) +
  ggdag::geom_dag_point(size = 20) +
  ggdag::geom_dag_edges_arc(curvature = 0) +
  ggdag::geom_dag_text(size = 7) +
  ggdag::theme_dag(base_size = 12)

ggdag::dagify(output ~ input) |> 
  ggdag::ggdag() +
  ggdag::theme_dag(base_size = 12)

ggdag::dagify(
  mod_y ~ mod_x,
  mod_x ~ mod_y
  ) |>
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
  geom_dag_point(color = "red", size = 30, alpha = 1/3) +
  geom_dag_edges_arc(curvature = 0) +
  geom_dag_text(size = 10, color = "black") +
  theme_dag(base_size = 18)
