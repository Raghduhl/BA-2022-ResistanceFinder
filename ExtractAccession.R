myargs = commandArgs(trailingOnly=TRUE)
sampleID <- myargs[2]
path <- myargs[1]

Data <- try(read.table(paste0(path,"/RefGenBlastResults_",sampleID,".out"), sep="\t", header=FALSE, nrows=5), silent = TRUE)
if(class(Data) == "try-error"){
  cat("lol")
}else{
  Acc <- as.character(Data[1,2])
  cat(Acc)
}