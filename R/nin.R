##############################################################################
### Creation Date: 12/2022
### Last Modified: 2023-01-02 10:15:33 PST
##############################################################################

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