library(readr)
library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
IDList <- IDList[!IDList %in% "KlebRef"]
path = myargs[2]
Translation <- read.delim(myargs[3])

getARList <- function(path, ID, type){
  Data <- try(read.table(paste0(path,"/",ID,"/Resistances_", type, "_", ID , ".txt"), sep="\t", header=TRUE, comment.char = "", quote = ""), silent = TRUE)
  if (!inherits(Data, "try-error")){
    df <- as.character(Data[,1])
  }else{
    df <- c()
  }
  return(df)
}

getDetList <- function(path, ID){
  Data <- try(read.table(paste0(path,"/",ID,"/DetResList_", ID , ".txt"), sep="\t", header=FALSE, comment.char = "", quote = ""), silent = TRUE)
  if (!inherits(Data, "try-error")){
      df <- data.frame(as.character(Data[,1]), as.character(Data[,2]))
  }else{
      df <- data.frame(matrix(ncol=2,nrow=0))
    }
  
  colnames(df) <- c("Res", "Check")
return(df)
}

stackedbarplot <- function(Tally, path, type){
  Data <- rbind(
    data.frame("Antibiotic" = Tally$Antibiotic, "Count" = Tally$Hits, "Type" = "Hits"),
    data.frame("Antibiotic" = Tally$Antibiotic, "Count" = Tally$Miss, "Type" = "Miss")
  )
  pdf(file = path)
  p <- ggplot(Data, aes(fill=Type, y=Count, x=Antibiotic)) + 
    geom_bar(position="stack", stat="identity") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin = margin(10, 10, 10, 50)) +
    scale_fill_manual(values=c("#269906", "#055df5"),
                      labels=c("Treffer","Fehl"),
                      name = NULL) +
    labs(x = "Antibiotikum", y = "Häufigkeit", title = paste0("Durch die ", type, "-Datenbank vorhergesagte Resistenzen"), colour = NULL)
  print(p)
  garbage <- dev.off()
}

getTally <- function(Translation, path, type, ID, AB_tally){
  
  ARList <- getARList(path = path, ID = ID, type = type)
  DetList <- getDetList(path = path, ID = ID)
  TestList <- c()
  if(length(ARList) > 0){
    if(nrow(DetList) > 0){
      for (i in 1:length(ARList)) {
        if(!is.na(ARList[i])){
          for (d in 1:nrow(Translation)) {
            if(!is.na(Translation[d,2])){
              if(type == "card"){
                if(tolower(ARList[i]) == tolower(Translation[d,2])){
                  TestList <- c(TestList, tolower(Translation[d,1]))
                }
              }
            }
            
            if(!is.na(Translation[d,3])){
              if(type == "ncbi"){
                if(tolower(ARList[i]) == tolower(Translation[d,3])){
                  TestList <- c(TestList, tolower(Translation[d,1]))
                }
              }
            }
            
            if(!is.na(Translation[d,4])){
              if(type == "res"){
                if(tolower(ARList[i]) == tolower(Translation[d,4])){
                  TestList <- c(TestList, tolower(Translation[d,1]))
                }
              }
            }  
          }
      }
      }
    }
    for (i in 1:length(DetList[,1])) {
      if(length(TestList) > 0){
        if(tolower(DetList[i,1]) %in% TestList){
          if(as.character(DetList[i,2]) == "R"){
            AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] <- AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] +1
          }else{
            if(as.character(DetList[i,2]) == "M"){
              AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] <- AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] +1
            }else{
              if(as.character(DetList[i,2]) == "I"){
                AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] <- AB_tally[AB_tally[,1] == as.character(DetList[i,1]),2] +1
              }else{
                AB_tally[AB_tally[,1] == as.character(DetList[i,1]),3] <- AB_tally[AB_tally[,1] == as.character(DetList[i,1]),3] +1
              }
            }
          }
        }
      }
    }
  }
  return(AB_tally)
}

AB_tally_card <- data.frame(matrix(ncol = 3, nrow = length(Translation$Determined)))
colnames(AB_tally_card) <- c("Antibiotic", "Hits", "Miss")
AB_tally_card$Antibiotic <- Translation$Determined
AB_tally_card$Hits <- 0
AB_tally_card$Miss <- 0

AB_tally_ncbi <- data.frame(matrix(ncol = 3, nrow = length(Translation$Determined)))
colnames(AB_tally_ncbi) <- c("Antibiotic", "Hits", "Miss")
AB_tally_ncbi$Antibiotic <- Translation$Determined
AB_tally_ncbi$Hits <- 0
AB_tally_ncbi$Miss <- 0

AB_tally_res <- data.frame(matrix(ncol = 3, nrow = length(Translation$Determined)))
colnames(AB_tally_res) <- c("Antibiotic", "Hits", "Miss")
AB_tally_res$Antibiotic <- Translation$Determined
AB_tally_res$Hits <- 0
AB_tally_res$Miss <- 0

for (i in 1:length(IDList)) {
  AB_tally_card <- getTally(Translation=Translation, path=path, type="card", ID = IDList[i], AB_tally = AB_tally_card)

  AB_tally_ncbi <- getTally(Translation=Translation, path=path, type="ncbi", ID = IDList[i], AB_tally = AB_tally_ncbi)

  AB_tally_res <- getTally(Translation=Translation, path=path, type="res", ID = IDList[i], AB_tally = AB_tally_res)
}

cat(paste("Card:", "\n"))
cat(paste("Hit:", sum(AB_tally_card[,2], na.rm = TRUE), "Miss:", sum(AB_tally_card[,3], na.rm = TRUE), "\n"))
cat(paste("NCBI:", "\n"))
cat(paste("Hit:", sum(AB_tally_ncbi[,2], na.rm = TRUE), "Miss:", sum(AB_tally_ncbi[,3], na.rm = TRUE), "\n"))
cat(paste("Resfinder:", "\n"))
cat(paste("Hit:", sum(AB_tally_res[,2], na.rm = TRUE), "Miss:", sum(AB_tally_res[,3], na.rm = TRUE), "\n"))

stackedbarplot(AB_tally_card, paste0(path,"/../OverallResults/AB_prediction_card.pdf"), "card")
stackedbarplot(AB_tally_ncbi, paste0(path,"/../OverallResults/AB_prediction_ncbi.pdf"), "NCBI")
stackedbarplot(AB_tally_res, paste0(path,"/../OverallResults/AB_prediction_res.pdf"), "Resfinder")