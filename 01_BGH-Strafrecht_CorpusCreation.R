#'---
#'title: "Source Code des Corpus der Entscheidungen des Bundesgerichtshofs (CE-BGH-Source)"
#'author: Seán Fobbe
#'geometry: margin=3cm
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CE-BGH_Source_TEX_Definitions.tex,CE-BGH_Source_TEX_CompilationTitle.tex]
#'papersize: a4
#'bibliography: packages.bib
#'nocite: '@*'
#' ---


#+ echo = FALSE 
knitr::opts_chunk$set(echo = TRUE,
                      warning = TRUE,
                      message = TRUE)


#'\newpage

#+ results = "asis", echo = FALSE
cat(readLines("README.md"),
    sep = "\n")





#'# Vorbereitung

#'## Datumsstempel
#' Dieser Datumsstempel wird in alle Dateinamen eingefügt. Er wird am Anfang des Skripts gesetzt, für den den Fall, dass die Laufzeit die Datumsbarriere durchbricht.

datestamp <- Sys.Date()
print(datestamp)


#'## Datum und Uhrzeit (Beginn)
begin.script <- Sys.time()
print(begin.script)





#+
#'## Packages Laden

library(fs)           # Verbessertes File Handling
library(RcppTOML)     # Verarbeitung von TOML-Format
library(mgsub)        # Mehrfache simultane String-Substitutions
library(httr)         # HTTP-Werkzeuge
library(rvest)        # HTML/XML-Extraktion
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Kable Tabellen
library(pdftools)     # Verarbeitung von PDF-Dateien
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung
library(readtext)     # TXT-Dateien einlesen
library(quanteda)     # Fortgeschrittene Computerlinguistik
library(spacyr)       # Linguistische Annotationen
library(future)       # Parallelisierung mit Futures
library(future.apply) # Apply-Funtionen für Futures




#'## Zusätzliche Funktionen einlesen
#' **Hinweis:** Die hieraus verwendeten Funktionen werden jeweils vor der ersten Benutzung in vollem Umfang angezeigt um den Lesefluss zu verbessern.

source("R-fobbe-proto-package/f.dopar.pdfocr.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")

source("R-fobbe-proto-package/f.future_lingsummarize.R")
source("R-fobbe-proto-package/f.future_multihashes.R")
source("R-fobbe-proto-package/f.future_pdf_to_txt.R")





#'## Verzeichnis für Analyse-Ergebnisse und Diagramme definieren

dir.analysis <- paste0(getwd(),
                    "/analyse") 


#'## Weitere Verzeichnisse definieren

dirs <- c("output",
          "temp",
          ## "txt_tesseract", # skip during devel
          "pdf_tesseract",
          "txt_cleaned")



#'## Dateien aus vorherigen Runs bereinigen

unlink(dir.analysis,
       recursive = TRUE)

unlink(dirs,
       recursive = TRUE)

files.delete <- list.files(pattern = "\\.zip|\\.pdf|\\.txt|\\.html",
                           ignore.case = TRUE)

unlink(files.delete)




#'## Verzeichnisse anlegen

dir.create(dir.analysis)

lapply(dirs, dir.create)




#'## Vollzitate statistischer Software schreiben
knitr::write_bib(c(.packages()),
                 "temp/packages.bib")





#'## Allgemeine Konfiguration

#+
#'### Konfiguration einlesen
config <- parseTOML("BGH-Strafrecht_Config.toml")

#'### Konfiguration anzeigen
print(config)



#+
#'### Knitr Optionen setzen
knitr::opts_chunk$set(fig.path = paste0(dir.analysis, "/"),
                      dev = config$fig$format,
                      dpi = config$fig$dpi,
                      fig.align = config$fig$align)


#'### Download Timeout setzen
options(timeout = config$download$timeout)



#'### Quellenangabe für Diagramme definieren

caption <- paste("Fobbe/Swalve | DOI:",
                 config$doi$data$version)
print(caption)


#'### Präfix für Dateien definieren

prefix.files <- paste0(config$project$shortname,
                 "_",
                 datestamp)
print(prefix.files)


#'### Präfix für Diagramme definieren

prefix.figuretitle <- paste(config$project$shortname,
                            "| Version",
                            datestamp)


#'### Quanteda-Optionen setzen
quanteda_options(tokens_locale = config$quanteda$tokens_locale)




#'## LaTeX Konfiguration

#+
#'### Funktion definieren


latexcommand <- function(command.name,
                         command.body){

    newcommand <- paste0("\\newcommand{\\",
                         command.name,
                         "}{",
                         command.body,
                         "}")

    return(newcommand)
    
    }



#+
#'### LaTeX Parameter definieren

latexdefs <- c("%===========================\n% Definitionen\n%===========================",
               "\n% NOTE: Diese Datei wurde während des Kompilierungs-Prozesses automatisch erstellt.\n",
               "\n%-----Autor-----",
               paste0("\\newcommand{\\projectauthor}{",
                      config$project$author,
                      "}"),
               "\n%-----Version-----",
               paste0("\\newcommand{\\version}{",
                      datestamp,
                      "}"),
               "\n%-----Titles-----",
               paste0("\\newcommand{\\datatitle}{",
                      config$project$fullname,
                      "}"),
               paste0("\\newcommand{\\datashort}{",
                      config$project$shortname,
                      "}"),
               paste0("\\newcommand{\\softwaretitle}{Source Code des \\enquote{",
                      config$project$fullname,
                      "}}"),
               paste0("\\newcommand{\\softwareshort}{",
                      config$project$shortname,
                      "-Source}"),
               "\n%-----Data DOIs-----",
               paste0("\\newcommand{\\dataconceptdoi}{",
                      config$doi$data$concept,
                      "}"),
               paste0("\\newcommand{\\dataversiondoi}{",
                      config$doi$data$version,
                      "}"),
               paste0("\\newcommand{\\dataconcepturldoi}{https://doi.org/",
                      config$doi$data$concept,
                      "}"),
               paste0("\\newcommand{\\dataversionurldoi}{https://doi.org/",
                      config$doi$data$version,
                      "}"),
               "\n%-----Software DOIs-----",
               paste0("\\newcommand{\\softwareconceptdoi}{",
                      config$doi$software$concept,
                      "}"),
               paste0("\\newcommand{\\softwareversiondoi}{",
                      config$doi$software$version,
                      "}"),
               paste0("\\newcommand{\\softwareconcepturldoi}{https://doi.org/",
                      config$doi$software$concept,
                      "}"),
               paste0("\\newcommand{\\softwareversionurldoi}{https://doi.org/",
                      config$doi$software$version,
                      "}"),
               "\n%-----Additional DOIs-----",
               paste0("\\newcommand{\\aktenzeichenurldoi}{https://doi.org/",
                      config$doi$aktenzeichen,
                      "}"),
               paste0("\\newcommand{\\personendatenurldoi}{https://doi.org/",
                      config$doi$personendaten,
                      "}"))




#'### LaTeX Parameter schreiben

writeLines(latexdefs,
           paste0("temp/",
                  config$project$shortname,
                  "_Definitions.tex"))






#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung der Konvertierung von PDF zu TXT und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben auf das eigene System angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable **fullCores** auf 1 gesetzt wird.



#+
#'### Anzahl logischer Kerne festlegen

if (config$cores$max == TRUE){
    fullCores <- availableCores()
}


if (config$cores$max == FALSE){
    fullCores <- as.integer(config$cores$number)
}



print(fullCores)

#'### Quanteda
quanteda_options(threads = fullCores) 

#'### Data.table
setDTthreads(threads = fullCores)  









library(fs)

x <- list.files()


lapply(x, unzip)



list.files()[1:300]

library(zip)

mac <- list.files(pattern="MACOS", include.dirs=TRUE, recursive =TRUE, full.names=TRUE)

length(mac)

unlink(mac)


zip <- list.files(pattern="\\.zip")
unlink(zip)



all <- list.files(pattern="\\.pdf", ignore.case=TRUE)
length(all)

file.copy(all, "../../BGH-PDF-RAW")


zip("BGH_50-99.zip", all)
file.copy("BGH_50-99.zip", "../")




unzip("BGH_50-99.zip")





### test

BGH_I_LE_2007-10-04_I_ZR_22_05_NA_Umsatzsteuerhinweis_0.pdf



test <- list.files(pattern = "\\(S\\)", ignore.case = TRUE)
file.copy(test, "../")


### rename



filenames.old <- list.files(pattern = "\\.pdf", ignore.case = TRUE)


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


filenames.new[sample(length(filenames.new), 100)]


#'## REGEX TEST 1

grep("[0-9]_((StR)|(ARS))_[0-9]{1,4}_[0-9]{2}_[A-Za-z]+_NA_[a-zA-Z]+\\.pdf",
     filenames.new,
     invert = TRUE,
     value = TRUE)



#'## EXECUTE RENAME---CAREFUL


file.rename(filenames.old,
            filenames.new)


## alternative - hopefully faster
#file_move(filenames.old,
#          filenames.new)




#'## REGEX TEST 2

filenames.current <- list.files(pattern = "\\.pdf",
                                ignore.case = TRUE)

grep("[0-9]_((StR)|(ARS))_[0-9]{1,4}_[0-9]{2}_[A-Za-z]+_NA_[a-zA-Z]+\\.pdf",
     filenames.current,
     invert = TRUE,
     value = TRUE)


#'## OCR


f.dopar.pdfocr(filenames.current,
               dpi = 300,
               lang = "deu",
               jobs = 5)



zip("BGH_TXT_Tesseract.zip",
    "TXT_Tesseract")
