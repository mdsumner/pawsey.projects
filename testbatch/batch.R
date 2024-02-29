
print("nworkers: ")
print(length(parallelly::availableWorkers()))

library(curl)
library(arrow)
library(furrr)
library(stringr)

oisst <- read_parquet("https://github.com/mdsumner/trend.oisst/raw/main/oisstfiles.parquet")

dsn <- gsub("///", "//", oisst$dsn)
url <- str_extract(dsn, "https.*nc")


dir <- file.path(Sys.getenv("MYSCRATCH"), "oisst")

dl <- function(x) {
  curl_download(x, file.path(dir, basename(x)))
}

future_map(url[1:10], dl)
print("done")

 
