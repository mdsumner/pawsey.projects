library(arrow)
files <- read_parquet("https://github.com/mdsumner/idea_sources_public/raw/main/idea_sources_public.parquet")


pattern <- c("avhrr", "^.*www.ncei.noaa.gov.*sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/.*\\.nc$")

for (pat in pattern) {
  files <- dplyr::filter(files, stringr::str_detect(file, pat))
}

if (nrow(files) < 1) {
  stop("no files found")
}
files <- dplyr::mutate(files, date = as.POSIXct(as.Date(stringr::str_extract(basename(.data$file), 
                                                                             "[0-9]{8}"), "%Y%m%d"), tz = "UTC"))
files <- dplyr::arrange(dplyr::distinct(files, date, .keep_all = TRUE), date) |> dplyr::mutate(url = sprintf("https://%s", file))
range(files$date)




pathname <- function(x) {
  root <- file.path(Sys.getenv("MYSCRATCH"), "data", "idea")
  gsub("nc$", "tif", gsub("https:/", root, x))
}


files$out_dsn <- pathname(files$url)

convert <- function(dsn, out_dsn) {
  dsnx <- sprintf("vrt:///vsicurl/%s?sd_name=sst&a_srs=EPSG:4326&unscale=true", dsn)

  dir <- dirname(out_dsn)
  if (!fs::dir_exists(dir)) fs::dir_create(dir)
#  print(dir)
#  print(fs::dir_exists(dir))

  task <- vapour::gdal_raster_dsn(dsnx, out_dsn = out_dsn, options = "-overwrite", target_ext = c(-180, 180, -90, 90))
 NULL
}


files <- tibble::tibble(dsn = files$url, out_dsn = files$out_dsn)
library(rslurm)
sjob <- slurm_apply(convert, files, jobname = 'write_apply',
                    nodes = 12, cpus_per_node = 128, submit = FALSE, pkgs = NULL)


