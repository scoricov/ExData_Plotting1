library(dplyr)
library(lubridate)

# --- ETL phase

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destFile <- "household_power_consumption.txt"
tempFile <- tempfile()
download.file(fileURL, destfile = tempFile, method = "curl")
unzip(tempFile, exdir = ".")
unlink(tempFile)
f <- file(destFile, "r")
d <- read.table(text = grep("^[12]/2/2007", readLines(f), value = TRUE),
                header = FALSE, sep = ";", quote = "", dec = ".", na.strings = "?",
                skipNul = TRUE, blank.lines.skip = TRUE, stringsAsFactors = FALSE,
                col.names = c("Date", "Time", "Global_active_power",
                              "Global_reactive_power", "Voltage", "Global_intensity",
                              "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) %>%
    mutate(DateTime = parse_date_time(paste(Date, Time, sep = " "), "%d/%m/%Y %H:%M:%S")) %>%
    select(DateTime, Global_active_power, Global_reactive_power, Voltage,
           Global_intensity, Sub_metering_1, Sub_metering_2, Sub_metering_3)

# --- Plotting phase

par(mfrow = c(2, 2))
plot(d$DateTime, d$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
plot(d$DateTime, d$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
plot(d$DateTime, d$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(d$DateTime, d$Sub_metering_2, col = "red")
lines(d$DateTime, d$Sub_metering_3, col = "blue")
legend("topright",
       col = c("black", "red", "blue"),
       cex = 0.7,
       lty = 1,
       bty = "n",
       legend = c("Sub_metering_1         ",
                  "Sub_metering_2         ",
                  "Sub_metering_3         "))
plot(d$DateTime,
     d$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global Reactive Power")

# --- Copy plot to PNG file

dev.copy(png, file = "plot4.png")
dev.off()

