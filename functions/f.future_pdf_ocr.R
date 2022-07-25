





f.future_pdf_ocr <- function(x,
                        outputdir = NULL,
                        quiet = TRUE,
                           jobs = round(parallel::detectCores() / 4)){

    ## Timestamp: Begin
    begin.extract <- Sys.time()

    ## Intro messages
    if(quiet == FALSE){
        message(paste("Begin at:", begin.extract))
        message(paste("Processing", length(x), "PDF files."))
    }

    ## Perform conversion from PDF to TXT
    invisible(future.apply::future_lapply(x,
                                          pdf_extract_single,
                                          outputdir = outputdir,
                                          future.seed = TRUE))


    ## Construct full list of TXT names
    txt.names <- gsub("\\.pdf$",
                      "\\.txt",
                      x,
                      ignore.case = TRUE)

    ## Check list of TXT files in folder
    txt.results <- file.exists(txt.names)
    
    ## Timestamp: End
    end.extract <- Sys.time()

    ## Duration
    duration.extract <- end.extract - begin.extract

    
    ## Outro messages
    if(quiet == FALSE){
        message(paste0("Successfully processed ",
                       sum(txt.results),
                       " PDF files. ",
                       sum(!txt.results),
                       " PDF files failed."))
        
        message(paste0("Runtime was ",
                       round(duration.extract,
                             digits = 2),
                       " ",
                       attributes(duration.extract)$units,
                       "."))
        
        message(paste0("Ended at: ",
                       end.extract))
    }

}






pdf_ocr_single <- function(x,
                           dpi = 300,
                           lang = "eng",
                           output = "pdf txt",
                           outputdir = NULL){
    
    ## Define names
    name.tiff <- gsub("\\.pdf",
                      "\\.tiff",
                      x,
                      ignore.case = TRUE)
    
    name.out <- gsub("\\.pdf",
                     "_TESSERACT",
                     x,
                     ignore.case = TRUE)

    ## Convert to TIFF
    system2("convert",
            paste("-density",
                  dpi,
                  "-depth 8 -compress LZW -strip -background white -alpha off",
                  x,
                  name.tiff))

    ## Alternate Folder Option
    if (!is.null(outputdir)){
        
        txtname <- file.path(outputdir, basename(txtname))
        
        }

    ## Run Tesseract
    system2("tesseract",
            paste(name.tiff,
                  name.out,
                  "-l",
                  lang,
                  output))
    
    unlink(name.tiff)

    


    
    ## Write TXT to Disk
    utils::write.table(pdf.extracted,
                       txtname,
                       quote = FALSE,
                       row.names = FALSE,
                       col.names = FALSE)
    
}
