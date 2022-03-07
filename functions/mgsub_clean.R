mgsub_clean <- function(text,
                        replacement.table){

    out <- mgsub::mgsub(text,
                        replacement.table$pattern,
                        replacement.table$replacement)

    return(out)

}
