pollutantmean <- function(directory = "specdata", pollutant="sulfate", id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'pollutant' is a character vector of length 1 indicating
      ## the name of the pollutant for which we will calculate the
      ## mean; either "sulfate" or "nitrate".
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return the mean of the pollutant across all monitors list
      ## in the 'id' vector (ignoring NA values)
      ## NOTE: Do not round the result!
      setwd(directory)
      
      pm_file_names <- list.files(pattern="*.csv")
      pm_data <- data.frame()
      
      for (i in 1:length(id)) {
            pm_data <- rbind(pm_data, read.csv(pm_file_names[id[i]]))
      }
      setwd("..")
      pollutant_mean <- mean(pm_data[,pollutant],na.rm = TRUE)
      print(pollutant_mean)
}