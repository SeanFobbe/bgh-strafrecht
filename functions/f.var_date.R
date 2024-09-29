#' f.var_date
#'
#' Extract a date in a specified format from the beginning of a text.
#'
#' @param x String. A vector of texts.
#' @param limit Integer. The number of characters from 1 to limit to be checked for a date.
#'
#' @return Date. A vector of dates in ISO format (e.g. 2024-01-03).






f.var_date <- function(x,){

    reduced <- substr(x, 1, 2000)

    date <- stringi::stri_extract_first(str = reduced,
                                        regex = "")
    
    }
