myargs = commandArgs(trailingOnly=TRUE)
TranslationFile <- myargs[1]
SampleFile <- myargs[2]
check <- myargs[3]

Translation <- try(read.delim(TranslationFile, header = FALSE, stringsAsFactors = FALSE))
Sample <- try(read.delim(SampleFile, header = FALSE, stringsAsFactors = FALSE))
for (i in 1:nrow(Translation)){
  for (k in 1:nrow(Sample)) {
    if (as.character(Translation[i,1]) == as.character(Sample[k,1])){
      Sample[Sample == as.character(Sample[k,1])] <- as.character(Translation[i,2])
    }
  }
}
if(as.character(check) == "remove"){
  remove <- c()
  for (i in 1:nrow(Sample)) {
    if(as.character(Sample[i,2]) == "R"){
      test <- as.character(Sample[i,1])
      for(k in 1:nrow(Sample)){
        if(test == as.character(Sample[k,1])){
          if(as.character(Sample[k,2]) == "S"){
            remove <- c(remove, k)
          }
        }
      }
    }
  }
  if(length(remove) > 0){
    Sample <- Sample[-remove,]
  }
}

write.table(unique(Sample), file = SampleFile, row.names=FALSE, col.names=FALSE, quote=FALSE, sep = "\t")