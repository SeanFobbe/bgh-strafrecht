#' f.clean_dates_courts_de
#'
#' Specific to German court datasets produced by Fobbe. Converts decision date variable to IDate, computes decision year from date variable, computes four-digit incoming year from two-digit incoming year and sorts dataset by date.
#'

#' @param x Data.table. Must contain variable "datum" and "eingangsjahr_az".

#' @param return Data.table. Returns full data set with converted data variable, additional year variables and sorted by date.



f.clean_dates_courts_de <- function(x,
                                    boundary = 50){

    ## Convert "datum" to IDate class
    x$datum <- as.IDate(x$datum)

    ## Add variable "entscheidungsjahr"
    x$entscheidungsjahr <- year(x$datum)

    ## Add variable "eingangsjahr_iso"
    x$eingangsjahr_iso <- f.year.iso(x$eingangsjahr_az,
                                     boundary = boundary)

    ## Sort by Date
    setorder(x, datum)

    return(x)
    
}
