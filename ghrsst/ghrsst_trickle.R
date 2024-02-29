

template = "https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/MUR-JPL-L4-GLOB-v4.1/{ymd}090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc"
template2 = "https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/MUR-JPL-L4-GLOB-v4.1/{year}/{mon}/{ymd}090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc"


dates <- seq(as.Date("2002-06-01"), Sys.Date(), by = "1 day")
pathname <- function(x) {
  root <- file.path(Sys.getenv("MYSCRATCH"), "data", "idea")
  gsub("nc$", "tif", gsub("https:/", root, x))
}



convert <- function(dsn, out_dsn, overwrite = FALSE) {
## don't change input extent, just let bilinear remodel slightly to saner extent
  dsnx <- sprintf("vrt:///vsicurl/%s?sd_name=analysed_sst&a_srs=EPSG:4326&a_scale=0.001&a_offset=25", dsn)

  dir <- dirname(out_dsn)
  if (!fs::dir_exists(dir)) fs::dir_create(dir)

if (!overwrite && file.exists(out_dsn)) return(NULL)

  task <- try(vapour::gdal_raster_dsn(dsnx, out_dsn = out_dsn, options = "-overwrite", target_ext = c(-180, 180, -89.995 , 89.995 ), target_res = 0.01))
  if (inherits(task, "try-error")) print(paste0("failed to read/write ", dsnx, "\n", out_dsn))
 NULL
}

year <- format(dates, "%Y")
jday <- format(dates, "%j")
ymd <- format(dates, "%Y%m%d")
mon <- format(dates, "%m")
day <- format(dates, "%d")

files <- tibble::tibble(dsn = glue::glue(template), out_dsn = pathname(glue::glue(template2)), overwrite = FALSE)
xl <- purrr::transpose(files)
for (i in seq_along(xl)) {
   x <- xl[[i]]
   fs::file_exists(x$dsn)
if (i %% 100 == 0) print(i)
   convert(x$dsn, x$out_dsn, overwrite = FALSE)
}


#saveRDS(files, "files.rds")
#library(rslurm)
#sjob <- slurm_apply(convert, files, jobname = 'write_ghrsst',
#                    nodes = 4, cpus_per_node = 52, submit = FALSE, pkgs = NULL)


