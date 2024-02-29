
#print("nworkers: ")
#print(length(parallelly::availableWorkers()))

#dir.create("lib")
#install.packages("furrr", "lib")

library(curl)
library(arrow)
library(furrr, lib.loc = "lib")
library(future.batchtools, lib.loc = "lib")
library(stringr)


print("nworkers: ")
print(length(parallelly::availableWorkers()))


oisst <- read_parquet("https://github.com/mdsumner/trend.oisst/raw/main/oisstfiles.parquet")

options(future.rng.onMisuse = "ignore")

dsn <- gsub("https:///", "https://", oisst$dsn)
#url <- str_extract(dsn, "https.*nc")
#dir <- file.path(Sys.getenv("MYSCRATCH"), "oisst")

#dl <- function(x) {
#  curl_download(x, file.path(dir, basename(x)))
#}

calcfun <- function(dsn) {
  tres <- c(25000L, 25000L)
  ex <- c(-12775000, 12775000, -12700000, 12700000)

  opts <-c("-multi", "-wo", "NUM_THREADS=ALL_CPUS")
  crs <- "PROJCS[\"unknown\",GEOGCS[\"unknown\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]]],PROJECTION[\"Lambert_Azimuthal_Equal_Area\"],PARAMETER[\"latitude_of_center\",0],PARAMETER[\"longitude_of_center\",0],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"Easting\",EAST],AXIS[\"Northing\",NORTH]]"
  mean(vapour::gdal_raster_data(dsn, target_res = tres, target_crs = crs, target_ext = ex, resample = "average", options = opts)[[1]], na.rm = TRUE)
}

#template <- makeClusterFunctionsSlurm(
#  template = "slurm",
#  array.jobs = TRUE,
#  nodename = "node-1",
#  scheduler.latency = 1,
#  fs.latency = 65
#)

plan(future.batchtools::batchtools_slurm, nodename = "node-1", template = "slurm", array.jobs = TRUE, scheduler.latency = 1, fs.latency = 65)
d <- future_map_dbl(dsn[1:24], calcfun)
plan(sequential)

saveRDS(d, "value.rds")
print("done")

 
