
.libPaths("/software/projects/pawsey0973/mdsumner/setonix/r/4.3")

print("nworkers: ")
print(parallelly::availableWorkers())

library(arrow)

library(vapour)
oisst <- read_parquet("https://github.com/mdsumner/trend.oisst/raw/main/oisstfiles.parquet")

options(future.rng.onMisuse = "ignore")

library(furrr)
plan(multisession)
print(system.time(l <- future_map(oisst$dsn[2001:2048], vapour_raster_info)))

plan(sequential)


