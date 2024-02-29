library(curl)
library(arrow)
library(stringr)
install.packages("rslurm", "lib")

oisst <- read_parquet("https://github.com/mdsumner/trend.oisst/raw/main/oisstfiles.parquet")


pars <- data.frame(dsn =  gsub("https:///", "https://", oisst$dsn))

calcfun <- function(dsn) {
  tres <- c(25000L, 25000L)
  ex <- c(-12775000, 12775000, -12700000, 12700000)

  opts <-c("-multi", "-wo", "NUM_THREADS=ALL_CPUS")
  crs <- "PROJCS[\"unknown\",GEOGCS[\"unknown\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]]],PROJECTION[\"Lambert_Azimuthal_Equal_Area\"],PARAMETER[\"latitude_of_center\",0],PARAMETER[\"longitude_of_center\",0],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AXIS[\"Easting\",EAST],AXIS[\"Northing\",NORTH]]"
  mean(vapour::gdal_raster_data(dsn, target_res = tres, target_crs = crs, target_ext = ex, resample = "average", options = opts)[[1]], na.rm = TRUE)
}


library(rslurm, lib.loc = "lib")
sjob <- slurm_apply(calcfun, pars, jobname = 'trend_oisst_256',
                    nodes = 8, cpus_per_node = 256, submit = FALSE, pkgs = NULL)
