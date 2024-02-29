library(furrr)

f <- fs::dir_ls(file.path(Sys.getenv("MYSCRATCH"), "data/idea/archive.podaac.earthdata.nasa.gov"), recurse = TRUE, regexp  = "tif$")

dsn <- sprintf("vrt://%s?projwin=-180,90,180,-90", f)

options(future.rng.onMisuse = "ignore")

library(vapour)

fun <- function(dsn) {
  tres <- c(5000L, 5000L)
  ex <- c(-12775000, 12775000, -12700000, 12700000)

 # opts <-c("-multi", "-wo", "NUM_THREADS=ALL_CPUS")
  opts <- ""


crs <- "PROJCS[\"unknown\",GEOGCS[\"unknown\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]]],PROJECTION[\"Lambert_Azimuthal_Equal_Area\"],PARAMETER[\"latitude_of_center\",0],PARAMETER[\"longitude_of_center\",0],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"Easting\",EAST],AXIS[\"Northing\",NORTH]]"

tryme <- try(vapour::gdal_raster_data(dsn, target_res = tres, target_crs = crs, target_ext = ex, resample = "average", options = opts))
if (inherits(tryme, "try-error")) return(NA_real_)
  mean(tryme[[1]], na.rm = TRUE)
}

plan(multicore)
print(system.time(vals <- future_map_dbl(dsn, fun)))
plan(sequential)

saveRDS(vals, "vals.rds")







