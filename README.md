# Entscheidungen des Bundesgerichtshofs in Strafsachen aus dem 20. Jahrhundert (BGH-Strafsachen-20Jhd)


## Überblick

Der Datensatz **Entscheidungen des Bundesgerichtshofs in Strafsachen aus dem 20. Jahrhundert (BGH-Strafsachen-20Jhd)** ist eine möglichst vollständige Sammlung der durch den Bundesgerichtshof in Strafsachen getroffenen Entscheidungen vom 1. Oktober 1950 (Gründung des BGH) bis zum 1. Januar 2000, dem Zeitpunkt ab dem der BGH digitale Entscheidungen regulär veröffentlicht. 

Der Datensatz nutzt als seine Datenquelle eine vom Bundesgerichtshof den Autoren übergebene digitale Sammlung dieser Entscheidungen und bereitet diese wissenschaftlich auf.

Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Alle Versionen sind mit einem separaten und langzeit-stabilen (persistenten) Digital Object Identifier (DOI) versehen.

Aktuellster, funktionaler und zitierfähiger Release des Datensatzes: <https://doi.org/10.5281/zenodo.4540377>



## Features

- Bereinigung der Dateinamen
- Korrektur falscher Rotationen, Standardisierung im Hochformat
- Optische Zeichenerkennung (OCR)
- Automatisierte Bereinigung von OCR-Fehlern mit Ersetzungstabelle
- Extraktion zusätzlicher Variablen
- Erstellung nutzungsfertiger ZIP-Archive
- Umfangreiche Dokumentation
- Automatisierte Unit Tests und statistisches Reporting
- Kryptographische Signaturen


## Ergebnisse

Primäre Endprodukte des Skripts sind folgende ZIP-Archive:

- Der volle Datensatz im CSV-Format (mit zusätzlichen Metadaten)
- Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne Entscheidungsinhalte)
- Alle Entscheidungen im TXT-Format
- Alle Entscheidungen im PDF-Format
- Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)

Alle Ergebnisse werden im Ordner `output` abgelegt. Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. 




## Systemanforderungen

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- 34 GB Speicherplatz auf Festplatte
- 32 GB Arbeitsspeicher (RAM)
- Multi-core CPU empfohlen (8 cores/16 threads für die Referenzdatensätze). 

In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Die Anzahl der verwendeten Kerne kann in der Konfigurationsatei angepasst werden. Wenn die Anzahl Threads auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.



## Anleitung


### Schritt 1: Ordner vorbereiten

Kopieren Sie bitte den gesamten Source Code in einen leeren Ordner (!), beispielsweise mit:

```
$ git clone https://github.com/seanfobbe/bgh-strafrecht
```

Verwenden Sie immer einen separaten und *leeren* Ordner für die Kompilierung. Die Skripte löschen innerhalb von bestimmten Unterordnern (`files/`, `temp/`, `analysis` und `output/`) alle Dateien die den Datensatz verunreinigen könnten --- aber auch nur dort.



### Schritt 2: Docker Image erstellen

Ein Docker Image stellt ein komplettes Betriebssystem mit der gesamten verwendeten Software automatisch zusammen. Nutzen Sie zur Erstellung des Images einfach:

```
$ bash docker-build-image.sh
```




### Schritt 3: Datensatz kompilieren

Falls Sie zuvor den Datensatz schon einmal kompiliert haben (ob erfolgreich oder erfolglos), können Sie mit folgendem Befehl alle Arbeitsdaten im Ordner löschen:

```
$ Rscript delete_all_data.R
```

Den vollständigen Datensatz kompilieren Sie mit folgendem Skript:

```
$ bash docker-run-project.sh
```





### Ergebnis

Der Datensatz und alle weiteren Ergebnisse sind nun im Ordner `output/` abgelegt.






## Pipeline visualisieren

Sie können die Pipeline visualisieren, aber nur nachdem sie die zentrale .Rmd-Datei mindestens einmal gerendert haben:

```
> targets::tar_glimpse()     # Nur Datenobjekte
> targets::tar_visnetwork()  # Alle Objekte
```





## Troubleshooting

Hilfreiche Befehle um Fehler zu lokalisieren und zu beheben.

```
> tar_progress()  # Zeigt Fortschritt und Fehler an
> tar_meta()      # Alle Metadaten
> tar_meta(fields = "warnings", complete_only = TRUE)  # Warnungen
> tar_meta(fields = "error", complete_only = TRUE)  # Fehlermeldungen
> tar_meta(fields = "seconds")  # Laufzeit der Targets
```




## Projektstruktur

Die folgende Struktur erläutert die wichtigsten Bestandteile des Projekts. Während der Kompilierung werden weitere Ordner erstellt (`files/`, `temp/` `analysis` und `output/`). Die Endergebnisse werden alle in `output/` abgelegt.


``` 
.
├── buttons                    # Buttons (nur optische Bedeutung)
├── CHANGELOG.md               # Alle Änderungen
├── config.toml                # Zentrale Konfigurations-Datei
├── data                       # Datensätze, auf denen die Pipeline aufbaut
├── delete_all_data.R          # Löscht den Datensatz und Zwischenschritte
├── docker-build-image.sh      # Docker Image erstellen
├── docker-compose.yaml        # Konfiguration für Docker
├── docker-delete-all-data.sh  # Löschen aller Datein aus Docker heraus
├── Dockerfile                 # Definition des Docker Images
├── docker-run-project.sh      # Docker Image und Datensatz kompilieren
├── etc                        # Zusätzliche Konfigurationsdateien
├── functions                  # Wichtige Schritte der Pipeline
├── gpg                        # Persönlicher Public GPG-Key für Seán Fobbe
├── pipeline.Rmd               # Zentrale Definition der Pipeline
├── README.md                  # Bedienungsanleitung
├── reports                    # Markdown-Dateien
├── run_project.R              # Kompiliert den gesamten Datensatz
└── tex                        # LaTeX-Templates

``` 

 
## Persönliche Webseiten der Autor:innen

Seán Fobbe — https://www.seanfobbe.de

Tilko Swalve — https://tilkoswalve.netlify.app/



## Kontakt

Fehler gefunden? Anregungen? Kommentieren Sie gerne im Issue Tracker auf GitHub oder kontaktieren sie mich via https://www.seanfobbe.de 
