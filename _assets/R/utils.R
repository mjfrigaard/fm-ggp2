#=====================================================================#
# File name: utils.R
# This is code to create: utility functions for ggp2-graph-gallery
# Authored by and feedback to: mjfrigaard
# Last updated:  2023-01-02 10:15:33 PST
# MIT License
# Version: 2.2
#=====================================================================#

# pkgs --------------------------------------------------------------------
require(ggplot2)
require(extrafont)
require(showtext)
require(showtextdb)
require(sysfonts)
library(extrafont)
library(palmerpenguins)
library(fs)
library(janitor)
library(stringr)
library(ggplot2)

#' Not in
#'
#' The not-in operator for R.
#'
#' @param x vector or \code{NULL}: the values to be matched.
#' @param y vector or \code{NULL}: the values to be matched against.
#' @return The negation of \code{\link[base:match]{\%in\%}}.
#' @examples
#' 1 %nin% 2:10
#' c("a", "b") %nin% c("a", "c", "d")

"%nin%" <- function(x, y) {
  return( !(x %in% y) )
}


# datasets ---------------------------------------------------------
# https://github.com/friendly/vcdExtra/blob/master/R/datasets.R
datasets <- function(package, allClass = FALSE,
                     incPackage = length(package) > 1,
                     maxTitle = NULL) {
  # make sure requested packages are available and loaded
  for (i in seq_along(package)) {
    if (!isNamespaceLoaded(package[i])) {
      if (requireNamespace(package[i], quietly = TRUE)) {
        cat(paste("Loading package:", package[i], "\n"))
      } else {
        stop(paste("Package", package[i], "is not available"))
      }
    }
  }

  dsitems <- data(package = package)$results
  wanted <- c("Package", "Item", "Title")

  ds <- as.data.frame(dsitems[, wanted], stringsAsFactors = FALSE)

  getData <- function(x, pkg) {
    # fix items with " (...)" in names, e.g., "BJsales.lead (BJsales)"
    # in datasets
    objname <- gsub(" .*", "", x)
    e <- loadNamespace(pkg)
    if (!exists(x, envir = e)) {
      dataname <- sub("^.*\\(", "", x)
      dataname <- sub("\\)$", "", dataname)
      e <- new.env()
      data(list = dataname, package = pkg, envir = e)
    }
    get(objname, envir = e)
  }

  getDim <- function(i) {
    data <- getData(ds$Item[i], ds$Package[i])
    if (is.null(dim(data))) length(data) else paste(dim(data), collapse = "x")
  }
  getClass <- function(i) {
    data <- getData(ds$Item[i], ds$Package[i])
    cl <- class(data)
    if (length(cl) > 1 && !allClass) cl[length(cl)] else cl
  }

  ds$dim <- unlist(lapply(seq_len(nrow(ds)), getDim))

  ds$class <- unlist(lapply(seq_len(nrow(ds)), getClass))
  if (!is.null(maxTitle)) ds$Title <- substr(ds$Title, 1, maxTitle)
  if (incPackage) {
    ds[c("Package", "Item", "class", "dim", "Title")]
  } else {
    ds[c("Item", "class", "dim", "Title")]
  }

  ds_out <- select(ds, dataset = Item, title = Title)

  return(ds_out)

}


# new_geom() ----------------------------------------------------------------
#' New geom (post)
#'
#' @param geom_name 
#'
#' @return qmd file with geom sections
#'
#' @examples 
#' new_geom(geom_name = "bar")
new_geom <- function(geom_name) {
    # all geom functions
    ggp2_funs <- lsf.str("package:ggplot2")
    geom_funs <- ggp2_funs[stringr::str_detect(ggp2_funs, "^geom_")]
    # lowercase geom
    geom_fun <- str_to_lower(geom_name)
    # create path
    geom_pth <- paste0("./", "geoms", "/", geom_fun, ".qmd")
    if (geom_fun %in% geom_funs) {
        fs::file_copy(path = "./_drafts/_new_geom.qmd", 
            new_path = geom_pth)
        fs::file_show(geom_pth)
    } else {
        cli::cli_abort("this is not a geom_ function!")
    }
}


# new_graph() ---------------------------------------------------------------
#' New graph (post)
#'
#' @param name Name of graph
#' @param section category of graphs, one of : "uni", "amt", "prp", "dist", 
#'     "rela", and "stat".
#'
#' @return qmd file with graph sections
#'
#' @examples
#' new_graph( "line graphs", "rela")
new_graph <- function(name, section = c("uni", "amt", "prp", "dist", "rela", "stat")) {
    sections <- c("uni", "amt", "prp", "dist", "rela", "stat")
    # clean name
    clean_name <- janitor::make_clean_names(string = name)
    # create path
    grph_pth <- paste0("./", section, "/", clean_name, ".qmd")
    if (section %in% sections) {
        fs::file_copy(path = "./_drafts/_new_graph.qmd", 
            new_path = grph_pth)
        fs::file_show(grph_pth)
    } else {
        cli::cli_abort("this is not a section")
    }
}

