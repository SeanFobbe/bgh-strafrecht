# Run full pipeline

dir.out <- "output"

dir.create(dir.out, showWarnings = FALSE)

rmarkdown::render("pipeline.Rmd",
                  output_file = file.path(dir.out,
                                          paste0("BGH-Strafrecht_",
                                                 Sys.Date(),
                                                 "_CompilationReport.pdf")))

