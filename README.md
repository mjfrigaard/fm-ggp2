# ggplot2: field manual

This repository holds the source for [*ggplot2: field manual*](https://mjfrigaard.github.io/fm-ggp2/), a quick reference for building common graphs with `ggplot2`. Each chapter covers one type of graph, and walks through the data, the distribution behind it, and the grammar used to draw it.

## How the book is built

Every chapter creates its own data with a few lines of R code (using base R functions like `rnorm()`, `rpois()`, and `sample()`, or packages like [`faux`](https://debruine.github.io/faux/)). The simulated data is themed around the late 80s and 90s, and each chapter has a matching `ggplot2` theme from the [`fmggp2` package](https://mjfrigaard.github.io/fmggp2/).

The book uses [Quarto](https://quarto.org/) with `freeze: auto`, so R code only runs locally. The results are stored in `_freeze/` and committed with the chapters.

## Rendering locally

The R packages are managed with [`renv`](https://rstudio.github.io/renv/). Restore them before rendering:

```r
renv::restore()
```

Then render the full book or preview a single chapter:

```bash
quarto render
quarto preview histograms.qmd --no-browser --no-watch-inputs
```

Commit the updated `_freeze/` folder along with any changed chapters. The publishing workflow doesn't install R, so a chapter without matching freeze results will fail to build.

## Publishing

Every push to `main` triggers the [publish workflow](.github/workflows/publish.yml). It renders the book from the frozen results and deploys `_book/` to GitHub Pages. Changes to `README.md` and `_drafts/` don't trigger a deploy.

## Trouble rendering?

If a preview or render fails with an error like this:

```
ERROR: NotFound: No such file or directory (os error 2): stat '.../.quarto/quarto-session-temp...'
```

Quarto found a temporary session folder that was removed while it was scanning the project. These folders usually come from previews or renders that didn't shut down cleanly. Clear them from the book folder with the command below (it only deletes them when no Quarto render or preview is running):

```bash
pgrep -f "quarto.js (preview|render)" || rm -rf .quarto/quarto-session-temp*
```

The same check from the R console:

```r
if (!length(system("pgrep -f 'quarto.js (preview|render)'", intern = TRUE, ignore.stderr = TRUE))) {
  unlink(Sys.glob(".quarto/quarto-session-temp*"), recursive = TRUE)
}
```

The `.quarto/` folder is a local cache (it isn't tracked by git), so its contents are safe to delete.
