# PA-Que-Plot1.R
source("ReadDataFile.R")

# Aggregate by sum the total emissions by year
aggTotals <- aggregate(Emissions ~ year, NEI, sum)

# Set Plot Parameters
png("PA-Que-Plot1.png", width=480, height=480, units="px", bg="transparent")

# Define BAR Plot
barplot(
  (aggTotals$Emissions)/10^6,
  names.arg=aggTotals$year,
  xlab="Year",
  ylab="PM2.5 Emissions (10^6 Tons)",
  main="Total PM2.5 Emissions From All US Sources"
)

# Writing plot in file
dev.off()

