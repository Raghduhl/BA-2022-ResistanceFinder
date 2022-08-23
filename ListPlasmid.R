myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
sampleID <- myargs[2]
invisible(file.create(paste0(path, "/PlasmidGeneList_", sampleID, ".txt")))
invisible(file.create(paste0(path, "/PlasmidList_", sampleID, ".txt")))
Data <- try(read.table(paste0(path, "/abricate_plasmidfinder_", sampleID, ".txt"), sep="\t", header=TRUE), silent=TRUE)
if(class(Data) == "try-error"){
  cat("No Plasmids found in ", sampleID)
  writeLines("")
}else{
  Plas <- data.frame(matrix(ncol = 2, nrow = length(Data[,6])))
  Plas[,1] <- Data[,6]
  Plas[,2] <- Data[,2]
  invisible(write.table(Plas, paste0(path, "/PlasmidGeneList_", sampleID, ".txt"), quote=FALSE, row.names=FALSE, col.names=FALSE))
  invisible(write.table(unique(Plas[,2]), paste0(path, "/PlasmidList_", sampleID, ".txt"), quote=FALSE, row.names=FALSE, col.names=FALSE))
  cat("Plasmids from ", sampleID, " added")
  writeLines("")
}