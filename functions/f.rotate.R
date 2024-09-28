#' f.rotate
#'
#' Rotates PDFs between orientations.
#'
#' @param x Paths to PDF files to be rotated.
#' @param angle Regular rotation angle.
#' @param files.opposite Names of files that require the opposite rotation. Do not use full paths, just the filename.
#' @param dir.output The directory to stored ouput files in.
#' @param clean Whether to delete and recreate the output directory before running the function.

#' @return A vector of paths to PDF files that have been rotated.



f.rotate <- function(x,
                     files.opposite = NULL,
                     angle = -90,
                     dir.output = "rotated",
                     clean = TRUE){

    if(clean == TRUE){

        unlink(dir.output, recursive = TRUE)
        dir.create(dir.output, showWarnings = FALSE, recursive = TRUE)
        
    }

    if(is.null(files.opposite) == TRUE){
        angle <- angle
    }else{

        angle <- rep(angle, length(x))
        index <- basename(x) %in% basename(files.opposite)
        angle[index] <- -angle
        
    }

    
    out <- mapply(qpdf::pdf_rotate_pages,
                  input = x,
                  output = file.path(dir.output, basename(x)),
                  angle = angle,
                  relative = TRUE,
                  USE.NAMES = FALSE)

    return(out)
    

}
