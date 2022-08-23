library("readxl")
myargs = commandArgs(trailingOnly=TRUE)
sampleID <- myargs[1]
path <- myargs[2]

checkevKB <- function(Row, path, id){
  for (i in 1:ncol(Row)) {
    var <- as.character(Row[1,i]) == "M" | as.character(Row[1,i]) == "R" |  as.character(Row[1,i]) == "S"
    var[is.na(var)] <- FALSE
    if (var){
      if(as.character(Row[1,i]) == "M"){
        Row[1,i] <- "R"
      }
      invisible(write(colnames(Row[,i]), file = paste0(path, "/Klinik-Daten/ABList_all.txt"), append = TRUE)) 
      invisible(write(paste(colnames(Row[,i]), as.character(Row[1,i]), sep = "\t"), file = paste0(path, "/Results/SampleResults/", id, "/DetResList_",id, ".txt"), append = TRUE)) 
      if(as.character(Row[1,i]) == "M" | as.character(Row[1,i]) == "R"){
        invisible(write(colnames(Row[,i]), file = paste0(path, "/Klinik-Daten/ABListResistant_all.txt"), append = TRUE)) 
      }
    }
  }
}

checkKlinikum <- function(Row, path, id){
  for (i in 1:ncol(Row)) {
    var <- as.character(Row[1,i]) == "M" | as.character(Row[1,i]) == "R" | as.character(Row[1,i]) == "S"
    var[is.na(var)] <- FALSE
    if (var){
      if(as.character(Row[1,i]) == "M"){
        Row[1,i] <- "R"
      }
      invisible(write(as.character(Klinikum[1,i]), file = paste0(path, "/Klinik-Daten/ABList_all.txt"), append = TRUE)) 
      invisible(write(paste(as.character(Klinikum[1,i]), as.character(Row[1,i]), sep = "\t"), file = paste0(path, "/Results/SampleResults/", id, "/DetResList_",id, ".txt"), append = TRUE)) 
      if(as.character(Row[1,i]) == "M" | as.character(Row[1,i]) == "R"){
        invisible(write(as.character(Klinikum[1,i]), file = paste0(path, "/Klinik-Daten/ABListResistant_all.txt"), append = TRUE)) 
      }
    }
  }
}

checkLippe <- function(Row, path, id){
  for (i in 1:ncol(Row)) {
    var <- as.character(Row[1,i]) == "I" | as.character(Row[1,i]) == "R" | as.character(Row[1,i]) == "S"
    var[is.na(var)] <- FALSE
    if (var){
      if(as.character(Row[1,i]) == "I"){
        Row[1,i] <- "R"
      }
      invisible(write(colnames(Row[,i]), file = paste0(path, "/Klinik-Daten/ABList_all.txt"), append = TRUE)) 
      invisible(write(paste(colnames(Row[,i]), as.character(Row[1,i]), sep = "\t"), file = paste0(path, "/Results/SampleResults/", id, "/DetResList_",id, ".txt"), append = TRUE)) 
      if(as.character(Row[1,i]) == "I" | as.character(Row[1,i]) == "R"){
        invisible(write(colnames(Row[,i]), file = paste0(path, "/Klinik-Daten/ABListResistant_all.txt"), append = TRUE)) 
      }
    }
  }
}

suppressMessages(invisible(EvKB <- read_excel(paste0(path, "/Klinik-Daten/Kinbiotics-EvKB.xlsx"))))
suppressMessages(invisible(Klinikum <- read_excel(paste0(path, "/Klinik-Daten/Kinbiotics-Klinikum-Bi.xlsx"))))
suppressMessages(invisible(Lippe <- read_excel(paste0(path, "/Klinik-Daten/Kinbiotics-Lippe.xlsx"))))
if(grepl(sampleID, EvKB[,1])==TRUE){
  EvKBB <- "TRUE"
  checkevKB(EvKB[which(sampleID == EvKB[,1]),], path, sampleID)
}else{
  EvKBB <- "FALSE"
}
if(grepl(sampleID, Klinikum[,1])==TRUE){
  KlinikumB <- "TRUE"
  checkKlinikum(Klinikum[which(sampleID == Klinikum[,1]),], path, sampleID)
}else{
  KlinikumB <- "FALSE"
}
if(grepl(sampleID, Lippe[,1])==TRUE){
  LippeB <- "TRUE"
  checkLippe(Lippe[which(sampleID == Lippe[,1]),], path, sampleID)
}else{
  LippeB <- "FALSE"
}
cat(paste(sampleID, EvKBB, KlinikumB, LippeB, sep = ","))