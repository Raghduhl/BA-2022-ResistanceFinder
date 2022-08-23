myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
sampleID <- myargs[2]

Data <- try(read.table(paste0(path, "/BlastGenomeList_", sampleID, ".txt"), sep="\t", header=TRUE, comment.char = "", quote = ""), silent=TRUE)
invisible(write.table(unique(Data[,1]), paste0(path, "/BlastGenomeList_", sampleID, ".txt"), quote=FALSE, row.names=FALSE, col.names=FALSE))