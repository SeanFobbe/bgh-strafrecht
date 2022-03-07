setwd("BGH_94-99/PDF")

files.old <- list.files("./")

files  <- gsub("-", "_", files.old)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("___", "_", files)
files  <- gsub("PDF", "pdf", files)
files  <- gsub("ok.pdf", "pdf", files)
files  <- gsub(".pdf", "_NA.pdf", files)
files  <- gsub("a_NA", "_a", files)
files  <- gsub("b_NA", "_b", files)
files  <- gsub("c_NA", "_c", files)
files  <- gsub("d_NA", "_d", files)
files  <- gsub("A_NA", "_a", files)
files  <- gsub("B_NA", "_b", files)
files  <- gsub("C_NA", "_c", files)
files  <- gsub("D_NA", "_d", files)
files  <- gsub("stR", "StR", files)
files  <- gsub("nurBBes_NA", "_Berichtigung", files)

files <- paste0("BGH_NA_NA_", files)

grep("BGH_NA_NA_[0-9]_(StR)|(ARS)_[0-9]*_[0-9]*_[a-zA-Z]*.pdf", files, invert=TRUE, value=TRUE)

print(files)

length(files.old)
length(files)

file.rename(files.old, files)








setwd("BGH_88-93")

files.old <- list.files("./")

files  <- gsub("-", "_", files.old)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("___", "_", files)
files  <- gsub("PDF", "pdf", files)
files  <- gsub("ok.pdf", "pdf", files)
files  <- gsub(".pdf", "_NA.pdf", files)
files  <- gsub("a_NA", "_a", files)
files  <- gsub("b_NA", "_b", files)
files  <- gsub("c_NA", "_c", files)
files  <- gsub("A_NA", "_a", files)
files  <- gsub("B_NA", "_b", files)
files  <- gsub("C_NA", "_c", files)
files  <- gsub("nurBBes_NA", "_Berichtigung", files)



files <- paste0("BGH_NA_NA_", files)

grep("BGH_NA_NA_[0-9]_StR_[0-9]*_[0-9]*_[a-zA-Z]*.pdf", files, invert=TRUE, value=TRUE)

print(files)

file.rename(files.old, files)




setwd("..")
setwd("BGH_82-87")

files.old <- list.files("./")

files  <- gsub("-", "_", files.old)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("\\_\\_", "_", files)
files  <- gsub("___", "_", files)
files  <- gsub("PDF", "pdf", files)
files  <- gsub("ok.pdf", "pdf", files)
files  <- gsub(".pdf", "_NA_NA.pdf", files)
files  <- gsub("a_NA_NA", "_NA_a", files)
files  <- gsub("b_NA_NA", "_NA_b", files)
files  <- gsub("c_NA_NA", "_NA_c", files)
files  <- gsub("d_NA_NA", "_NA_d", files)
#files  <- gsub("A_NA", "_a", files)
#files  <- gsub("B_NA", "_b", files)
#files  <- gsub("C_NA", "_c", files)
#files  <- gsub("D_NA", "_d", files)
files  <- gsub("stR", "StR", files)
files  <- gsub("\\(S\\)_NA", "S", files)
files  <- gsub("nurBBes_NA", "_Berichtigung", files)

files <- paste0("BGH_NA_NA_", files)

grep("BGH_NA_NA_[0-9]_[A-Za-z]*_[0-9]*_[0-9]*_[A-Za-z]*_[A-Za-z]*.pdf", files, invert=TRUE, value=TRUE)

grep("\\(S\\)", files.old, invert=TRUE, value=TRUE)

print(files)

length(files.old)
length(files)

file.rename(files.old, files)

