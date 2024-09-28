#'f.landscape
#'
#' Detects whether a PDF file is in landscape format. Landscape format is defined as width greater than height. Vectorized.
#'
#' @param x The path or filename of the PDF file to be tested.
#'
#' @return A data frame with the names of tested files and the test result. "TRUE" if landscape, "FALSE" if portrait and "NA" if not all pages have the same orientation.  




f.landscape <- function(x){
    landscape <- mapply(f.landscape_single, x, USE.NAMES = FALSE)
    dt <- data.frame(x, landscape)
    return(dt)
    }

f.landscape_single <- function(x){
    width <- pdftools::pdf_pagesize(x)$width
    height <- pdftools::pdf_pagesize(x)$height

    test <- width > height
    
    if(all(test) == TRUE){
        landscape <- TRUE        
    }else if(all(test) == FALSE){
        landscape <- FALSE
    }else{
        landscape <- NA
    }
    
    return(landscape)
}

