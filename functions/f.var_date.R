#' f.var_date
#'
#' Extract a date in a specified format from the beginning of a text.
#'
#' @param x String. A vector of texts.
#' @param limit Integer. The number of characters from 1 to limit to be checked for a date.
#'
#' @return Date. A vector of dates in ISO format (e.g. 2024-01-03).






f.var_date <- function(x,
                       limit = 2000){

    reduced <- substr(x, 1, limit)

    months.german <- c("Januar", "Februar", "März", "April", "Mai", "Juni",
                       "Juli", "August", "September", "Oktober", "November", "Dezember")
    
    date.string <- stringi::stri_extract_first(str = reduced,
                                               regex = paste0("(Sitzung| Beschluss|Beschluß|Urteil)",
                                                              "\\s*vom\\s*",
                                                              "[0-9]{1,2}\\.\\s*",
                                                              "(",
                                                              paste0(months.german,
                                                                     collapse = "|"),
                                                              ")\\s*",
                                                              "[0-9]{4}"))

    date.string <- stringi::stri_replace_all(str = date.string,
                                             regex = "\\s+",
                                             replacement = " ")

    date.string <- trimws(date.string)



    date.string <- stringi::stri_replace_all(str = date.string,
                                             regex = ".+ vom ",
                                             replacement = "")

    date.string <- stringi::stri_replace_all(str = date.string,
                                             regex = paste0(" *", months.german, " *"),
                                             replacement = paste0(formatC(1:12,
                                                                          width = 2,
                                                                          flag = "0"),
                                                                  "."),
                                             vectorize_all = FALSE)


    date.string <- stringi::stri_replace_all(str = date.string,
                                             regex = "^([0-9])\\.",
                                             replacement = "0$1\\.")

    date <- as.Date(date.string, format =  c("%d.%m.%Y"))
        
   
    
    return(date)
    
}


## DEBUGGING CODE

## date <- f.var_date(x, limit = 5000)

## length(na.omit(date))


## unique(date)


## date.ordered[1:200]
    
## date.string[1:400]
    
    
