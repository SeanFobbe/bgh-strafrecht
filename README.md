# Historische Entscheidungen des Bundesgerichtshofs für Strafsachen (BGH-Strafrecht)



## Set up

### Install R packages

To install all R packages in the required version, please use the following command in an R console in the project directory:

```
renv::restore()
```

### Clone Submodule

To set up the submodule you need to run:

```
git submodule update --init --recursive
```


To update the submodule you need to run: 

```
git submodule foreach git pull origin main
```


## Structure

The code converts and analyzed the files from original to final data set in the following order:

### Originals

- `zip_original` The original ZIP files.
- `pdf_original` The original PDF files, unzipped.

### Tesseract Step

- `pdf_tesseract` PDF files with enhanced Tesserac text layer.
- `txt_tesseract` TXT files extracted with Tesseract.

### Cleaning Step

- `txt_cleaned` The cleaned TXT files

### Output

The folder `output` contains the following final products:

- CSV_Full
- CSV_Meta
- TXT_Full
- PDF_Enhanced
