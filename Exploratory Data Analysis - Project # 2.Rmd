# *Exploratory Data Analysis - Course Project 2*

# Introduction as Instruction given 

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National [Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

The zip file contains two files:

- PM2.5 Emissions Data (`summarySCC_PM25.rds`): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

- Source Classification Code Table (`Source_Classification_Code.rds`): This table provides a mapping from the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

# Define Common Function to read files from working dir -

```{r setup, echo=FALSE}
# ReadDataFile.R
# Download archive file, if it does not exist
setwd("C://myCode-R")

# Checking for specific file to archive
if(!(file.exists("summarySCC_PM25.rds") && 
	file.exists("Source_Classification_Code.rds"))) { 
  print ("Files (summarySCC_PM25.rds & Source_Classification_Code.rds) not found in working dir.")
  } else { 
    print ("Files (summarySCC_PM25.rds & Source_Classification_Code.rds) found in working dir.")
    # Load the NEI & SCC data frames.
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
  }

```

# Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999-2008. 
Using R package to support analysis.

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

### Question 1

**Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?**

1) We'll aggregate the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

2) Using the base plotting system, now we plot the total PM2.5 Emission from all sources.


```{r plot1, cache=TRUE}

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
```

**Conclusion:** As we can see from the plot, total emissions have decreased in the US from 1999 to 2008.

### Question 2

**Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?**

1) First find aggregate total emissions from PM2.5 for Baltimore City, Maryland (fips="24510") from 1999 to 2008.

2) Now use the base plotting system to make a plot of this data.

```{r plot2}
# PA-Que-Plot2.R
source("ReadDataFile.R")

# Subset NEI data by Baltimore's fip.
baltimoreNEI <- NEI[NEI$fips=="24510",]

# Aggregate using sum the Baltimore emissions data by year
aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI, sum)

png("PA-Que-Plot2.png",width=480,height=480,units="px",bg="transparent")

barplot(
  aggTotalsBaltimore$Emissions,
  names.arg=aggTotalsBaltimore$year,
  xlab="Year",
  ylab="PM2.5 Emissions (Tons)",
  main="Total PM2.5 Emissions From all Baltimore City Sources"
)

dev.off()
```

**Conclusion:** Overall total emissions from PM2.5 have decreased in Baltimore City, Maryland from 1999 to 2008.

### Question 3

**Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008?**
**Use the ggplot2 plotting system to make a plot answer this question.**

```{r plot3}
# PA-Que-Plot3.R
source("ReadDataFile.R")

# Subset NEI data by Baltimore's fip.
baltimoreNEI <- NEI[NEI$fips=="24510", ]

# Aggregate using sum the Baltimore emissions data by year
aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI, sum)

png("PA-Que-Plot3.png", width=480, height=480, units="px", bg="transparent")

library(ggplot2)

ggp <- ggplot(baltimoreNEI, aes(factor(year), Emissions, fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)

dev.off()
```

### Question 4

**Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?**

1) Subset coal combustion source factors NEI data.

```{r plot4}
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
```

**Conclusion:** Emissions from coal combustion related sources have decreased from 6 * 10^6 to below 4 * 10^6 from 1999-2008.

### Question 5

**How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?**

1) Subset the motor vehicles, which we assume is anything like Motor Vehicle in SCC.Level.Two.

2) Subset for motor vehicles in Baltimore and finally we plot using ggplot2.

```{r plot5}
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
```

**Conclusion:** Emissions from motor vehicle sources have dropped from 1999-2008 in Baltimore City!

### Question 6

**Which city has seen greater changes over time in motor vehicle emissions?**

1) Comparing emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"),

2) Plot using the ggplot2 system,

```{r plot6}
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
```

**Conclusion:** Los Angeles County has seen the greatest changes over time in motor vehicle emissions.
