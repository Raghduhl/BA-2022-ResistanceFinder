library(ggplot2)
myargs = commandArgs(trailingOnly=TRUE)
path <- myargs[1]
Data <- read.csv(paste0(path, "/OverallResults/PlasmidCounts.csv"), header = TRUE)
x <- Data[,1]
y <- Data[,2]
Kind <- Data[,3]
Kind <- factor(Kind, levels = rev(c("Genome", "Blast_Genome", "Coverage_Genome", "Plasmids", "Circular", "Pseudo_Circular", "Unassigned")))


pdf(file = paste0(path, "/OverallResults/Plasmid_Barplot_all.pdf"))
p <- ggplot(Data, aes(fill = Kind, y = y, x = x)) + 
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = rev(c("#200AC9", "#055df5", "#05a1f5", "#035e06", "#269906", "#36eb3c", "#E30707")),
                    labels = rev(c("Chromosom", "BLAST-Chromosom", "Coverage-Chromosom", "Plasmid", "Ringförmig", "Verkettet ringförmig", "Nicht zugewiesen")),
                    name = NULL)
p <- p + labs(x = "Proben ID", y = "Häufigkeit", title = "Häufigkeiten der verschiedenen contig-Arten", colour = NULL)
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
p
invisible(dev.off())

adaptData =Data[Data[,3] %in% c("Genome", "Blast_Genome", "Coverage_Genome"),]
x <- adaptData[,1]
y <- adaptData[,2]
Kind <- adaptData[,3]
Kind <- factor(Kind, levels = rev(c("Genome", "Blast_Genome", "Coverage_Genome")))

pdf(file = paste0(path, "/OverallResults/Plasmid_Barplot_genome.pdf"))
p <- ggplot(adaptData, aes(fill = Kind, y = y, x = x)) + 
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = rev(c("#200AC9", "#055df5", "#05a1f5")),
                    labels = rev(c("Chromosom", "BLAST-Chromosom", "Coverage-Chromosom")),
                    name = NULL)
p <- p + labs(x = "Proben ID", y = "Häufigkeit", title = paste0("Häufigkeiten der mit dem Chromosom assoziierten contig-Arten"), colour = NULL)
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
p
invisible(dev.off())


adaptData =Data[Data[,3] %in% c("Plasmids", "Circular", "Pseudo_Circular"),]
x <- adaptData[,1]
y <- adaptData[,2]
Kind <- adaptData[,3]
Kind <- factor(Kind, levels = rev(c("Plasmids", "Circular", "Pseudo_Circular")))

pdf(file = paste0(path, "/OverallResults/Plasmid_Barplot_plasmid.pdf"))
p <- ggplot(adaptData, aes(fill = Kind, y = y, x = x)) + 
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = rev(c("#035e06", "#269906", "#36eb3c")),
                    labels = rev(c("Plasmid", "Ringförmig", "Verkettet ringförmig")),
                    name = NULL)
p <- p + labs(x = "Proben ID", y = "Häufigkeit", title = "Häufigkeiten der mit Plasmiden assoziierten contig-Arten", colour = NULL)
p <- p + theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
p
invisible(dev.off())
