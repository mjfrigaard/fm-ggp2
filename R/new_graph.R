library(fs)
library(janitor)

new_graph <- function(name) {
    # clean name
    clean_name <- janitor::make_clean_names(string = name)
    # create path
    grph_pth <- paste0(clean_name, ".qmd")
    if (!fs::file_exists(grph_pth)) {
        fs::file_copy(path = "_drafts/_new_graph.qmd", 
            new_path = grph_pth)
        fs::file_show(grph_pth)
    } else {
        cli::cli_abort("this file exists!")
    }
}
