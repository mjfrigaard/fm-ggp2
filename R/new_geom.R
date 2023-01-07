library(fs)
library(janitor)
library(stringr)
library(ggplot2)

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

# new_geom(geom_name = "bar")
