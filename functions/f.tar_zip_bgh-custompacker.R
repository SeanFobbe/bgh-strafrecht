#' ZIP for targets framework: Custom packer for BGH Criminal Law Decisions
#'
#'
#' @param x Character. The files to be added to the ZIP archive.
#' @param names.new Character. The new file names of the files specified in "x".
#' @param dir Character. The directory in which to create the ZIP archive.
#'
#' @return Character. The path to the ZIP file.

f.tar_zip_bgh_custompacker <- function(pdf,
                                       names.old,
                                       names.new,
                                       dir){


    
    length(x)
    length(names.new)
    
    
    
    filename <- file.path(dir, filename)
    
    zip::zip(filename,
             x,
             mode = mode)
    
    return(filename)
    
}

## DEBUGGING CODE

## pdf <- tar_read(pdf.cleaned.noprob)
## tar_load(dt.final)
## names.old <- dt.final$doc_id_raw
## names.new <- dt.final$doc_id
## dir <- "output"
