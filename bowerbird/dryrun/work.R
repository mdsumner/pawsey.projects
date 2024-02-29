library(bowerbird)
my_directory <- file.path(Sys.getenv("MYSCRATCH"), "data/bowerbird")
#my_directory <- "/scratch/pawsey0973/mdsumner/data/bowerbird"

cf <- bb_config(local_file_root = my_directory)


oisst <-    bb_source(
                         name = "NCI Thredds",
                         id = "nci123",
                         description = "All NCI files",
                         doc_url = "",
                         citation = "",
                         #source_url = "https://dapds00.nci.org.au/thredds/catalog.html",
                         source_url = "https://dapds00.nci.org.au/thredds/catalogs/zv2/catalog.html", 
                         license = "Please cite",
                         method = list("bb_handler_rget", level = 18, dry_run = T, accept_follow = ".*fileServer/.*"), 
                         postprocess = NULL,
                         access_function = "",
                         collection_size = 2000,
                         data_group = "thredds links")

cf <- bb_add(cf, oisst)
status <- bb_sync(cf, verbose = TRUE)

saveRDS(status, "status.rds")





