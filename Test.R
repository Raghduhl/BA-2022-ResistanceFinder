myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
path = myargs[2]

nm <- as.vector(read.csv(paste0(path,"/Klinik-Daten/ABList_all.txt"), header = FALSE)[,1])
ResistancesbyID <- data.frame(matrix(ncol = length(as.vector(nm)), nrow = length(IDList)))
colnames(ResistancesbyID) <- nm
row.names(ResistancesbyID) <- IDList

for (ID in IDList) {
  print(ID)
  File <- try(read.delim(paste0(path,"Results/SampleResults/",ID,"/DetResList_",ID,".txt"), header = FALSE), silent = TRUE)
  if (!inherits(File, "try-error")){
      for (i in 1:nrow(File)) {
        cat("\n")
        cat(paste(i, "in", nrow(File)))
        if (as.character(File[i,2]) == "R") {
          ResistancesbyID[ID,as.character(File[i,1])] <- "TRUE"
        }else{
        if (as.character(File[i,2]) == "S") {
          ResistancesbyID[ID,as.character(File[i,1])] <- "FALSE"
        }}
      }
  }
}
write.csv(ResistancesbyID ,paste0(path,"Results/OverallResults/DetResbyID.txt"), quote = FALSE)