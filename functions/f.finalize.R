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
    

    ## Bind additional vars
    dt.main <- cbind(x,
                     vars.additional)


    ## Unit Test: Check if all variables are documented
    varnames <- gsub("\\\\", "", varnames) # Remove LaTeX escape characters
    stopifnot(length(setdiff(names(dt.final), varnames)) == 0)
    
    ## Order variables as in Codebook
    data.table::setcolorder(dt.final, varnames)



    ## Unit Tests
    test_that("Output is of correct type", {
        expect_s3_class(dt.final, "data.table")
    })

    test_that("Date is plausible", {
        expect_true(all(dt.final$datum > "2000-01-01"))
        expect_true(all(dt.final$datum <= Sys.Date()))
    })

    test_that("Year is plausible", {
        expect_true(all(dt.final$entscheidungsjahr >= 2000))
        expect_true(all(dt.final$entscheidungsjahr <= year(Sys.Date())))
    })


    test_that("Registerzeichen contain only expected values", {
        expect_in(dt.final$registerzeichen,
                        c("StR", "ARS"))                                                  
    })


    test_that("Eingangsnummern are plausible", {
        expect_true(all(dt.final$eingangsnummer > 0))
        expect_true(all(dt.final$eingangsnummer < 1e4))
    })


    return(dt.final)
    

}
