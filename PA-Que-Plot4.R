# PA-Que-Plot4.R
source("ReadDataFile.R")

# Subset coal combustion related NEI data
combustion.related <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal.related <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coal.combustion <- (combustion.related & coal.related)
combustion.SCC <- SCC[coal.combustion, ]$SCC
combustion.NEI <- NEI[NEI$SCC %in% combustion.SCC, ]

png("PA-Que-Plot4.png",width=480,height=480,units="px",bg="transparent")

library(ggplot2)

ggp <- ggplot(combustion.NEI, aes(factor(year), Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey", width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

print(ggp)

dev.off()

