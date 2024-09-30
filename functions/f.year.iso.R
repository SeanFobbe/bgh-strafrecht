#' f.year.iso
#'
#' Tranform Double-Digit Years to ISO Year Format
#' 
#' Transforms double-digit years (YY) to four-digit years (YYYY). Based on the assumption that years above a certain boundary belong to the 20th century and years at or below that boundary belong to the 21st century.
#'
#' 
#' @param year Integer. A vector of two-digit years.
#' @param boundary Integer. The boundary year. Default is 50 (= 1950). 


f.year.iso <- function(year,
                       boundary = 50){
    
    out <- ifelse(year > boundary,
                  1900 + year,
                  2000 + year)

    return(out)
    
}
