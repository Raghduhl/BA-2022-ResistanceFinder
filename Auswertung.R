myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
IDList <- IDList[!IDList %in% "KlebRef"]
path = myargs[2]
OverallResult <- paste0(path, "/OverallResults/")
SampleResult <- paste0(path, "/SampleResults/")

n50 <- function(lengths, lim){
  x = 0
  for (i in 1:length(lengths)) {
    x <- x + lengths[i]
    if(x > lim){
      return(lengths[i])
      break
    }
  }
}

getreads <- function(readlist){
  reads <- readlist[,8]
  return(reads)
}


print("fuck")
max <- c()
n <- c()
for(ID in IDList){
  print(ID)
  Data <- try(read.delim(file=paste0(path,ID,"/readlengths_",ID,".txt"), sep=" ", header=FALSE), silent = TRUE)
  if (!inherits(Data, "try-error")){
    read <- getreads(readlist = Data)
    lim <- sum(read)/2
    n <- c(n,n50(read, lim))
    max <- c(max, max(read))
  }else{
    read <- c()
  }
  
}
print(mean(max))
print(sd(max))
print(median(n))
pdf(paste0(path, "../lol.pdf"))
boxplot(n, ylab = "N50", main = "Verteilung der N50-Werte")
points(6841, col = "#055df5") 

dev.off()