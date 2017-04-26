# Download the data
emission.data.file.name <- "summarySCC_PM25.rds"
classification.data.file.name <- "Source_Classification_Code.rds"
if(!file.exists(emission.data.file.name) || !file.exists(classification.data.file.name)) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  "data.zip",
                  method = "curl")
    unzip("data.zip")
    file.remove("data.zip")
}

# Load the data into memory
NEI <- readRDS(emission.data.file.name)
SCC <- readRDS(classification.data.file.name)

# Require dplyr
if(!require(dplyr)) {
    install.packages("dplyr")
    require(dplyr)
}

# Require ggplot2
if(!require(ggplot2)) {
    install.packages("ggplot2")
    require(ggplot2)
}

# Get the result
NEI_Baltimore <- NEI[NEI$fips == "24510",]
result <- summarise(group_by(NEI_Baltimore,year,type),sum(Emissions,na.rm = TRUE))
result <- as.data.frame(result)
names(result)[3] <- "Emissions" 

# Plot the data
p <- qplot(year, Emissions, data=result, col = type) + geom_line(lwd = 1) + geom_point(size=2, shape=21, fill="white")
p <- p + labs(title = expression(paste("Total ","PM"[2.5]," Emission in Baltimore by Emission Type (1999-2008)")),
              x = "Year", y = expression(paste("Total ","PM"[2.5]," Emission (tons)")),
              colour = "Emmision Type") + theme(plot.title = element_text(hjust = 0.5))
png("plot3.png", width=640, height=480, units = "px", type="quartz")
print(p)

# Save and quit
dev.off()

