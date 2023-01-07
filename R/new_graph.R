library(fs)
library(janitor)

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
