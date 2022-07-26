


f.tar_pdf_ocr <- function(x,
                          dpi = 300,
                          lang = "eng",
                          output = "pdf txt",
                          dir.out.pdf = "pdf_tesseract",
                          dir.out.txt = "txt_tesseract",
                          quiet = TRUE,
                          jobs = parallel::detectCores()){

    dir.create("temp_tesseract")

    plan(multicore,
         workers = jobs)


    f.future_pdf_ocr(x = x,
                     dpi = dpi,
                     lang = lang,
                     output = output,
                     outputdir = "temp_tesseract",
                     quiet = quiet)



    

}
