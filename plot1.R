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

# Get the result
result <- summarise(group_by(NEI,year),sum(Emissions,na.rm = TRUE))
result <- as.data.frame(result)

# Plot the data
png("plot1.png", width=640, height=480, units = "px", type="quartz")
plot(result, xaxt="n", main = expression(paste("Total ","PM"[2.5]," Emission in the US (1999-2008)")), 
     xlab = "Year", ylab = expression(paste("Total ","PM"[2.5]," Emission (tons)")),
     pch = 19, cex = 1.2, col = "blue", ylim=c(3.e+06,8.e+06))
axis(1, at = seq(1999, 2008, by = 3), las=2)
lines(result, type = "l", lwd = 2, col = "red")

# Save and quit
dev.off()