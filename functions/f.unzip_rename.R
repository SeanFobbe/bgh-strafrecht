

#' Entpackt die originalen ZIP-Archive und korrigiert die Dateinamen.
#' 
#' @param dir.in Der Ordner mit den originalen ZIP-Archiven.
#' @param dir.out Der Ordner in dem die korrigierten PDF-Dateien gespeichert werden sollen.

#' @return Ein Vektor der korrigierten PDF-Dateinamen mit Pfaden relativ zum Projektordner.



f.unzip_rename  <- function(dir.in,
                            dir.out){

    ## Output-Ordner löschen
    files.pdf <- list.files(dir.out,
                            full.names = TRUE)
    unlink(files.pdf)

    ## Output-Ordner neu erstellen
    dir.create(dir.out, showWarnings = FALSE, recursive = TRUE)
    

    ## ZIP-Archive definieren
    files.zip <- list.files(dir.in,
                            full.names = TRUE)

    ## ZIP-Archive entpacken
    files.old <- mapply(unzip,
                        zipfile = files.zip,
                        exdir = dir.out)
    

    ## Dateinamen lesen
    filenames.old <-  list.files(dir.out, full.names = TRUE)

    ## Identische Dateien entfernen
    delete <- grep("(1_StR_275-83-ok.pdf)|(3_StR_546-96.pdf.pdf)", filenames.old, value = TRUE)
    unlink(delete)
    filenames.old <-  list.files(dir.out, full.names = TRUE)

    ## Dateinamen korrigieren
    filenames.new <- gsub("\\.PDF", "\\.pdf", basename(filenames.old))
    filenames.new <- gsub("STR", "StR", filenames.new)
    filenames.new <- gsub("stR", "StR", filenames.new)
    filenames.new <- gsub("[_]{1,4}", "_", filenames.new)

    filenames.new <- gsub("-", "_", filenames.new)
    filenames.new <- gsub("(4_StR_594)([a-z]*)(_51)", "\\1\\3_\\2", filenames.new) # recheck how to code
    filenames.new <- gsub("unano", "", filenames.new)

    filenames.new  <- gsub("ok\\.\\.pdf", "\\.pdf", filenames.new, ignore.case = TRUE)
    filenames.new  <- gsub("ok\\.pdf", "\\.pdf", filenames.new, ignore.case = TRUE)

    filenames.new  <- gsub(".pdf", "_NA_NA_NA.pdf", filenames.new)

    filenames.new <- gsub("[_]{1,4}", "_", filenames.new) #dup

    filenames.new  <- gsub("([a-dA-D])_NA_NA_NA", "_NA_NA_\\1", filenames.new)

    filenames.new  <- gsub("nurBBes_NA", "_Berichtigung", filenames.new)
    filenames.new <- gsub("[_]{1,4}", "_", filenames.new)

    filenames.new  <- gsub("\\(S\\)_NA", "S", filenames.new)

    
    ## Test auf Einzigartigkeit

    test.unique <- sum(duplicated(filenames.new))

    if(test.unique > 0){
        warning("Folgende Dateien sind nicht einzigartig:")
        warning(paste0(filenames.new[duplicated(filenames.new)], collapse = ", "))
        stop("Dateinamen sind nicht einzigartig.")
    }



    ## REGEX-Validierung der Dateinamen

    regex.fail <- grep(paste0("[0-5]", # Senatsnummer
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

    if (length(regex.fail) != 0){

        warning("Folgende Dateinamen sind fehlerhaft:")
        warning(paste0(regex.fail, collapse = ", "))
        
        stop("REGEX-Validierung gescheitert: Dateinamen entsprechen nicht dem Codebook-Schema!")
    }


    ## Neuen Pfad einfügen

    filenames.new.fullpath <- file.path(dir.out, filenames.new)
    
    ## Umbenennung durchführen
    file_move(filenames.old,
              filenames.new.fullpath)



    return(filenames.new.fullpath)
    

}





### DEBUGGING

#dir.in  <-  "zip_original"
#dir.out  <-  "files/pdf_original"

