library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
IDList <- IDList[!IDList %in% "KlebRef"]
path = myargs[2]
Translation <- read.delim(myargs[3])

comparedb <- function(detres, db, ID, path, Translation, AB_tally){
  hit = 0
  miss = 0
  out <- data.frame(matrix(ncol = 2, nrow = length(detres)))
  colnames(out) <- c("Antibiotic", "Boolean")
  database <- try(read.delim(paste0(path,"/",ID,"/","abricate_", db, "_",ID,".txt"), header = T))
    if (!inherits(detres, "try-error")){
    database <- unlist(strsplit(as.character(database[,15]), split = ";"))
    for(i in 1:length(detres)){
      testres <- as.character(detres[i])
      testdb <- as.character(Translation[Translation$Determined == testres,][[db]])
      out[i,1] <- testres
      if(tolower(testdb) %in% tolower(database)) {
        
        out[i,2] <- "TRUE"
        hit <- hit +1
        AB_tally$Hits[AB_tally$Antibiotic == testres] <- AB_tally$Hits[AB_tally$Antibiotic == testres] + 1
      }else{
        out[i,2] <- "FALSE"
        miss <- miss + 1
        AB_tally$Miss[AB_tally$Antibiotic == testres] <- AB_tally$Miss[AB_tally$Antibiotic == testres] + 1
      }
    }
  }
  invisible(write.table(out, file = paste0(path,"/",ID,"/","ResCompare", db, "_",ID,".txt", sep = "\t"), quote = FALSE, row.names = FALSE, sep = "\t"))
  return(list("HITMISS" = c(hit,miss), "tally" = AB_tally))
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
                      name = NULL)
p <- p + labs(x = "Antibiotikum", y = "Häufigkeit", title = paste0("Durch die ", type, "-Datenbank gefundene Resistenzgene"), colour = NULL)
  print(p)
  garbage <- dev.off()
}

card_tally <- data.frame(matrix(ncol = 2, nrow = length(IDList)))
colnames(card_tally) <- c("hit","miss")
ncbi_tally <- data.frame(matrix(ncol = 2, nrow = length(IDList)))
colnames(ncbi_tally) <- c("hit","miss")
res_tally <- data.frame(matrix(ncol = 2, nrow = length(IDList)))
colnames(res_tally) <- c("hit","miss")

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

for(k in 1:length(IDList)){
  ID <- as.character(IDList[k])
  detres <- try(read.delim(paste0(path,"/",ID,"/","DetResList_",ID,".txt"), header = F), silent = TRUE)
  if (!inherits(detres, "try-error")){
    colnames(detres) <- c("AB", "Sen")
    detres <- detres[detres$Sen == "R" | detres$Sen == "M",1]
    result <- comparedb(detres, db = "card", ID, path, Translation, AB_tally = AB_tally_card)
    card <- result$HITMISS
    AB_tally_card <- result$tally
    card_tally[k,1] <- card[1]
    card_tally[k,2] <- card[2]
    result <- comparedb(detres, db = "ncbi", ID, path, Translation, AB_tally = AB_tally_ncbi)
    ncbi <- result$HITMISS
    AB_tally_ncbi <- result$tally
    ncbi_tally[k,1] <- ncbi[1]
    ncbi_tally[k,2] <- ncbi[2]
    result <- comparedb(detres, db = "res", ID, path, Translation, AB_tally = AB_tally_res)
    res <- result$HITMISS
    AB_tally_res <- result$tally
    res_tally[k,1] <- res[1]
    res_tally[k,2] <- res[2]
  }
}
cat(paste("Card:", "\n"))
cat(paste("Hit:", sum(card_tally[,1], na.rm = TRUE), "Miss:", sum(card_tally[,2], na.rm = TRUE), "\n"))
cat(paste("NCBI:", "\n"))
cat(paste("Hit:", sum(ncbi_tally[,1], na.rm = TRUE), "Miss:", sum(ncbi_tally[,2], na.rm = TRUE), "\n"))
cat(paste("Resfinder:", "\n"))
cat(paste("Hit:", sum(res_tally[,1], na.rm = TRUE), "Miss:", sum(res_tally[,2], na.rm = TRUE), "\n"))
stackedbarplot(AB_tally_card, paste0(path,"/../OverallResults/AB_tally_card.pdf"),type="card")
stackedbarplot(AB_tally_ncbi, paste0(path,"/../OverallResults/AB_tally_ncbi.pdf"),type="NCBI")
stackedbarplot(AB_tally_res, paste0(path,"/../OverallResults/AB_tally_res.pdf"),type="Resfinder")