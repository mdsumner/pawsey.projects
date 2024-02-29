library(furrr)
library(curl)
library(purrr)
library(tibble)

get_file_db <- function(x, ...) {
  furrr::future_map_chr(purrr::transpose(x), down_load_url_filename, ...)
}

home <- "/scratch/pawsey0973/mdsumner/data/idea/"

## create file list
dates <- seq(as.Date("1978-10-26"), Sys.Date(), by = "1 day")

files <- tibble::tibble(url = map_chr(dates, sds::nsidc_seaice, vsi = FALSE), filename = gsub("^https://", home, url))

down_load_url_filename <- function(x, overwrite = FALSE) {
  if (!overwrite) {
    if (fs::file_exists(x$filename)) {
      return(x$filename)
    }
  }
  dir <- fs::path_dir(x$filename)
  if (!fs::dir_exists(dir)) fs::dir_create(dir, recurse = TRUE)
  res <- try(curl::curl_download(x$url[1L], x$filename[1L]), silent = TRUE)
  if (inherits(res, "try-error")) return(NA_character_)
  x$filename[1]
}




plan(multicore)
system.time({
fls <- get_file_db(files, overwrite = FALSE)
})
plan(sequential)


