# PA-Que-Plot6.R
source("ReadDataFile.R")

# Gather the subset of the NEI data which corresponds to vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicles.SCC <- SCC[vehicles,]$SCC
vehicles.NEI <- NEI[NEI$SCC %in% vehicles.SCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehicles.baltimore.NEI <- vehicles.NEI[vehicles.NEI$fips=="24510",]
vehicles.baltimore.NEI$city <- "Baltimore City"

vehicles.LA.NEI <- vehicles.NEI[vehicles.NEI$fips=="06037",]
vehicles.LA.NEI$city <- "Los Angeles County"

# Combine the two subsets with city name into one data frame
both.NEI <- rbind(vehicles.baltimore.NEI, vehicles.LA.NEI)

png("PA-Que-Plot6.png", width=480, height=480, units="px", bg="transparent")

library(ggplot2)
 
ggp <- ggplot(both.NEI, aes(x=factor(year), y=Emissions, fill=city)) +
 geom_bar(aes(fill=year),stat="identity") +
 facet_grid(scales="free", space="free", .~city) +
 guides(fill=FALSE) + theme_bw() +
 labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
 labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))
 
print(ggp)

dev.off()


