rankall <- function(outcome, num = "best") {
  ## Definition of useful function
  ## http://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-an-integer-numeric-without-a-loss-of-information
  as.numeric.factor <- function(x) {suppressWarnings(as.numeric(levels(x))[x])}
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv")
  states <- levels(data$State)
  
  ## Convert 'factor' values to 'character' for specific lines
  data[,2] <- as.character(data[,2])

  if(sum(outcome == c("heart attack","heart failure","pneumonia")) == 0) {
    stop("invalid outcome")
  }
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  column <- numeric()
  if(outcome == "heart attack") {
    column <- 11
  } else if(outcome == "heart failure") {
    column <- 17
  } else {
    column <- 23
  }
  
  ## convert factor values to numeric values with coercion 
  data[,column] <- as.numeric.factor(data[,column])

  ## get rid of all rows where outcome has an NAs
  ## clean data from "Not Available" values
  data <- data[complete.cases(data[,column]),]
    
  ## define solution data.frame. I define first a matrix (because it is easier) and convert then ...
  rankall_solution <- as.data.frame(matrix(data=NA, nrow=length(states), ncol = 2,byrow = TRUE))
  colnames(rankall_solution) <- c("hospital","state")
  rownames(rankall_solution) <- states
  
  ## loop: take one state, order data after column, and name (alphabetically)
  for(i in 1:length(states)) {
    rankall_solution[i,2] <- states[i]
    statedata <- data[grep(states[i],data[,7]),]
    orderdata <- statedata[order(statedata[,column],statedata[,2]),]
    
    ## define rules for the rank
    if(num == "best") {
      place <- 1
      rankall_solution[i,1] <- orderdata[place,2]
    } else if(num == "worst") {
      place <- nrow(orderdata)
      rankall_solution[i,1] <- orderdata[place,2]
    } else if(num > nrow(orderdata)) {
      rankall_solution[i,1] <- NA
    } else if(num < 1) {
      rankall_solution[i,1] <- NA
    } else {
      place <- num
      rankall_solution[i,1] <- orderdata[place,2]
    }
  }

  ## Return data frame with hospital names and the (abbreviated) state name
    return(rankall_solution)
}