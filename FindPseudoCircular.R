myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
sampleID <- myargs[2]
invisible(file.create(paste0(path, "/PseudoCircularList_", sampleID, ".txt")))
Data <- try(read.table(paste0(path, "/Path_", sampleID, ".txt"), sep="\t", header=FALSE, comment.char = "", quote = ""), silent = TRUE)
if(class(Data) == "try-error"){
  cat("Error")
}else{
  for (i in 1:nrow(Data)) {
    str <- gsub("\\+|-", "", toString(Data[i,3]))
    str = strsplit(str,",")[[1]]
    if(length(str) == 3) {
      if(str[1] == str[3]) {
        invisible(write(as.character(Data[i,2]), file = paste0(path, "/PseudoCircularList_", sampleID, ".txt"), append = TRUE)) 
      }
    }
  }
}