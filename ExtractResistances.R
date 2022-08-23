myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
sampleID <- myargs[2]
type <- myargs[3]

Data <- try(read.table(paste0(path, "/abricate_", type, "_", sampleID, ".txt"), sep="\t", header=TRUE, comment.char = "", quote = ""), silent = TRUE)
res <- as.character(Data[,15])
for (i in 1:length(res)) {
  cat(paste(as.character(res[i]),"\\n"))
}