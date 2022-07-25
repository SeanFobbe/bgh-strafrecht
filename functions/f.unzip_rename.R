



f.unzip_rename  <- function(dir.in,
                            dir.out){


    ## ZIP-Archive definieren
    files.zip <- list.files(dir.in,
                            full.names = TRUE)

    ## ZIP-Archive entpacken
    mapply(unzip,
           zipfile = files.zip,
           exdir = dir.out)
    


    ## Dateinamen laden
    filenames.old <- list.files(dir.out,
                            pattern = "\\.pdf",
                            ignore.case = TRUE)


    ## Dateinamen korrigieren

    filenames.new <- gsub("\\.PDF", "\\.pdf", filenames.old)
    filenames.new <- gsub("STR", "StR", filenames.new)
    filenames.new <- gsub("stR", "StR", filenames.new)
    filenames.new <- gsub("[_]{1,4}", "_", filenames.new)

    filenames.new <- gsub("-", "_", filenames.new)
    filenames.new <- gsub("(4_StR_594)([a-z]*)(_51)", "\\1\\3_\\2", filenames.new) # recheck how to code
    filenames.new <- gsub("unano", "", filenames.new)

    filenames.new  <- gsub("ok\\.\\.pdf", "\\.pdf", filenames.new, ignore.case = TRUE)
    filenames.new  <- gsub("ok\\.pdf", "\\.pdf", filenames.new, ignore.case = TRUE)

    filenames.new  <- gsub(".pdf", "_NA_NA_NA.pdf", filenames.new)
    filenames.new <- gsub("[_]{1,4}", "_", filenames.new)

    filenames.new  <- gsub("([a-dA-D])_NA_NA_NA", "_NA_NA_\\1", filenames.new)

    filenames.new  <- gsub("nurBBes_NA", "_Berichtigung", filenames.new)
    filenames.new <- gsub("[_]{1,4}", "_", filenames.new)

    filenames.new  <- gsub("\\(S\\)_NA", "S", filenames.new)
    

    

    ## REGEX-Validierung der Dateinamen

    regex.test <- grep(paste0("[0-9]", # Senats
                              "_",
                              "((StR)|(ARS))", # Registerzeichen
                              "_",
                              "[0-9]{1,4}", # Eingangsnummer
                              "_",
                              "[0-9]{2}", # Eingangsjahr
                              "_",
                              "[A-Za-z]+",
                              "_",
                              "NA",
                              "_",
                              "[a-zA-Z]+",
                              "\\.pdf"),
                       filenames.new,
                       invert = TRUE,
                       value = TRUE)
    
    
    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){

        warning("Folgende Dateinamen sind fehlerhaft:")
        warning(regex.test)
        
        stop("REGEX-Validierung gescheitert: Dateinamen entsprechen nicht dem Codebook-Schema!!")
    }


    ## Umbenennung durchführen
    file.rename(file.path(dir.out, filenames.old),
                file.path(dir.out, filenames.new))



    return(file.path(dir.out, filenames.new))
    

}







