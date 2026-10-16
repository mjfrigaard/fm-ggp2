pak::pak("corybrunson/ggalluvial")
pak::pak("davidsjoberg/ggbump")
pak::pak("thomasp85/ggforce")
pak::pak("haleyjeppson/ggmosaic")
pak::pak("davidsjoberg/ggstream")
pak::pak("wilkox/treemapify")
pak::pak("liamgilbey/ggwaffle")
install.packages("colorspace", repos = "http://R-Forge.R-project.org")
pak::pak('jorvlan/raincloudplots')

# pkgs ------------------------------------
library(tidyverse)
library(extrafont)
library(sysfonts)


# source _common.R --------------------------------------------------------
source("_common.R")

# use font
showtext::showtext_auto()
# set theme ------------------------------------
ggplot2::theme_set(theme_ggp2g(
    base_size = 14))
