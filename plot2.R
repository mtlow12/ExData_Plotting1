#Unzip file and extract its contents
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
td <- tempdir()
tf <- tempfile(tmpdir = td, fileext=".zip")
download.file(fileURL, tf)
fname <- unzip(tf, list=TRUE)$Name[1]
unzip(tf, files=fname, exdir=td, overwrite=TRUE)
fpath <- file.path(td, fname)

#Read file in and filter on 2/1/07 and 2/2/07 data only
d <- read.table(fpath, header=TRUE, sep=";", stringsAsFactors=FALSE)
d$Date <- as.Date(d$Date, format="%d/%m/%Y")
d <- d[d$Date=="2007-02-01"|d$Date=="2007-02-02",]

datetime <- as.POSIXct(paste(d$Date, d$Time), format="%Y-%m-%d %H:%M:%S")
d <- cbind(d,datetime)

d$Global_active_power <- as.numeric(d$Global_active_power)

#Create scatterplot
par(mfrow = c(1,1))
with(d, plot(d$datetime, d$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab="", pch=".", lines(d$datetime,d$Global_active_power)))

#Copy my plot to a PNG file
dev.copy(png, file = "plot2.png", width = 480, height = 480) 
dev.off() 