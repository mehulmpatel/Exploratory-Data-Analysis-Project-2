# PA-Que-Plot5.R
source("ReadDataFile.R")

# Gather the subset of the NEI data which corresponds to vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicles.SCC <- SCC[vehicles,]$SCC
vehicles.NEI <- NEI[NEI$SCC %in% vehicles.SCC, ]

# Subset the vehicles NEI data to Baltimore's fip
baltimore.vehicles.NEI <- vehicles.NEI[vehicles.NEI$fips=="24510", ]

png("PA-Que-Plot5.png", width=480, height=480, units="px", bg="transparent")

library(ggplot2)

ggp <- ggplot(baltimore.vehicles.NEI, aes(factor(year), Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

print(ggp)

dev.off()

