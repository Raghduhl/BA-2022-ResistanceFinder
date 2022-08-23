myargs = commandArgs(trailingOnly=TRUE)
toTest <- myargs[1]
path <- myargs[2]


Data <- try(read.table(path, sep="\t", header=FALSE, comment.char = "", quote = ""), silent = TRUE)
if(class(Data) == "try-error"){
  cat("lol")
}else{
  for(i in 1:nrow(Data)){
    if(Data[i,1] == toTest){
      cov <- Data[i,2]
    }
  }
  for(k in 1:nrow(Data)){
    if(as.vector(Data[k,2]) == cov){
      cat(paste0(as.vector(Data[k,1]),"\n"))
    } 
  }
}