# pkgs ------------------------------------
library(tidyverse)
library(fs)
library(glue)
library(stringr)
library(purrr)
library(extrafont)
library(sysfonts)


# source _common.R --------------------------------------------------------
source("_common.R")

# source new_graph and new_geom -------------
source("R/new_graph.R")
source("R/new_geom.R")
# new_graph(name = "DAGs")
# new_geom(geom_name = "PRIMITIVES")

# fonts --------------------
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
# add theme ------------------------------------
source("R/theme_ggp2g.R")
# set theme ------------------------------------
ggplot2::theme_set(theme_ggp2g(
    base_size = 14))

# geom_scripts ------------------------------------------------------------
# create geom scripts
ggp2_funs <- lsf.str("package:ggplot2")
geom_funs <- ggp2_funs[str_detect(ggp2_funs, "^geom_")]
geom_files <- paste0("R/", geom_funs, ".R")
script_header <- "# pkgs ----
install.packages(c('palmerpenguins', 'ggplot2movies', 
       'ggplot2', 'dplyr', 'tidyr'))
library(palmerpenguins)
library(ggplot2movies)
library(ggplot2)
library(dplyr)
library(tidyr)

# data ----

# code ----

# graph ----"

# geom_files
# create script files 
# map(.x = geom_files, .f = fs::file_create)
# add headers to files 
# write_lines(x = script_header, file = "R/geom_abline.R", append = TRUE)
# map2(.x = script_header, .y = geom_files, .f = write_lines, append = TRUE)


# qmd files ---------------------------------------------------------------
qmds <- c("uni", "amt", "prp", "dist", "rela", "stat") |> purrr::set_names()

graph_files <- purrr::map_df(.x = qmds, 
    .f = fs::dir_info, 
    regexp = ".qmd$", type = "file") |> 
    dplyr::select(qmd_path = path, contains("time")) |> 
    dplyr::mutate(
        qmd_path = as.character(qmd_path),
        qmd_file = base::basename(qmd_path),
        r_file = stringr::str_replace_all(
                        qmd_file, ".qmd", ".R"),
        r_path = stringr::str_replace_all(
                        qmd_path, "uni|amt|prp|dist|rela|stat", "R"),
        r_path = stringr::str_replace_all(
                        r_path, ".qmd", ".R")) |> 
    dplyr::select(contains("time"), 
                  contains("path"), 
                  contains("file"))

glimpse(graph_files)