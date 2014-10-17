## R code for arbitrage loop problem

library(rjson)

#Import JSON from the API and read into R as a list
rates <- fromJSON(file="http://fx.priceonomics.com/v1/rates/")

#Remove exchange rates of currencies with itself where the rate = 1.0 
rates.noAuto <- subset(rates, !(substr(names(rates),1,3)==substr(names(rates),5,7)) )

#Use exchanges from USD to any other currency as an starting condition in calculation
rates.USD <- subset(rates.noAuto , grepl("USD_", names(rates.noAuto )) )

record.path <- NULL

#Define function spit() to spit out a list of all possible pathways starting with USD and ending with USD
spit <- function(cr, rec){
	for (i in 1:length(cr)){
		country.this <- substr(names(cr)[i],5,7)
		if(country.this=="USD" | length(rec)>=length(rates.USD)) { 
			if (country.this=="USD") {
				#print(paste(c(rec, names(cr)[i]), collapse=" ") )
				record.path <<- c(record.path, paste(c(rec, names(cr)[i]), collapse=" ") )
			}
			next 
		}
		cur.this <- paste(country.this, "_", collapse="", sep="")
		rates.this <- subset(rates.noAuto, grepl(cur.this, names(rates.noAuto)) )
		myReturn <- c(names(cr)[i], spit(rates.this, c(rec, names(cr)[i])) )
	}
}

#run the spit function to create a list of paths in the variable record.path
myrec <- NULL
spit(rates.USD, myrec )
names(record.path) <- record.path

#Split the paths by space delimiters
record.path.2 <- strsplit(record.path , " ")

#Replace the list of exchange rate sequences with their conversion values
z <- record.path.2 
for(i in 1:length(z)){
	for (j in 1:length(rates.noAuto)){
		z[[i]] <- replace(z[[i]], z[[i]]==names(rates.noAuto)[j], rates.noAuto[j])
	}
}

#Convert the exchange rates to numerics and take the product of all exchanges of the sequences
z.1 <- sapply(z, as.numeric)
answer <- sapply(z.1, prod)

#Display the pathway and yield of all arbitrage loops from highest to lowest return
sort(answer, decreasing=TRUE)




## Diagram of 'spit' function traversals; example for 4 currencies including USD

library(diagram)
par( mfrow = c(1, 1))

#Custom plot representation parameters
names <- c(rep(c("USD", "JPY", "EUR", "BTC"),5), rep("...",2), rep("", (4*2)-2))
M <- matrix(nrow = length(names), ncol = length(names), byrow = TRUE, data = 0)
M[2:4,1] <- ""
M[5:8,2] <- ""
M[9:12,3] <- ""
M[13:16,4] <- ""
M[17:20,7] <- ""
Col <- rep("white", length(names))
Col[names=='USD'] <- "red"
Col[1] <- "green"
Col[c(6,11,16,19)] <- "grey"
Box <- rep(2, length(names))
Box[21:length(names)] <- 1
Box_size <- rep(0.03, length(names))
Box_size[23:length(names)] <- 0

#Create Plot
plotmat(M, pos = c(1, 3, 4*3, 4*3), name = names, lwd = 1,
box.lwd = Box, cex.txt = 0.4, box.size = Box_size,
box.type = "square", box.prop = 0.5,
shadow.size=0.005, box.col= Col)

#Insert Legend
legend("topright", inset=0, title="Pathway Building Events",
  	c("Start","Stop", "Ignore"), fill=c("green","red", "grey"))

