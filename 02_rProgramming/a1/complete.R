complete <- function(directory= "specdata", id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return a data frame of the form:
      ## id nobs
      ## 1  117
      ## 2  1041
      ## ...
      ## where 'id' is the monitor ID number and 'nobs' is the
      ## number of complete cases
      
      setwd(directory)
      
      pm_file_names <- list.files(pattern="*.csv")
      pm_complete <- data.frame(matrix(NA, nrow=length(id),ncol=2))
      colnames(pm_complete) <- c("id","nobs")
      
      for (i in 1:length(id)) {
            temp <- read.csv(pm_file_names[id[i]])
            pm_complete[i,1] <- temp[1,4]
            pm_complete[i,2] <- sum(!is.na(temp$sulfate) & !is.na(temp$nitrate))
      }
      setwd("..")
      pm_complete
}