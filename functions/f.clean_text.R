#' f.clean_text
#'
#' Clean OCR errors in text variable
#'
#' @param x String. A vector of texts.
#'
#' @return String. A vector of cleaned texts.





f.clean_text <- function(x,
                         replacements){

    ## Entry tests
    stopifnot(is.character(x))
    stopifnot(is.data.table(replacements))

    ## Fix incorrect special symbols
    revised <- stringi::stri_replace_all(x,
                                         regex = "[\\$\\&]{2}\\s*([0-9]+)",
                                         replacement = "§§ $1")

    revised <- stringi::stri_replace_all(revised,
                                         regex = "[\\$\\&]\\s*([0-9]+)",
                                         replacement = "§ $1")

    ## Fix incorrect 8s (stricter REGEX because 8s are more common)
    revised <- stringi::stri_replace_all(revised,
                                         regex = "88\\s*([0-9]+)\\s*(StGB|StPO)",
                                         replacement = "§§ $1 $2")
    
    revised <- stringi::stri_replace_all(revised,
                                         regex = "8\\s*([0-9]+)\\s*(StGB|StPO)",
                                         replacement = "§ $1 $2")
    
    revised <- stringi::stri_replace_all(revised,
                                         regex = replacements$pattern,
                                         replacement = replacements$replacement,
                                         vectorize_all = FALSE)
    

    return(revised)
    
}


## DEBUGGING CODE

## x <- tar_read(dt.ocr)$text
## tar_load(replacements)
