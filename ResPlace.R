library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
IDList <- IDList[!IDList %in% "KlebRef"]
path = myargs[2]
OverallResult <- paste0(path, "/OverallResults/")
SampleResult <- paste0(path, "/SampleResults/")


get_Rescontig_List <- function(path){
  Data <- try(read.table(path, sep="\t", header=TRUE, comment.char = "", quote = ""), silent = TRUE)
  if (!inherits(Data, "try-error")){
    contigs <- as.character(Data[,2])
    return(contigs)
  }else{
    return(c())
  }
}

get_contig_List <- function(path){
  Data <- try(read.table(path, sep="\t", header=FALSE, comment.char = "", quote = ""), silent = TRUE)
  if (!inherits(Data, "try-error")){
    list <- as.character(Data[,1])
    return(list)
  }else{
    return(c())
  }
}

getSum <- function(List, CheckList){
  Sum <- 0
  if(length(List) > 0){
    if(length(CheckList) > 0){
      for (i in 1:length(CheckList)) {
        check <- as.character(CheckList[i])
        if(check %in% List){
          Sum <- Sum + 1
        }
      }
    }
  }
  return(Sum)
}

stackedbarplot <- function(Tally, path, type){
  pdf(file = path)
  Fill <- Tally$Place
  x <- Tally$ID
  y <- Tally$Count
  Fill <- factor(Fill, levels = c("Unassigned", "Plasmid", "Genome"))
  
  p <- ggplot(Tally, aes(fill=Fill, y=y, x=x)) + 
    geom_bar(position="stack", stat="identity") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
    scale_fill_manual(values=c("#E30707", "#269906", "#055df5"),
                      labels=c("Nicht zugeordnet","Plasmid", "Chromosom"),
                      name = NULL) +
    labs(x = "Probe", y = "Häufigkeit", title = paste0("Durch die ", type, "-Datenbank vorhergesagten Resistenzgene"), colour = NULL)
  print(p)
  garbage <- dev.off()
}

getdf <- function(Samplepath, type, Overallpath){
  df <- data.frame(matrix(ncol = 3,nrow = 0))
  colnames(df) <- c("ID", "Place", "Count")
  
  for (k in 1:length(IDList)) {
    ID <- IDList[k]
    sampledf <- data.frame(matrix(ncol = 3,nrow = 3))
    colnames(sampledf) <- c("ID", "Place", "Count")
    
    contigsList <- get_Rescontig_List(paste0(SampleResult,ID,"/abricate_",type, "_", ID,".txt"))
    
    GenomeList <- get_contig_List(paste0(SampleResult,ID,"/GenomeList_",ID,".txt"))
    BlastList <- get_contig_List(paste0(SampleResult,ID,"/BlastGenomeList_",ID,".txt"))
    CoverageList <- get_contig_List(paste0(SampleResult,ID,"/IdenticalCoverageGenome_",ID,".txt"))
    GenomeList <- unique(c(GenomeList, BlastList, CoverageList))

    GenomeSum <- getSum(List = GenomeList, CheckList = contigsList)
    
    PlasmidList <- get_contig_List(paste0(SampleResult,ID,"/PlasmidList_",ID,".txt"))
    CircularList <- get_contig_List(paste0(SampleResult,ID,"/CircularList_",ID,".txt"))
    PseudoList <- get_contig_List(paste0(SampleResult,ID,"/PseudoCircularList_",ID,".txt"))
    PlasmidList <- unique(c(PlasmidList, CircularList, PseudoList))
    PlasmidSum <- getSum(List = PlasmidList, CheckList = contigsList)
    
    UnassignedList <- get_contig_List(paste0(SampleResult,ID,"/UnassignedList_",ID,".txt"))
    UnassignedSum <- getSum(List = UnassignedList, CheckList = contigsList)
    
    sampledf[1,] <- c(ID, "Genome", GenomeSum)
    sampledf[2,] <- c(ID, "Plasmid", PlasmidSum)
    sampledf[3,] <- c(ID, "Unassigned", UnassignedSum)
    df <- rbind(df, sampledf)
  }
  df[,3] <- sapply(df[,3], as.numeric)
  if(type == "card"){typename <- "card"}
  if(type == "ncbi"){typename <- "NCBI"}
  if(type == "res"){typename <- "Resfinder"}
  stackedbarplot(Tally = df, type = typename, path = paste0(Overallpath, "ResPlace_", type, ".pdf"))
  print(ID)
  print(paste("Genom", sum(df[df[,2]=="Genome",3])))
  print(paste("Plasmid", sum(df[df[,2]=="Plasmid",3])))
  print(paste("Unassigned", sum(df[df[,2]=="Unassigned",3])))
}

getdf(Samplepath = SampleResult, type = "card", Overallpath = OverallResult)
getdf(Samplepath = SampleResult, type = "ncbi", Overallpath = OverallResult)
getdf(Samplepath = SampleResult, type = "res", Overallpath = OverallResult)