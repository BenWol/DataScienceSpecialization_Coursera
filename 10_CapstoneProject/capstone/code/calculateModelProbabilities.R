library(beepr)
library(data.table)
library(tau)
library(plyr)

### set working directory

###########################################################################################################
# The script calculates word probabilites using a) the Kneser-Ney smoothing and b) to simple backoff      #
# smoothing. The probabilites are being saved in an overall list of data.tables that hold all probabilites#
# of up to n<=4 grams. The calculation is applied according to http://smithamilli.com/blog/kneser-ney/ and#
# other sources like wikipedia or the video series of Opencourseonline.com, Stanford NLP, Professor Dan   #
# Jurafsky & Chris Manning, Videos 4-1 to 4-8
###########################################################################################################

# 1. Calculation of Kneser-Ney smoothed probabilities, starting with n=2 to then recursively increase the
# order of the ngram, and calculate the KN probability according to the formula in the documentation.

###############
### Bigrams ###
###############
load("totalBigrams.RData")
totalBigramsKN <- totalBigrams[count > 1]
bigrams <- do.call(rbind, strsplit(totalBigramsKN$ngram, split = " "))
totalBigramsKN$ngram <- bigrams[, 1]
totalBigramsKN$nextword <- bigrams[, 2]
# clean corpus of bigrams with symbols as words
delete <- grep("['+\\/+<+>+]", totalBigramsKN$ngram)
totalBigramsKN <- totalBigramsKN[-delete, ]
# rm(bigrams) for saving memory space
setkey(totalBigramsKN, "count", "ngram")
# Discounting according to http://smithamilli.com/blog/kneser-ney/
totalBigramsKN[, D := 0]
Y <- (nrow(totalBigramsKN[count == 2]) /
        (nrow(totalBigramsKN[count == 2]) + 2 * nrow(totalBigramsKN[count == 3])))
totalBigramsKN[count == 1]$D <- 1 - 2 * Y * (nrow(totalBigramsKN[count == 2]) /  nrow(totalBigramsKN[count == 1]))
totalBigramsKN[count == 2]$D <- 2 - 3 * Y * (nrow(totalBigramsKN[count == 3]) / nrow(totalBigramsKN[count == 2]))
totalBigramsKN[count > 2]$D <- 3 - 4 * Y * (nrow(totalBigramsKN[count == 4]) / nrow(totalBigramsKN[count == 3]))
totalBigramsKN[, count := count - D]
# Division by c(w_{i-1}): Count of totalBigramsKN$ngram (from totalUnigrams)
load("totalUnigrams.RData")
totalBigramsKN <- merge(totalBigramsKN, totalUnigrams, by = "ngram")
setnames(totalBigramsKN, c("ngram", "count", "nextword", "D", "ngramcount"))
totalBigramsKN[, count := count / ngramcount]
# calculate weighting factor lambda
totalBigramsKN[, lambda := D / ngramcount]
NNextwords <- totalBigramsKN[, .(ngram.NNextwords = length(nextword)), by = ngram]
totalBigramsKN <- merge(totalBigramsKN, NNextwords, by = "ngram")
rm(NNextwords)
totalBigramsKN[, lambda := lambda * ngram.NNextwords]
# calculate P(continuation) for recursive iterations
NNewCont <- totalBigramsKN[, .(nextword.NNewCont = length(ngram)), by = nextword]
totalBigramsKN <- merge(totalBigramsKN, NNewCont, by = "nextword")
totalBigramsKN[, Pcont := nextword.NNewCont / nrow(totalBigramsKN)]
# combination of lambda * Pcont to the term for P_{KN}
totalBigramsKN[, count := count + lambda * Pcont]
save(totalBigramsKN, file = "totalBigramsKN.RData")

################
### Trigrams ###
################
load("totalTrigrams.RData")
totalTrigrams <- totalTrigrams[count > 1]
save(totalTrigrams, file = "totalTrigrams_reduced.RData")
load("totalTrigrams_reduced.RData")
totalTrigramsKN <- totalTrigrams
rm(totalTrigrams); gc()
trigrams <- do.call(rbind, strsplit(totalTrigramsKN$ngram, split = " "))
totalTrigramsKN$ngram <-  apply(trigrams[, 1:2], 1,
                              FUN = function(x) paste(x, collapse = " "))
totalTrigramsKN$nextword <- trigrams[, 3]
# clean corpus of trigrams with symbols as words
delete <- grep("['+\\/+<+>+]", totalTrigramsKN$ngram)
totalTrigramsKN <- totalTrigramsKN[-delete, ]
rm(trigrams)
setkey(totalTrigramsKN, "count", "ngram")
# Discounting according to http://smithamilli.com/blog/kneser-ney/
totalTrigramsKN[, D := 0]
# using trigrams with count = 2 or 3
Y <- (nrow(totalTrigramsKN[count == 2]) / (nrow(totalTrigramsKN[count == 2]) + 2 * nrow(totalTrigramsKN[count == 3])))
totalTrigramsKN[count == 2]$D <- 2 - 3 * Y * (nrow(totalTrigramsKN[count == 3]) / nrow(totalTrigramsKN[count == 2]))
totalTrigramsKN[count > 2]$D <- 3 - 4 * Y * (nrow(totalTrigramsKN[count == 4]) / nrow(totalTrigramsKN[count == 3]))
totalTrigramsKN[, count := count - D]
# Division by c(w_{i-1}): Count of totalTrgramsKN$ngram (from totalBigrams)
load("totalBigrams.RData")
totalTrigramsKN <- merge(totalTrigramsKN, totalBigrams, by = "ngram")
setnames(totalTrigramsKN, c("ngram", "count", "nextword", "D", "ngramcount"))
totalTrigramsKN[, count := count / ngramcount]
rm(totalBigrams); gc()
# calculate weighting factor lambda
totalTrigramsKN[, lambda := D / ngramcount]
NNextwords <- totalTrigramsKN[, .(ngram.NNextwords = length(nextword)), by = ngram]
totalTrigramsKN <- merge(totalTrigramsKN, NNextwords, by = "ngram")
rm(NNextwords)
totalTrigramsKN[, lambda := lambda * ngram.NNextwords]
# second part of the n-grams for the combined set of bigrams
load("totalBigramsKN.RData")
lowerNgram <- as.character(sapply(totalTrigramsKN$ngram, function(x) unlist(strsplit(x, split = " "))[2]))
totalTrigramsKN <- cbind(totalTrigramsKN, lowerNgram)
totalBigramsKN2 <- totalBigramsKN[, .(ngram, nextword, count)]
rm(totalBigramsKN); gc()
setnames(totalBigramsKN2, c("lowerNgram", "nextword", "count"))
totalTrigramsKN <- merge(totalTrigramsKN, totalBigramsKN2, by = c("lowerNgram", "nextword"))
setnames(totalTrigramsKN, c("lowerNgram", "nextword", "ngram", "count", "D", "ngramcount", "lambda", "ngram.NNextwords","PknLower"))
# additional lambda * PknLower to the term for P_{KN}
totalTrigramsKN[, count := count + lambda * PknLower]
save(totalTrigramsKN, file = "totalTrigramsKN.RData")

#################
### Fourgrams ###
#################
load("totalFourgrams.RData")
totalFourgrams <- totalFourgrams[count > 1]
save(totalFourgrams, file = "totalFourgrams_reduced.RData")
load("totalFourgrams_reduced.RData")
totalFourgramsKN <- totalFourgrams
rm(totalFourgrams); gc()
fourgrams <- do.call(rbind, strsplit(totalFourgramsKN$ngram, split = " "))
totalFourgramsKN$ngram <-  apply(fourgrams[, 1:3], 1, FUN = function(x) paste(x, collapse = " "))
totalFourgramsKN$nextword <- fourgrams[, 4]
# clean corpus of fourgrams with symbols as words
delete <- grep("['+\\/+<+>+]", totalFourgramsKN$ngram)
totalFourgramsKN <- totalFourgramsKN[-delete, ]
rm(fourgrams)
setkey(totalFourgramsKN, "count", "ngram")
# Discounting according to http://smithamilli.com/blog/kneser-ney/
totalFourgramsKN[, D := 0]
Y <- (nrow(totalFourgramsKN[count == 2]) /
        (nrow(totalFourgramsKN[count == 2]) + 2 * nrow(totalFourgramsKN[count == 3])))
totalFourgramsKN[count == 2]$D <- 2 - 3 * Y * (nrow(totalFourgramsKN[count == 3]) / nrow(totalFourgramsKN[count == 2]))
totalFourgramsKN[count > 2]$D <- 3 - 4 * Y * (nrow(totalFourgramsKN[count == 4]) / nrow(totalFourgramsKN[count == 3]))
totalFourgramsKN[, count := count - D]
# Division by c(w_{i-1}): Count of totalFourgramsKN$ngram (from totalTrigrams)
load("totalTrigrams_reduced.RData")
totalFourgramsKN <- merge(totalFourgramsKN, totalTrigrams, by = "ngram")
setnames(totalFourgramsKN, c("ngram", "count", "nextword", "D", "ngramcount"))
totalFourgramsKN[, count := count / ngramcount]
rm(totalTrigrams); gc()
# calculate weighting factor lambda
totalFourgramsKN[, lambda := D / ngramcount]
NNextwords <- totalFourgramsKN[, .(ngram.NNextwords = length(nextword)), by = ngram]
totalFourgramsKN <- merge(totalFourgramsKN, NNextwords, by = "ngram")
rm(NNextwords)
totalFourgramsKN[, lambda := lambda * ngram.NNextwords]
# second part of the n-grams for the combined set of trigrams
load("totalTrigramsKN.RData")
lowerNgram <- as.character(sapply(totalFourgramsKN$ngram, function(x){ paste(unlist(strsplit(x, split = " "))[2:3], collapse = " ")}))
totalFourgramsKN <- cbind(totalFourgramsKN, lowerNgram)
totalTrigramsKN2 <- totalTrigramsKN[, .(ngram, nextword, count)]
rm(totalTrigramsKN); gc()
setnames(totalTrigramsKN2, c("lowerNgram", "nextword", "count"))
totalFourgramsKN <- merge(totalFourgramsKN, totalTrigramsKN2, by = c("lowerNgram", "nextword"))
setnames(totalFourgramsKN, c("lowerNgram", "nextword", "ngram", "count", "D", "ngramcount", "lambda", "ngram.NNextwords","PknLower"))
# additional lambda * PknLower to the term for P_{KN}
totalFourgramsKN[, count := count + lambda * PknLower]
save(totalFourgramsKN, file = "totalFourgramsKN.RData")

######################################################################################################################
### Combination all calculated ngram probabilities in one list of data.tables, that can be loaded in the shiny app.  #
######################################################################################################################

load("totalTrigrams_reduced.RData")
load("totalBigrams.RData")
load("totalUnigrams.RData")
totalUnigrams_en <- totalUnigrams[count > 3]
totalBigrams_en <- totalBigrams[count > 3]
totalTrigrams_en <- totalTrigrams[count > 3]
rm(totalUnigrams, totalBigrams, totalTrigrams)
load("totalFourgrams_reduced.RData")
totalFourgrams_en <- totalFourgrams[count > 2]
rm(totalFourgrams)

# splitting up the n grams in their individual words
fourgrams <- do.call(rbind, strsplit(totalFourgrams_en$ngram, split = " "))
fourgrams <- cbind(apply(fourgrams[, 1:3], 1, function(x) paste(x, collapse = " ")),fourgrams[, 4])
totalFourgrams_en$ngram <- fourgrams[, 1]
totalFourgrams_en$nextword <- fourgrams[, 2]
# Taking out the words including '
delete <- grep(pattern = "^'+", totalFourgrams_en$ngram)
totalFourgrams_en <- totalFourgrams_en[-delete, ]
delete <- grep(pattern = "^'+", totalFourgrams_en$nextword)
totalFourgrams_en <- totalFourgrams_en[-delete, ]

trigrams <- do.call(rbind, strsplit(totalTrigrams_en$ngram, split = " "))
trigrams <- cbind(apply(trigrams[, 1:2], 1, function(x) paste(x, collapse = " ")), trigrams[, 3])
totalTrigrams_en$ngram <- trigrams[, 1]
totalTrigrams_en$nextword <- trigrams[, 2]
# Taking out the words including '
delete <- grep(pattern = "^'+", totalTrigrams_en$ngram)
totalTrigrams_en <- totalTrigrams_en[-delete, ]
delete <- grep(pattern = "^'+", totalTrigrams_en$nextword)
totalTrigrams_en <- totalTrigrams_en[-delete, ]

bigrams <- do.call(rbind, strsplit(totalBigrams_en$ngram, split = " "))
totalBigrams_en$ngram <- bigrams[, 1]
totalBigrams_en$nextword <- bigrams[, 2]
# Taking out the words including '
delete <- grep(pattern = "^'+", totalBigrams_en$ngram)
totalBigrams_en <- totalBigrams_en[-delete, ]
delete <- grep(pattern = "^'+", totalBigrams_en$nextword)
totalBigrams_en <- totalBigrams_en[-delete, ]

# Taking in the KN smoothed ngrams
load("totalFourgramsKN.RData")
load("totalTrigramsKN.RData")
totalTrigramsKN_en <- totalTrigramsKN[, .(ngram, nextword, count)]
totalFourgramsKN_en <- totalFourgramsKN[, .(ngram, nextword, count)]
rm(totalTrigramsKN, totalFourgramsKN)
load("totalBigramsKN.RData")
totalBigramsKN_en <- totalBigramsKN[, .(ngram, nextword, count)]
rm(totalBigramsKN)
# Taking out the words including '
delete <- grep(pattern = "^'+", totalBigramsKN_en$ngram)
delete <- c(delete, grep(pattern = "^'+", totalBigramsKN_en$nextword))
totalBigramsKN_en <- totalBigramsKN_en[-delete, ]
delete <- grep(pattern = "^'+", totalTrigramsKN_en$ngram)
delete <- c(delete, grep(pattern = "^'+", totalTrigramsKN_en$nextword))
totalTrigramsKN_en <- totalTrigramsKN_en[-delete, ]
delete <- grep(pattern = "^'+", totalFourgramsKN_en$ngram)
delete <- c(delete, grep(pattern = "^'+", totalFourgramsKN_en$nextword))
totalFourgramsKN_en <- totalFourgramsKN_en[-delete, ]

rm(bigrams, trigrams, fourgrams)
setkey(totalUnigrams_en, "count", "ngram")
setkey(totalBigrams_en, "count", "ngram")
setkey(totalTrigrams_en, "count", "ngram")
setkey(totalFourgrams_en, "count", "ngram")
setkey(totalBigramsKN_en, "count", "ngram")
setkey(totalTrigramsKN_en, "count", "ngram")
setkey(totalFourgramsKN_en, "count", "ngram")

# Rename simple unigram data
setnames(totalUnigrams_en, c("nextword", "count"))

totalData <- list(totalBigrams_en, totalBigramsKN_en, totalFourgrams_en, totalFourgramsKN_en, totalUnigrams_en, totalTrigrams_en, totalTrigramsKN_en)
names(totalData) <- c('totalBigrams_en', 'totalBigramsKN_en', 'totalFourgrams_en', 'totalFourgramsKN_en', 'totalUnigrams_en', 'totalTrigrams_en','totalTrigramsKN_en')
save(totalData, file = "totalData.RData")

######################################################################################################
### calculation of the minimum and maximum probabilities / counts for normalized probabilites      ###
######################################################################################################
totalData <- lapply(totalData, function(x){x[nextword != "<"]})

# in order to limit the data set loaded in the shiny application, and hence to 
# speed up the application, we cut the data.tables in the overall list of ngram
# probabilities in half
totalData_slim <- totalData
totalData_slim <- lapply(totalData_slim, function(x){x[nextword != "<"]})
totalData_slim <- lapply(totalData_slim, function(x){
  len <- nrow(x)
  return(x[round(len / 2) : len, ])
})
save(totalData_slim, file = "totalData_slim.RData")

# minimum and maximum for normalized propabilities
minmax <- lapply(totalData_slim, function(x){
  data.table(mininum = min(x$count), maximum = max(x$count))})
save(minmax, file = "minmax.RData")