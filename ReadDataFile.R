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
