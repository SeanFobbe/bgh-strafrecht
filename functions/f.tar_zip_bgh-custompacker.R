#' ZIP for targets framework: Custom packer for BGH Criminal Law Decisions
#'
#'
#' @param x Character. The files to be added to the ZIP archive.
#' @param names.new Character. The new file names of the files specified in "x".
#' @param dir Character. The directory in which to create the ZIP archive.
#'
#' @return Character. The path to the ZIP file.

f.tar_zip_bgh_custompacker <- function(pdf,
                                       dt.final,
                                       dir){

    ## Recreate original file names
    pdfnames.old <- with(dt.final,
                         paste(spruchkoerper_az,
                               registerzeichen,
                               eingangsnummer,
                               eingangsjahr_az,
                               zusatz_az,
                               name,
                               kollision,
                               sep = "_"))
    pdfnames.old <- paste0(pdfnames.old, ".pdf")
    pdfnames.new <- gsub("\\.txt", "\\.pdf", dt.final$doc_id)

    ## Assign new file names
    index <- match(pdfnames.old, basename(pdf))
    pdfnames.out <- pdfnames.new[index]


    ## Create Temp Directory
    tempdir <- tempdir()

    ## Rename PDF files and move to temp dir
    file.rename(pdf,
                file.path(tempdir, pdfnames.out))
    
    
    length(pdf)
    length(names.old)
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
