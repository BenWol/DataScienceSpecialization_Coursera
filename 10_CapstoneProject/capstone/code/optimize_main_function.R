library(data.table)

###################
### load data   ###
###################
load("totalData_slim.RData")
load("minmax.RData")

################################
### definition of functions  ###
################################

# funciton to order order multiple entries of a predicted word after its maximum probability
find_unique_words_with_max_probability <- function(predWord,predProb,predNgram) {
        dt <- as.data.table(predWord)[, list(list(.I)), by = predWord]
        predWord_unique <- unique(predWord)
        predProb_unique <- rep(0, length(dt$V1))
        predNgram_unique <- rep(0, length(dt$V1))
        for (i in 1:length(dt$V1)) {
                indices <- unlist(dt$V1[i])
                if (length(indices) == 1){
                        predProb_unique[i]<-predProb[indices]
                        predNgram_unique[i]<-predNgram[indices]
                } else {
                        maxConf_int <- indices[1]
                        for (foo in indices[2:length(indices)]) {
                                if (predProb[maxConf_int] < predProb[foo]) {
                                        maxConf_int <- foo
                                }
                        }
                        predProb_unique[i]<-predProb[maxConf_int]
                        predNgram_unique[i]<-predNgram[maxConf_int]
                }
        }
        predWordConf_unique <- data.frame(words = predWord_unique,probability = as.numeric(as.vector(unlist(predProb_unique))),
                                          ngram = as.vector(unlist(predNgram_unique)))
        predWordConf_unique <-predWordConf_unique[order(predWordConf_unique$probability,decreasing = TRUE),]
        return(predWordConf_unique)
}

# function that selects the highest probable next word using a backoff scenario, going from Fourgrams down to unigrams.
# By choosing useKN, we can predict either with Kneser-Ney smoothing or just the simple backoff using simple probabilites
# nPred allows to choose the amount of predicted words, ordered from the highest probable word downwards.
predictNextword_en <- function(input = NULL, ngramData, useKN = T, nPred = 100){
        if (is.null(input)) return(NULL)
        probability <- character(0)
        ngram <- character(0)
        input <- tolower(input)
        splitInput <- unlist(strsplit(input, split = " "))
        # Looking at previous trigrams in order to make use of the fourgram probabilities
        if (length(splitInput) > 2){
                input2 <- paste(tail(splitInput, 3), collapse = " ")
        } else {
                input2 <- paste(splitInput, collapse = " ")
        }
        if (useKN){
                fourgramPred <- rev(tail(ngramData$totalFourgramsKN_en[ngram == input2]$nextword, nPred))
                if(length(fourgramPred) > 0 ){
                        count <- rev(tail(ngramData$totalFourgramsKN_en[ngram == input2]$count, length(fourgramPred)))
                        probability <- (count - minmax$totalFourgramsKN_en$mininum) / (minmax$totalFourgramsKN_en$maximum - minmax$totalFourgramsKN_en$mininum)
                        ngram <- rep("four",length(fourgramPred))
                }
        } else {
                fourgramPred <- rev(tail(ngramData$totalFourgrams_en[ngram == input2]$nextword,
                                         nPred))
                if(length(fourgramPred) > 0 ){
                        count <- rev(tail(ngramData$totalFourgrams_en[ngram == input2]$count, length(fourgramPred)))
                        probability <- (count - minmax$totalFourgrams_en$mininum) / (minmax$totalFourgrams_en$maximum - minmax$totalFourgrams_en$mininum)
                        ngram <- rep("four",length(fourgramPred))
                }
        }
        if (length(fourgramPred) >= nPred){
                return(data.table(prediction = fourgramPred[1:nPred], probability = probability[1:nPred],ngram = ngram))
        } else {
                predWord <- fourgramPred
                predProb <- probability
                predNgram <- ngram
                # Input is a trigram or smaller or not enough fourgrampreds found
                if (length(splitInput) >= 2){
                        input2 <- paste(tail(splitInput, 2), collapse = " ")
                } else {
                        input2 <- paste(splitInput, collapse = " ")
                }
                if (useKN){
                        trigramPred <- rev(ngramData$totalTrigramsKN_en[ngram == input2]$nextword)
                        if(length(trigramPred) > 0){
                                count <- rev(tail(ngramData$totalTrigramsKN_en[ngram == input2]$count, length(trigramPred)))
                                probability <- (count - minmax$totalTrigramsKN_en$mininum) / (minmax$totalTrigramsKN_en$maximum - minmax$totalTrigramsKN_en$mininum)
                                ngram<-rep("tri",length(trigramPred))
                        }
                } else {
                        trigramPred <- rev(ngramData$totalTrigrams_en[ngram == input2]$nextword)
                        if(length(trigramPred) > 0 ){
                                count <- rev(tail(ngramData$totalTrigrams_en[ngram == input2]$count, length(trigramPred)))
                                probability <- (count - minmax$totalTrigrams_en$mininum) / (minmax$totalTrigrams_en$maximum - minmax$totalTrigrams_en$mininum)
                                ngram <- rep("tri",length(trigramPred))
                        }
                }
                predWord <- c(predWord, trigramPred)
                predProb <- c(predProb, probability)
                predNgram <- c(predNgram, ngram)
                
                predWordConf_unique <- find_unique_words_with_max_probability(predWord,predProb,predNgram)
                
                predWord_unique <-as.vector(unlist(predWordConf_unique[1]))
                predProb_unique <-as.vector(unlist(predWordConf_unique[2]))
                predNgram_unique <-as.vector(unlist(predWordConf_unique[3]))
                
                if (length(predWord_unique) >= nPred){
                        return(data.table(prediction = predWord_unique[1:nPred], probability = predProb_unique[1:nPred], ngram = predNgram_unique[1:nPred]))
                } else {
                        # Input is a unigram or no prediction of a trigram or a bigram was found
                        input2 <- paste(tail(splitInput, 1), collapse = " ")
                        if (useKN){
                                bigramPred <- rev(ngramData$totalBigramsKN_en[ngram == input2]$nextword)
                                if(length(bigramPred) > 0){
                                        count <- rev(tail(ngramData$totalBigramsKN_en[ngram == input2]$count, length(bigramPred)))
                                        probability <- (count - minmax$totalBigramsKN_en$mininum) / (minmax$totalBigramsKN_en$maximum - minmax$totalBigramsKN_en$mininum)
                                        ngram <- rep("bi",length(bigramPred))
                                }
                        } else {
                                bigramPred <- rev(ngramData$totalBigrams_en[ngram == input2]$nextword)
                                if(length(bigramPred) > 0){
                                        count <- rev(tail(ngramData$totalBigrams_en[ngram == input2]$count, length(bigramPred)))
                                        probability <- (count - minmax$totalBigrams_en$mininum) / (minmax$totalBigrams_en$maximum - minmax$totalBigrams_en$mininum)
                                        ngram <- rep("bi",length(bigramPred))
                                }
                        }
                        
                        predWord <- c(predWord_unique, bigramPred)
                        predProb <- c(predProb_unique, probability)
                        predNgram <- c(predNgram, ngram)
                        
                        predWordConf_unique <- find_unique_words_with_max_probability(predWord,predProb,predNgram)
                        
                        predWord_unique <-as.vector(unlist(predWordConf_unique[1]))
                        predProb_unique <-as.vector(unlist(predWordConf_unique[2]))
                        predNgram_unique <-as.vector(unlist(predWordConf_unique[3]))
                        
                        if (length(predWord_unique) >= nPred){
                                return(data.table(prediction = predWord_unique[1:nPred], probability = predProb_unique[1:nPred], ngram = predNgram_unique[1:nPred]))
                        } else {
                                # No matching n-grams found
                                if (input2 %in% ngramData$totalUnigrams_en$nextword) {
                                        unigramPred <- input2
                                        count <- ngramData$totalUnigrams_en[nextword == input2]$count
                                        probability <- (count - minmax$totalUnigrams_en$mininum) / (minmax$totalUnigrams_en$maximum - minmax$totalUnigrams_en$mininum)
                                        ngram <- "uni"
                                } else {
                                        unigramPred <- rev(tail(ngramData$totalUnigrams_en$nextword, nPred))
                                        probability <- rep(0,nPred)
                                        ngram <- rep("uni",nPred)
                                }
                                
                                predWord <- c(predWord_unique, unigramPred)
                                predProb <- c(predProb_unique, probability)
                                predNgram <- c(predNgram, ngram)
                                
                                predWordConf_unique <- find_unique_words_with_max_probability(predWord,predProb,predNgram)
                                
                                predWord_unique <-as.vector(unlist(predWordConf_unique[1]))
                                predProb_unique <-as.vector(unlist(predWordConf_unique[2]))
                                predNgram_unique <-as.vector(unlist(predWordConf_unique[3]))
                                
                                return(data.table(prediction = predWord_unique[1:nPred],probability = predProb_unique[1:nPred], ngram = predNgram_unique[1:nPred]))
                        }
                }
        }
}

predictNextword_en(input = gsub('[[:punct:]]', '', "archipel"), ngramData = totalData, useKN = T)

