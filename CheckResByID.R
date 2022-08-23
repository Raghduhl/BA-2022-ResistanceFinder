library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
IDList = myargs[1]
IDList <- strsplit(IDList, ",")[[1]]
path = myargs[2]

createPieCharts <- function(name, res, sen, na, out=paste0(path,"/Results/OverallResults/ResPieCharts")){
  df <- data.frame(c("Resistant","Sensitive","Not tested"), c(res,sen,na))
  colnames(df) <- c("Type","Count")
  
  print(df)
  pdf(file=paste0(out,"/",name,"_PieChart.pdf"))
  p <-ggplot(df, aes(x = "", y = df[,2], fill = df[,1])) + 
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y", start = 0) +
    theme_void() +
    ggtitle(name) +
    theme(legend.title = element_blank())
  print(p)
  garbage <- dev.off()
}

nm <- as.vector(read.csv(paste0(path,"/Klinik-Daten/ABList_all.txt"), header = FALSE)[,1])
ResistancesbyID <- data.frame(matrix(ncol = length(as.vector(nm)), nrow = length(IDList)))
colnames(ResistancesbyID) <- nm
row.names(ResistancesbyID) <- IDList

for (ID in IDList) {
  print(ID)
  File <- try(read.delim(paste0(path,"/Results/SampleResults/",ID,"/DetResList_",ID,".txt"), header = FALSE), silent = TRUE)
  if (!inherits(File, "try-error")){
      for (i in 1:nrow(File)) {
        if (as.character(File[i,2]) == "R") {
          if(as.character(File[i,1]) == "Levofloxacin"){
            print(ID)
          }
          ResistancesbyID[ID,as.character(File[i,1])] <- "TRUE"
        }else{
        if (as.character(File[i,2]) == "S") {
          ResistancesbyID[ID,as.character(File[i,1])] <- "FALSE"
        }}
      }
  }
}

write.csv(ResistancesbyID ,paste0(path,"/Results/OverallResults/DetResbyID.txt"), quote = FALSE)
ResCount <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(ResCount) <-  c("Antibiotic", "Type", "Count")

for (i in 1:length(colnames(ResistancesbyID))) {
  ResCount[nrow(ResCount) + 1,] = c(colnames(ResistancesbyID)[i], "Resistant", sum(ResistancesbyID[,i]=="TRUE", na.rm = TRUE))
  ResCount[nrow(ResCount) + 1,] = c(colnames(ResistancesbyID)[i], "Sensitive", sum(ResistancesbyID[,i]=="FALSE", na.rm = TRUE))
  ResCount[nrow(ResCount) + 1,] = c(colnames(ResistancesbyID)[i], "not tested", sum(is.na(ResistancesbyID[,i])))
  ResCount[,3] <- as.numeric(ResCount[,3])
  levels(ResistancesbyID[,2]) <- c("Resistant", "Sensitive", "not tested")
  print(paste(colnames(ResistancesbyID)[i],sum(ResistancesbyID[,i]=="TRUE", na.rm = TRUE) ,sum(ResistancesbyID[,i]=="FALSE", na.rm = TRUE)))
}
pdf(file = paste0(path, "/Results/OverallResults/DetResCount_with.pdf"))
p <- ggplot(ResCount, aes(fill=Type, y=Count, x=Antibiotic)) + 
  geom_bar(position="stack", stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin = margin(10, 10, 10, 50)) +
  scale_fill_manual(values=c("#E30707", "#055df5", "#269906"),
                    labels=c("Nicht getested", "Resistent","Sensitiv"),
                    name = NULL) +
  labs(x = "Antibiotikum", y = "Anzahl der Proben", title = "Vorkommen der Antibiotikaresistenzen")
print(p)
garbage <- dev.off()

pdf(file = paste0(path, "/Results/OverallResults/DetResCount.pdf"))
p <- ggplot(subset(ResCount, !Type == "not tested"), aes(fill=Type, y=Count, x=Antibiotic)) + 
  geom_bar(position="stack", stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin = margin(10, 10, 10, 50)) +
  scale_fill_manual(values=c("#055df5", "#269906"),
                    labels=c("Resistent","Sensitiv"),
                    name = NULL) +
  labs(x = "Antibiotikum", y = "Anzahl der Proben", title = "Vorkommen der Antibiotikaresistenzen")
print(p)
garbage <- dev.off()

pdf(file = paste0(path, "/Results/OverallResults/DetResProportion_with.pdf"))
p <- ggplot(ResCount, aes(fill=Type, y=Count, x=Antibiotic)) + 
  geom_bar(position="fill", stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin = margin(10, 10, 10, 50)) +
  scale_fill_manual(values=c("#E30707", "#055df5", "#269906"),
                    labels=c("Nicht getested", "Resistent","Sensitiv"),
                    name = NULL) +
  labs(x = "Antibiotikum", y = "Anteil der getesteten Proben", title = "Anteil der Antibiotikaresistenzen")
print(p)
garbage <- dev.off()

pdf(file = paste0(path, "/Results/OverallResults/DetResProportion.pdf"))
p <- ggplot(subset(ResCount, !Type == "not tested"), aes(fill=Type, y=Count, x=Antibiotic)) + 
  geom_bar(position="fill", stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin = margin(10, 10, 10, 50)) +
  scale_fill_manual(values=c("#055df5", "#269906"),
                    labels=c("Resistent","Sensitiv"),
                    name = NULL) +
  labs(x = "Antibiotikum", y = "Anteil der getesteten Proben", title = "Anteil der Antibiotikaresistenzen")
print(p)
garbage <- dev.off()
#createPieCharts(name = colnames(ResistancesbyID)[i], res = sum(ResistancesbyID[,i]=="TRUE", na.rm = TRUE), sen = sum(ResistancesbyID[,i] == "FALSE", na.rm = TRUE), na = sum(is.na(ResistancesbyID[,i])))
