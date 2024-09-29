#' f.clean_text
#'
#' Clean OCR errors in text variable
#'
#' @param x String. A vector of texts.
#'
#' @return String. A vector of cleaned texts.





f.clean_text <- function(x){

    revised <- stringi::stri_replace_all(x,
                                         regex = "\\$\\$\\s*([0-9]+)",
                                         replacement = "§§ $1")

    revised <- stringi::stri_replace_all(revised,
                                         regex = "\\$\\s*([0-9]+)",
                                         replacement = "§ $1")


    return(revised
    
}


