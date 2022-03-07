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
#+
#'# Einleitung
#'
#+
#'## Überblick
#' Dieses R-Skript lädt alle in der amtlichen Datenbank des Bundesgerichtshofs\footnote{\url{https://www.bundesgerichtshof.de}} veröffentlichten Entscheidungen des Bundesgerichtshofs (BGH) herunter und kompiliert sie in einen reichhaltigen menschen- und maschinenlesbaren Korpus. Es ist die Basis für den \textbf{\datatitle\ (\datashort )}.
#'
#' Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Alle Versionen sind mit einem persistenten Digital Object Identifier (DOI) versehen. Die neueste Version des Datensatzes ist immer über diesen Link erreichbar: \dataconcepturldoi

#+
#'## Funktionsweise

#' Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
#' \begin{enumerate}
#' \item Der volle Datensatz im CSV-Format (mit zusätzlichen Metadaten)
#' \item Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne Entscheidungsinhalte)
#' \item Alle Entscheidungen im TXT-Format
#' \item Alle Entscheidungen im PDF-Format
#' \item Nur Leitsatz-Entscheidungen im PDF-Format
#' \item Nur benannte Entscheidungen im PDF-Format
#' \item Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
#' \end{enumerate}
#'
#' Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. Weiterhin kann optional ein PDF-Bericht erstellt werden (siehe unter "Kompilierung").


#+
#'## Systemanforderungen
#' Das Skript in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da es Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Das Skript wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem **sessionInfo()**-Ausdruck am Ende dieses Berichts.
#'
#' In der Standard-Einstellung wird das Skript vollautomatisch versuchen die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Wenn die Anzahl Threads (Variable "fullCores") auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.
#'
#' Auf der Festplatte sollten 20 GB Speicherplatz vorhanden sein.
#' 
#' Um die PDF-Berichte kompilieren zu können benötigen Sie das R package **rmarkdown**, eine vollständige Installation von \LaTeX\ und alle in der Präambel-TEX-Datei angegebenen \LaTeX\ Packages.


#+
#'## Kompilierung
#' Mit der Funktion **render()** von **rmarkdown** können der **vollständige Datensatz** und das **Codebook** kompiliert und die Skripte mitsamt ihrer Rechenergebnisse in ein gut lesbares PDF-Format überführt werden.
#'
#' Alle Kommentare sind im roxygen2-Stil gehalten. Die beiden Skripte können daher auch **ohne render()** regulär als R-Skripte ausgeführt werden. Es wird in diesem Fall kein PDF-Bericht erstellt und Diagramme werden nicht abgespeichert.

#+
#'### Datensatz 
#' 
#' Um den **vollständigen Datensatz** zu kompilieren und einen PDF-Bericht zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen mit R diesen Befehl aus:

#+ eval = FALSE

rmarkdown::render(input = "CE-BGH_Source_CorpusCreation.R",
                  output_file = paste0("CE-BGH_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"),
                  envir = new.env())


#'### Codebook
#' Um das **Codebook** zu kompilieren und einen PDF-Bericht zu erstellen führen Sie bitte im Anschluss an die Kompilierung des Datensatzes untenstehenden Befehl mit R aus.
#'
#' Bei der Prüfung der GPG-Signatur wird ein Fehler auftreten und im Codebook dokumentiert, weil die Daten nicht mit meiner Original-Signatur versehen sind. Dieser Fehler hat jedoch keine Auswirkungen auf die Funktionalität und hindert die Kompilierung nicht.

#+ eval = FALSE

rmarkdown::render(input = "CE-BGH_Source_CodebookCreation.R",
                  output_file = paste0("CE-BGH_",
                                       Sys.Date(),
                                       "_Codebook.pdf"),
                  envir = new.env())



### REMOVE LATER TEST
setwd("~/bgh project/workdir")



#'\newpage
#+
#'# Parameter

#+
#'## Name des Datensatzes
datasetname <- "BGH-Straf-Historisch"

#'## DOI des Datensatz-Konzeptes
doi.concept <- "???" # checked

#'## DOI der konkreten Version
doi.version <- "???" # checked

#'## Lizenz
license <- "Creative Commons Zero 1.0 Universal"


#'## Verzeichnis für Analyse-Ergebnisse
#' Muss mit einem Schrägstrich enden!

outputdir <- paste0(getwd(),
                    "/ANALYSE/") 





#'## Optionen: Quanteda
tokens_locale <- "de_DE"



#'## Optionen: Knitr

#+
#'### Ausgabe-Format
dev <- c("pdf",
         "png")


#'### DPI für Raster-Grafiken
dpi <- 300


#'### Ausrichtung von Grafiken im Compilation Report
fig.align <- "center"





#'## Frequenztabellen: Ignorierte Variablen

#' Diese Variablen werden bei der Erstellung der Frequenztabellen nicht berücksichtigt.

varremove <- c("text",
               "eingangsnummer",
               "datum",
               "doc_id",
               "ecli",
               "aktenzeichen",
               "name",
               "bemerkung")





#'# Vorbereitung

#'## Datumsstempel
#' Dieser Datumsstempel wird in alle Dateinamen eingefügt. Er wird am Anfang des Skripts gesetzt, für den Fall, dass die Laufzeit die Datumsbarriere durchbricht.
datestamp <- Sys.Date()
print(datestamp)

#'## Datum und Uhrzeit (Beginn)
begin.script <- Sys.time()
print(begin.script)

#'## Ordner für Analyse-Ergebnisse erstellen
dir.create(outputdir)


#+
#'## Packages Laden

library(fs)           # Verbessertes File Handling
library(mgsub)        # Vektorisiertes Gsub
library(httr)         # HTTP-Werkzeuge
library(rvest)        # HTML/XML-Extraktion
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Kable Tabellen
library(pdftools)     # Verarbeitung von PDF-Dateien
library(doParallel)   # Parallelisierung
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung
library(readtext)     # TXT-Dateien einlesen
library(quanteda)     # Fortgeschrittene Computerlinguistik



#'## Zusätzliche Funktionen einlesen
#' **Hinweis:** Die hieraus verwendeten Funktionen werden jeweils vor der ersten Benutzung in vollem Umfang angezeigt um den Lesefluss zu verbessern.

source("~/github/R-fobbe-proto-package/f.dopar.pdfocr.R")



#'## Quanteda-Optionen setzen
quanteda_options(tokens_locale = tokens_locale)


#'## Knitr Optionen setzen
knitr::opts_chunk$set(fig.path = outputdir,
                      dev = dev,
                      dpi = dpi,
                      fig.align = fig.align)



#'## Vollzitate statistischer Software
knitr::write_bib(c(.packages()),
                 "packages.bib")


#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung der Konvertierung von PDF zu TXT und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben auf das eigene System angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable **fullCores** auf 1 gesetzt wird.
#'
#' Der Download der Daten ist bewusst nicht parallelisiert, damit das Skript nicht versehentlich als DoS-Tool verwendet wird.
#'
#' Die hier verwendete Funktion **makeForkCluster()** ist viel schneller als die Alternativen, funktioniert aber nur auf Unix-basierten Systemen (Linux, MacOS).

#+
#'### Logische Kerne (Anzahl)

fullCores <- detectCores()
print(fullCores)

#'### Quanteda
quanteda_options(threads = fullCores) 

#+
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
