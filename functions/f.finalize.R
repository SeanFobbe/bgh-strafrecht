#' Datensatz finalisieren
#'
#' Der Datensatz wird mit dieser Funktion um bereits berechnete Variablen angereichert und in Reihenfolge der Variablen-Dokumentation des Codebooks sortiert.

#' @param x Data.table. Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param vars.additional Data.table. Zusätzliche Variablen, die zuvor extrahiert wurden und nun mit cbind eingehängt werden. Vektoren müssen so geordnet sein wie 'x'.
#' @param varnames Character. Die im Datensatz erlaubten Variablen, in der im Codebook vorgegebenen Reihenfolge.




f.finalize <- function(x,
                       vars.additional,
                       varnames){

    
    ## Unit Test
    test_that("Input is of correct type.", {
        expect_s3_class(x, "data.table")
        expect_s3_class(vars.additional, "data.table")
        expect_type(varnames, "character")
    })

    ## Remove Tesseract Indicator
    x$docvar8 <- NULL
        
    ## Rename Raw OCR Text Variable
    setnames(x, "text", "text_raw")
    

    ## Bind additional vars
    dt.final <- cbind(x,
                     vars.additional)


    ## Clean Dates (also sorts by date!)
    dt.final <- f.clean_dates_courts_de(x = dt.final,
                                        boundary = 45)

    
    ## Add variable "gericht"
    dt.final$gericht <- rep("BGH", nrow(dt.final))

    ## Add variable "spruchkoerper_db"
    dt.final$spruchkoerper_db <- paste0("Strafsenat-", dt.final$spruchkoerper_az)

    
    ## Rebuild variable "doc_id"
    dt.final$doc_id <- with(data = dt.final,
                            paste(gericht,
                                  spruchkoerper_db,
                                  "NA",
                                  datum,
                                  spruchkoerper_az,
                                  registerzeichen,
                                  eingangsnummer,
                                  eingangsjahr_az,
                                  zusatz_az,
                                  "NA",
                                  kollision,
                                  sep = "_"))

    dt.final$doc_id <- paste0(dt.final$doc_id, ".txt")


    ## Unit Test: Check if all variables are documented
    varnames <- gsub("\\\\", "", varnames) # Remove LaTeX escape characters
    stopifnot(setequal(names(dt.final), varnames))
    
    ## Order variables as in Codebook
    data.table::setcolorder(dt.final, varnames)



    ## Unit Tests
    test_that("Output is of correct type", {
        expect_s3_class(dt.final, "data.table")
    })

    test_that("Decision date is plausible", {
        expect_true(all(na.omit(dt.final$datum) > "1950-10-01")) # Minimum
        expect_true(all(na.omit(dt.final$datum) <= "2000-01-01")) # Maximum
    })

    test_that("Decision year is plausible", {
        expect_true(all(na.omit(dt.final$entscheidungsjahr) >= 1950))
        expect_true(all(na.omit(dt.final$entscheidungsjahr) <= 2000))
    })

    test_that("Incoming year is plausible", {
        expect_true(all(na.omit(dt.final$eingangsjahr_iso) >= 1950))
        expect_true(all(na.omit(dt.final$eingangsjahr_iso) <= 2000))
    })

    test_that("Spruchkörper_db contains only expected values.", {
        expect_in(dt.final$spruchkoerper_db, paste0("Strafsenat-", 1:6))
    })

    
    test_that("Spruchkörper_az contains only expected values.", {
        expect_in(dt.final$spruchkoerper_az, c(1:6))
    })
    

    test_that("Registerzeichen contain only expected values", {
        expect_in(dt.final$registerzeichen,
                        c("StR", "ARs"))                                                  
    })


    test_that("Eingangsnummern are plausible", {
        expect_true(all(dt.final$eingangsnummer > 0))
        expect_true(all(dt.final$eingangsnummer < 1e4))
    })

    
    test_that("Dummy variables contain only 0 and 1.", {
        expect_setequal(dt.final$bghz, 0)
        expect_setequal(dt.final$bghr, c(0, 1))
        expect_setequal(dt.final$bghst, c(0, 1))
        expect_setequal(dt.final$nachschlagewerk, c(0, 1))
    })


    return(dt.final)
    

}


## DEBUGGING CODE

## library(data.table)
## library(testthat)

## x <- tar_read(dt.ocr)
## vars.additional <-  tar_read(vars_additional)
## varnames <- tar_read(datamodel)$varname
