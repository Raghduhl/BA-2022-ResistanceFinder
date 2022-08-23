library(readr)
myargs = commandArgs(trailingOnly=TRUE)
Input = file('stdin', 'r')
IDList <- readLines(Input, warn = FALSE)
close(Input)
IDList <- strsplit(IDList, ",")[[1]]
IDList <- IDList[!IDList %in% "K-E0025"]
path = myargs[1]
type = myargs[2]
Ref = myargs[3]
options(width = 10000)

if(Ref == "FALSE"){
  IDList <- IDList[!IDList %in% "KlebRef"]
}

createdf <- function(path, ID){
  Data <- try(read.table(paste0(path,"/",ID,"/abricate_", type, "_", ID , ".txt"), sep="\t", header=TRUE, comment.char = "", quote = ""), silent = FALSE)
 
  df <- data.frame(Data[,6],Data[,15],Data[,14])
  return(df)
}

GenList = data.frame(matrix(ncol = 3, nrow = 0))
for (i in 1:length(IDList)) {
  
  assign(IDList[i], createdf(path = path, ID = IDList[i]))
  GenList <- rbind(GenList, get(IDList[i]))
}
GenList <- unique(GenList)
colnames(GenList) <- c("Gene", "Resistance", "Mechanism")
GenList <- GenList[order(GenList$Gene),]

UList = c()
for (i in 1:nrow(GenList)) {
  Gen <- as.character(GenList[i,1])
  check = TRUE
  for (k in 1:length(IDList)) {
    df <- get(IDList[k])
    if (!Gen %in% df[,1]){
      check <- FALSE
    }
  }
  if (check == TRUE) {
    UList <- c(UList, Gen)
  }
}


cat(format_csv(GenList[GenList$Gene %in% UList,], quote = "none", eol = " \n "))
#print.data.frame(GenList[GenList$Gene %in% UList,])