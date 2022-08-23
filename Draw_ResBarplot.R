library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
Data <- read.table(paste0(path, "/OverallResults/Plasmid_Resistance_Counts.txt"), sep = ",", header = TRUE, comment.char = "", quote = "")
print(Data)
x <- Data[,1]
y <- Data[,2]
kind <- Data[,3]
#kind <- factor(kind, levels = c("Unassigned", "Circular", "Plasmid", "Genome"))

pdf(file = paste0(path, "/OverallResults/Resistance_Barplot.pdf"))
p <- ggplot(Data, aes(fill = kind, y = y, x = x)) + 
  geom_bar(position="stack", stat="identity")
p <- p + labs(x = "Sample ID", y = "Frequency", title = NULL, colour = NULL)
p <- p + theme(axis.text.x = element_text(angle = 90))
p
invisible(dev.off())
