corr <- function(directory="specdata", threshold = 0) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'threshold' is a numeric vector of length 1 indicating the
      ## number of completely observed observations (on all
      ## variables) required to compute the correlation between
      ## nitrate and sulfate; the default is 0
      
      ## Return a numeric vector of correlations
      ## NOTE: Do not round the result!
      complete_SulNit_pairs <- complete(directory)
      pm_corr <- vector()
      length(pm_corr) <- sum(complete_SulNit_pairs[,2] > threshold)
      
      setwd(directory)
      pm_file_names <- list.files(pattern="*.csv")
      
      k <- 1
      for (i in 1:length(pm_file_names)) {
            if(complete_SulNit_pairs[i,2] > threshold) {
                  temp <- read.csv(pm_file_names[complete_SulNit_pairs[i,1]])
                  pm_corr[k] <-  cor(temp$sulfate,temp$nitrate,use = "complete.obs")
                  k <- k+1
            }
      }
      setwd("..")
      corr <- pm_corr
}