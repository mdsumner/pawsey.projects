
#.libPaths("/software/projects/pawsey0973/mdsumner/setonix/r/4.2")

print(Sys.getenv("R_LIBS_USER"))

print(parallelly::availableCores())

print(.libPaths())


print(list.files(.libPaths()[1]))


