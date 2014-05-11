#This data set has about 2,075,259 rows and 9 columns
#This will take less than a gigabyte of memory
#Only want to read from february 1 2007-february 2 2007

#setwd("~/Dropbox/Coursera_DataAnalysisR/4ExploratoryDataAnalysis/ProgrammingAssignments")
classes=c("factor","factor","factor","factor","factor","factor","factor","factor","numeric")
data=read.table("household_power_consumption.txt",
                colClasses=classes,
                nrows=2880,
                #With 2881, last date is too late
                comment.char="", 
                skip=66637,#This is n below
                #With skip=66636, we have one date too early
                sep=";")
names=c("Date","Time","Global_active_power","Global_reactive_power", "Voltage","Global_intensity","Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
colnames(data)<-names
DaysTimes=paste(data$Date,data$Time)
#head(DaysTimes)
#class(DaysTimes)
DaysTimes=as.POSIXct(DaysTimes,format="%d/%m/%Y %H:%M:%S")
#head(DaysTimes)

#Right now, 3rd column is a factor and using as.numeric will 
#return the factor level as a number
#i.e. data[,3]=as.numeric(data[,3]) #WILL NOT WORK
data[,3]=as.numeric(as.character(data[,3]))
data[,4]=as.numeric(as.character(data[,4]))
data[,5]=as.numeric(as.character(data[,5]))
data[,7]=as.numeric(as.character(data[,7]))
data[,8]=as.numeric(as.character(data[,8]))
data[,9]=as.numeric(as.character(data[,9]))
#summary(data[,3])

par(mfrow=c(2,2),cex=0.65)
plot(DaysTimes,data$Global_active_power,
     type="l",
     ylab="Global Active Power",
     xlab=""
)

plot(DaysTimes,data[,5],
     type="l",
     ylab="Voltage",
     xlab="datetime"
)

with(data,plot(DaysTimes,data[,7],
               type="l",
               ylab="Energy sub metering",
               xlab=""
)
)
with(data,lines(DaysTimes,data[,8],
                col="red")
)
with(data,lines(DaysTimes,data[,9],
                col="blue")
)
legend("topright",
       col=c("black","red","blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=1,
       cex=.3,
       bty="n"
)

plot(DaysTimes,data[,4],
     type="l",
     ylab="Global_reactive_power",
     xlab="datetime"
)

dev.copy(png,file="plot4.png")#Default is 480x480
dev.off()



##Code that helped me figure out how to optimize reading the data into R

#classes=sapply(data,class) #Used to figure out the classes of the columns
#head(data)#Peak at the data
#data[1,1] #Seems like the bounds are too wide
#data[2880,1]
#dim(data)

###The following code confirms that the the dates that interest us
##are between 66636 and
##Tried a for loop, don't bother
#x=as.Date(data[,1], format="%d/%m/%Y")
#Early=x[x< as.Date("2007-02-01")]
#n=length(Early)#No observations too early
#checkE=x[1:n] #First n obs in x, hopefully all the earlies
##If subset checkE by earlies, if I have n, I have all of them
#n==length(checkE[checkE< as.Date("2007-02-01")])
#n
#Late=x[x>as.Date("2007-02-02")]
#m=length(Late)
#checkL=x[(2075259-(m-1)):2075259]
#m==length(checkL[checkL>as.Date("2007-02-02")])
#y=x[x>=as.Date("2007-02-01")]
#z=y[y<= as.Date("2007-02-02")]
#length(z)#This is the number of observations on our dates