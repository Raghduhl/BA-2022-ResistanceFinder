myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
sampleID <- myargs[2]
invisible(file.create(paste0(path, "/UniqueEdges_", sampleID, ".txt")))
Data <- try(read.table(paste0(path, "/Line_", sampleID, ".txt"), sep="\t", header=FALSE), silent = TRUE)
if(class(Data) == "try-error"){
  cat("No unique Edges")
  writeLines("")
}else{
  for (i in 1:nrow(Data)) {
    if(Data[i,2] ==  Data[i,4]) {
      invisible(write(as.character(Data[i,2]), file = paste0(path, "/UniqueEdges_", sampleID, ".txt"), append = TRUE))
    }
  }
}

invisible(file.create(paste0(path, "/CircularList_", sampleID, ".txt")))
Data <- try(read.table(paste0(path, "/Path_", sampleID, ".txt"), sep="\t", header=FALSE), silent = TRUE)
if(class(Data) == "try-error"){
  
}else{
  con = file(paste0(path, "/UniqueEdges_", sampleID, ".txt"), "r")
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    for (i in 1:nrow(Data)) {
      if (as.character(Data[i,3]) == paste0(line,"+")){
        invisible(write(as.character(Data[i,2]), file = paste0(path, "/CircularList_", sampleID, ".txt"), append = TRUE))
      }
      if (as.character(Data[i,3]) == paste0(line,"-")){
        invisible(write(as.character(Data[i,2]), file = paste0(path, "/CircularList_", sampleID, ".txt"), append = TRUE))
      }
    }	
  }
  
  close(con)
}
Data <- try(read.table(paste0(path, "/CircularList_", sampleID, ".txt"), sep="\t", header=FALSE), silent = TRUE)
if(class(Data) == "try-error"){
  cat(paste0("No circular Sequnece found in ", sampleID))
  writeLines("")
}else{
  invisible(write.table(unique(Data), paste0(path, "/CircularList_", sampleID, ".txt"), quote=FALSE, append = FALSE, col.names = FALSE, row.names = FALSE))
  cat(paste0("Added all circular sequences in ", sampleID))
  writeLines("")
}