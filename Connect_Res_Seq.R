myargs = commandArgs(trailingOnly=TRUE)
sampleID <- myargs[2]
path <- paste0(myargs[1], "/SampleResults/", sampleID)

GenomeSeq <- c("a")

PlasmidsSeq <- c("b")

CircSeq <- c("c")

UnasSeq <- c("d")

GenomeSeq <- c(GenomeSeq,lapply(strsplit(readLines(paste0(path, "/GenomeList_", sampleID, ".txt"))," "), toString))

PlasmidsSeq <- c(PlasmidsSeq,lapply(strsplit(readLines(paste0(path, "/PlasmidList_", sampleID, ".txt"))," "), toString))

CircSeq <- c(CircSeq,lapply(strsplit(readLines(paste0(path, "/UniqCircularList_", sampleID, ".txt"))," "), toString))

UnasSeq <- c(UnasSeq,lapply(strsplit(readLines(paste0(path, "/UnassignedList_", sampleID, ".txt"))," "), toString))
con = file(paste0(path, "/UnassignedList_", sampleID, ".txt"), "r")
Res <- try(read.table(paste0(path,"/ResList_", sampleID, ".txt"), header=FALSE, sep="", stringsAsFactors = FALSE, comment.char = "", quote = ""), silent = TRUE)
Genome <- "Genome"
Plasmid <- "Plasmid"
Circular <- "Circular"
Unassigned <- "Unassigned"
for (i in 1:nrow(Res)){
  if (Res[i,2] %in% GenomeSeq){
    Res[i,2] <- Genome
  }
  if (Res[i,2] %in% PlasmidsSeq){
    print(Plasmid)
    Res[i,2] <- Plasmid
  }
  if (Res[i,2] %in% CircSeq){
    Res[i,2] <- Circular
  }
  if (Res[i,2] %in% UnasSeq){
    Res[i,2] <- Unassigned
  }
}
invisible(write.table(Res, paste0(path,"/ResList_", sampleID, ".txt"), quote=FALSE, append = FALSE, col.names = FALSE, row.names = FALSE))

Res <- try(read.table(paste0(path,"/ResListu_", sampleID, ".txt"), header=FALSE, sep="", stringsAsFactors = FALSE, comment.char = "", quote = ""))
Genome <- "Genome"
Plasmid <- "Plasmid"
Circular <- "Circular"
Unassigned <- "Unassigned"
Gen <- 0
Plas <- 0
Circ <- 0
Unas <- 0
for (i in 1:nrow(Res)){
  if (Res[i,2] %in% GenomeSeq){
    Res[i,2] <- Genome
    Gen <- Gen +1
  }
  if (Res[i,2] %in% PlasmidsSeq){
    print(Plasmid)
    Res[i,2] <- Plasmid
    Plas <- Plas +1
  }
  if (Res[i,2] %in% CircSeq){
    Res[i,2] <- Circular
    Circ <- Circ + 1
  }
  if (Res[i,2] %in% UnasSeq){
    Res[i,2] <- Unassigned
    Unas <- Unas + 1
  }
}
invisible(write.table(Res, paste0(path,"/ResListu_", sampleID, ".txt"), quote=FALSE, append = FALSE, col.names = FALSE, row.names = FALSE))
con <- paste0(myargs[1],"/OverallResults/Plasmid_Resistance_Counts.txt")
  cat(paste0(sampleID,",",Gen,",Genome", " \n"),file = con, append = TRUE)
  cat(paste0(sampleID,",",Plas,",Plasmid", " \n"),file = con, append = TRUE)
  cat(paste0(sampleID,",",Circ,",Circular", " \n"),file = con, append = TRUE)
  cat(paste0(sampleID,",",Unas,",Unassigned", " \n"),file = con, append = TRUE)