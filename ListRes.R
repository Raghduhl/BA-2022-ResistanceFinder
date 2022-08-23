myargs = commandArgs(trailingOnly=TRUE)
dir <- myargs[2]
path <- paste0(myargs[1],"/SampleResults/",dir)
invisible(file.create(paste0(path,"/ResList_", dir, ".txt")))
invisible(file.create(paste0(path,"/ResListu_", dir, ".txt")))

Data <- try(read.table(paste0(path,"/abricate_card_", dir, ".txt"), sep="\t", header=TRUE, comment.char = "", quote = ""))
if (class(Data) == "try-error"){
  writeLines("")
  cat("No Data in ", dir)
}else{
  cat("Data from", dir, "is being added")
  writeLines("")
  Res <- gsub(";",paste0("\n"), paste0(Data[,15], ",", Data[,2])) 
  Res <- c("Res,Count", Res)
  invisible(write.table(read.table(text = Res), paste0(path,"/ResList_", dir, ".txt"), sep="", quote=FALSE, append = FALSE, col.names = FALSE, row.names = FALSE))
  Res <- try(read.csv(paste0(path,"/ResList_", dir, ".txt"), header=TRUE, fill = TRUE))
  for (i in 1:nrow(Res)){
    if (i == 1){
      for (k in 1:nrow(Res)){
        if (!(is.na(Res[k,2]) || Res[k,2] == '')){
          Res[i,2] <- Res[k,2]
          break
        }
      }
    }
    if (is.na(Res[i,2]) || Res[i,2] == ''){
      Res[i,2] <- Res[i-1,2]
    }
  }
  invisible(write.table(Res, paste0(path,"/ResList_", dir, ".txt"), quote=FALSE, append = FALSE, col.names = FALSE, row.names = FALSE))
  Res <- unique(Res)
  invisible(write.table(Res, paste0(path,"/ResListu_", dir, ".txt"), quote=FALSE, append = FALSE, row.names = FALSE, col.names = FALSE))
  }
  