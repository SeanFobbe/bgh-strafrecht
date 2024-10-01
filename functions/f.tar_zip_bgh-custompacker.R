#' ZIP for targets framework: Custom packer for BGH Criminal Law Decisions
#'
#'
#' @param x Character. The files to be added to the ZIP archive.
#' @param names.new Character. The new file names of the files specified in "x".
#' @param dir Character. The directory in which to create the ZIP archive.
#' @param prefix.files Character. The prefix to be attached to each output ZIP archive.
#' 
#' @return Character. The path to the ZIP file.

f.tar_zip_bgh_custompacker <- function(pdf,
                                       dt.final,
                                       dir,
                                       prefix.files){

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

    ## Copy and rename PDF files to temp dir
    copy.result <- file.copy(pdf,
                             file.path(tempdir, pdfnames.out))
    
    if(sum(copy.result) != length(pdf)){
        warning("Files were NOT copied successfully to tempdir. Check function!")
        }

    tempdir.files <- list.files(tempdir, full.names = TRUE)

    packlist <- vector("list", 3)
    
    packlist[[1]] <- grep("BGH_Strafsenat-[1]", tempdir.files, value = TRUE)
    packlist[[2]] <- grep("BGH_Strafsenat-[23]", tempdir.files, value = TRUE)
    packlist[[3]] <- grep("BGH_Strafsenat-[45]", tempdir.files, value = TRUE)

    ## sum(file.size(packlist[[1]])) / 1e6
    ## sum(file.size(packlist[[2]])) / 1e6
    ## sum(file.size(packlist[[3]])) / 1e6

    zip.filenames <- file.path(dir, paste0(prefix.files,
                                           "_DE_PDF_Senat-",
                                           c("1",
                                             "2-und-3",
                                             "4-und-5"),
                                           ".zip"))
                                                           

    for(i in 1:3){
        zip::zip(zipfile = zip.filenames[i],
                 files = packlist[[i]],
                 mode = "cherry-pick")
        }
    
    return(zip.filenames)
    
}


## DEBUGGING CODE

## pdf <- tar_read(pdf.cleaned.noprob)
## tar_load(dt.final)
## names.old <- dt.final$doc_id_raw
## names.new <- dt.final$doc_id
## dir <- "output"
