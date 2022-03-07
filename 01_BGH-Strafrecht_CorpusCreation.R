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
library(zip) # Cross-platform ZIP archive creation/extraction



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
          "pdf_original", 
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
               latexcommand("projectauthor", config$project$author),
               "\n%-----Version-----",
               latexcommand("version", datestamp),
               "\n%-----Titles-----",
               latexcommand("datatitle", config$project$fullname),
               latexcommand("datashort", config$project$shortname),
               latexcommand("softwaretitle",
                            paste0("Source Code des \\enquote{", config$project$fullname, "}")),
               latexcommand("softwareshort", paste0(config$project$shortname, "-Source")),
               "\n%-----Data DOIs-----",
               latexcommand("dataconceptdoi", config$doi$data$concept), 
               latexcommand("dataversiondoi", config$doi$data$version),
               latexcommand("dataconcepturldoi",
                            paste0("https://doi.org/", config$doi$data$concept)),
               latexcommand("dataversionurldoi",
                            paste0("https://doi.org/", config$doi$data$version)),
               "\n%-----Software DOIs-----",
               latexcommand("softwareconceptdoi", config$doi$software$concept),
               latexcommand("softwareversiondoi", config$doi$software$version), 
               latexcommand("softwareconcepturldoi",
                            paste0("https://doi.org/", config$doi$software$concept)),
               latexcommand("softwareversionurldoi",
                            paste0("https://doi.org/", config$doi$software$version)),
               "\n%-----Additional DOIs-----",
               latexcommand("aktenzeichenurldoi",
                            paste0("https://doi.org/", config$doi$aktenzeichen)),
               latexcommand("personendatenurldoi",
                            paste0("https://doi.org/", config$doi$personendaten))
               )





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









#'# Download: Weitere Datensätze

#+
#'## Registerzeichen und Verfahrensarten
#'Die Registerzeichen werden im Laufe des Skripts mit ihren detaillierten Bedeutungen aus dem folgenden Datensatz abgeglichen: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564." Das Ergebnis des Abgleichs wird in der Variable "verfahrensart" in den Datensatz eingefügt.


if (file.exists("data/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv") == FALSE){
    download.file("https://zenodo.org/record/4569564/files/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv?download=1",
 "data/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv")
    }



#'## Personendaten zu Präsident:innen
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.


if (file.exists("data/PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv?download=1",
                  "data/PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv")
}




#'## Personendaten zu Vize-Präsident:innen
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.


if (file.exists("data/PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv?download=1",
                  "data/PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv")
}







#'# Prepare Original PDF Files

#+
#'## Extract from ZIP

files.zip <- list.files("zip_original",
                        full.names = TRUE)


mapply(unzip,
       zipfile = files.zip,
       exdir = "pdf_original")

#'## [Debugging Mode]: Reduce Load

if(config$debug$toggle == TRUE){

    files.pdf <- list.files("pdf_original",
                            full.names = TRUE)

    files.delete <- files.pdf[-sample(length(files.pdf), config$debug$sample)]
    
    unlink(files.delete)
    
}



#'## Rename

#+
#'### Modify Filenames

filenames.old <- list.files("pdf_original",
                            pattern = "\\.pdf",
                            ignore.case = TRUE)


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

#'### Show Sample of Results

filenames.new[sample(length(filenames.new), 100)]


#'### REGEX TEST 1

grep("[0-9]_((StR)|(ARS))_[0-9]{1,4}_[0-9]{2}_[A-Za-z]+_NA_[a-zA-Z]+\\.pdf",
     filenames.new,
     invert = TRUE,
     value = TRUE)



#'### EXECUTE RENAME---CAREFUL


file.rename(file.path("pdf_original", filenames.old),
            file.path("pdf_original", filenames.new))







#'# Tesseract OCR step




if (config$tesseract$skip == FALSE){


files.pdf <- list.files(pattern = "\\.pdf",
                        ignore.case = TRUE)
    
f.dopar.pdfocr(filenames.current,
               dpi = 300,
               lang = "deu",
               jobs = 5)

    }






#'# Cleaning Step


#'## Read files

files.txt <- list.files("txt_tesseract",
                        full.names = TRUE)[1:50] # testing restriction


txt.bgh <- readtext(files.txt,
                    docvarsfrom = "filenames", 
                    docvarnames = c("spruchkoerper_az",
                                    "registerzeichen",
                                    "eingangsnummer",
                                    "eingangsjahr_az",
                                    "zusatz_az",
                                    "name",
                                    "kollision"),
                    dvsep = "_", 
                    encoding = "UTF-8")




#'## In Data Table umwandeln
setDT(txt.bgh)


#'## Perform Cleaning: Remove Hyphens

#'### Funktion anzeigen
print(f.hyphen.remove)

#'### Funktion ausführen
txt.bgh[, text := lapply(.(text), f.hyphen.remove)]



#'## Perform Cleaning: Correct Errors


#'### Read Replacement Table

fread("data/BGH-Strafrecht_ReplacementTable.csv")

#'### Funktion anzeigen
print(mgsub_clean)

#'### Funktion ausführen
txt.bgh[, text := lapply(.(text), mgsub_clean)]



























#'# Abschluss

#+
#'## Datumsstempel
print(datestamp)


#'## Datum und Uhrzeit (Anfang)
print(begin.script)


#'## Datum und Uhrzeit (Ende)
end.script <- Sys.time()
print(end.script)


#'## Laufzeit des gesamten Skriptes
print(end.script - begin.script)


#'## Warnungen
warnings()



#'# Parameter für strenge Replikationen

system2("openssl", "version", stdout = TRUE)

sessionInfo()


#'# Literaturverzeichnis

