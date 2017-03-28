rankhospital <- function(state, outcome, num = "best") {
  ## Definition of useful function
  ## http://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-an-integer-numeric-without-a-loss-of-information
  as.numeric.factor <- function(x) {suppressWarnings(as.numeric(levels(x))[x])}
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv")
  
  ## Convert 'factor' values to 'character' for specific lines
  data[,2] <- as.character(data[,2])
  
  ## Check that state and outcome are valid
  if(sum(state == data$State) == 0) {
    stop("invalid state")
  }
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
  data <- data[complete.cases(data[,column]),]
  
  ## clean data from "Not Available" values
  statedata <- data[grep(state,data[,7]),]
  orderdata <- statedata[order(statedata[,column],statedata[,2]),]
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  if(num == "best") {
    place <- 1
  } else if(num == "worst") {
    place <- nrow(orderdata)
  } else if(num > nrow(orderdata)) {
    result <- NA
    return(result)
  } else if(num < 1) {
    result <- NA
    return(result)
  } else {
    place <- num
  }
    
  return(orderdata[place,2])
  
}