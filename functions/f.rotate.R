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


## DEBUGGING CODE

## tar_load(dt.landscape)
## x <- dt.landscape$x[dt.landscape$landscape]
## files.opposite = c("2_StR_481_84_NA_NA_NA.pdf",
##                    "4_StR_131_60_NA_NA_NA.pdf",
##                    "4_StR_190_70_NA_NA_NA.pdf",
##                    "4_StR_512_89_NA_NA_NA.pdf")
## angle = -90
## dir.output = "files/pdf_rotated"
## clean = TRUE
