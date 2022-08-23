library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
Data <- read.csv(paste0(path,"/Spezies_Count.csv"))
pdf(file=paste0(path,"/PieChart.pdf"))
p <-ggplot(Data, aes(x = "", y = Data[,2], fill = Data[,1])) + 
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y", start = 0) +
    theme_void() +
    theme(legend.title = element_blank())
p
garbage <- dev.off()
