library(beepr)
library(data.table)
library(tau)
library(plyr)

###########################################################################################################
# function to calculate all n grams from a given vector of lines of strings. After removal of punctuation,#
# hashtags (of the twitter messages) and whitespace, conversion of all characters to lower case,          #
# conversion to ASCII (default) encoding, the function returns a 2 column data.table with the specific    #
# ngram plus the overall count of the ngrams                                                              #
###########################################################################################################

generateNgrams <- function(x, ngram = 2L, encoding = "ASCII", convertToLower = T){
  startTime <- Sys.time()
  require(tau)
  
  punctuation <- '[]\\?!\"#$%&(){}+*:;,._`|~\\[\\=\\@\\^-]'
  blocksEnds <- seq(1e3, length(x) + 1e3, 1e3)
  blocks <- blocksEnds - 999
  message(paste("Number of steps:", length(blocks)))
  for (i in seq_along(blocks)){
    start <- Sys.time()
    ngrams <- na.omit(x[blocks[i]:blocksEnds[i]])
    ngrams <- iconv(ngrams, to = encoding, sub="")
    # Remove hashtags
    ngrams <- gsub("#[[:alpha:]]*", "", ngrams)
    # Replace exclamation marks and question marks by a single period
    ngrams <- gsub("\\!|\\?", ".", ngrams)
    # Remove punctuation -----------
    ngrams <- gsub("\\.+", "", ngrams)
    ngrams <- gsub(punctuation, "", ngrams)

    # Remove numbers
    ngrams <- gsub("[0-9]", "", ngrams)
    if (convertToLower){
      ngrams <- tolower(ngrams)
    }
    ngrams <- textcnt(ngrams, tolower = F,method = "string",n = ngram,decreasing = T,split = "[[:space:][:digit:]]+")
    
    # Combine
    ngrams <- data.table("count" = as.numeric(ngrams),"ngram" = names(ngrams))
    
    if (i == 1){
      totalNgrams <- ngrams
    } else {
      totalNgrams <- rbind.fill(totalNgrams, ngrams)
      totalNgrams <- data.table(totalNgrams)
      totalNgrams <- totalNgrams[, lapply(.SD, sum), by = ngram]
    }
    
    # In order to prevent the data.table from becoming too large, all n-grams with count 1 are deleted
    # at every quarter of the whole run through:
    if (i == round(length(blocks) * (1/4)) | i == round(length(blocks) * (1/2)) 
        | i == round(length(blocks) * (3/4)) ){
      Nrare <- nrow(totalNgrams[count == 1])
      message(paste(Nrare, "n-grams with count 1 removed"))
      totalNgrams <- totalNgrams[count > 1]
      gc()
    }
    
    print(i)
  }
  message("Finished after:")
  print(Sys.time() - startTime)
  totalNgrams <- totalNgrams[count > 1]
  return(totalNgrams)
}

##################################################################################################################
# generation of all n grams of the english Twitter, News and Blog data sets, and combination of all respectively #
##################################################################################################################

en_Twitter <- readLines("C:/_directory_/data/en_US/en_US.twitter.txt", encoding = "UTF-8")
en_News <- readLines("C:/_directory_/data/en_US/en_US.news.txt", encoding = "UTF-8")
en_Blogs <- readLines("C:/_directory_/data/en_US/en_US.blogs.txt", encoding = "UTF-8")

# Twitter
unigramsTwitter <- generateNgrams(en_Twitter,ngram = 1)
unigramsTwitter <- unigramsTwitter[count > 1]
save(unigramsTwitter, file = "unigramsTwitter")
rm(unigramsTwitter)
gc()

bigramsTwitter <- generateNgrams(en_Twitter,ngram = 2)
bigramsTwitter <- bigramsTwitter[count > 1]
save(bigramsTwitter, file = "bigramsTwitter")
rm(bigramsTwitter)
gc()

trigramsTwitter <- generateNgrams(en_Twitter,ngram = 3)
save(trigramsTwitter, file = "trigramsTwitter")
rm(trigramsTwitter)
gc()
fourgramsTwitter <- generateNgrams(en_Twitter,ngram = 4)
save(fourgramsTwitter, file = "fourgramsTwitter")
rm(fourgramsTwitter, en_Twitter)
gc()

# News
unigramsNews <- generateNgrams(en_News,ngram = 1)
save(unigramsNews, file = "unigramsNews")
rm(unigramsNews)
gc()

bigramsNews <- generateNgrams(en_News,ngram = 2)
save(bigramsNews, file = "bigramsNews")
rm(bigramsNews)
gc()

trigramsNews <- generateNgrams(en_News,ngram = 3)
save(trigramsNews, file = "trigramsNews")
rm(trigramsNews)
gc()

fourgramsNews <- generateNgrams(en_News,ngram = 4)
save(fourgramsNews, file = "fourgramsNews")
rm(fourgramsNews, en_News)
gc()


# Blogs
unigramsBlogs <- generateNgrams(en_Blogs,ngram = 1)
save(unigramsBlogs, file = "unigramsBlogs")
rm(unigramsBlogs)
gc()

bigramsBlogs <- generateNgrams(en_Blogs,ngram = 2)
save(bigramsBlogs, file = "bigramsBlogs")
rm(bigramsBlogs)
gc()

trigramsBlogs <- generateNgrams(en_Blogs,ngram = 3)
save(trigramsBlogs, file = "trigramsBlogs")
rm(trigramsBlogs)
gc()

fourgramsBlogs <- generateNgrams(en_Blogs,ngram = 4)
save(fourgramsBlogs, file = "fourgramsBlogs")
rm(fourgramsBlogs)
gc()


# Combination of individual ngram data.frames of all 3 data sources
load("unigramsBlogs")
load("unigramsNews")
load("unigramsTwitter")
totalUnigrams <- rbind.fill(unigramsBlogs, unigramsNews, unigramsTwitter)
totalUnigrams <- data.table(totalunigrams)
totalUnigrams <- totalunigrams[, lapply(.SD, sum), by = ngram]
save(totalUnigrams, file = "totalUnigrams.RData")
rm(unigramsBlogs, unigramsTwitter, unigramsNews)

load("bigramsBlogs")
load("bigramsNews")
load("bigramsTwitter")
totalBigrams <- rbind.fill(bigramsBlogs, bigramsNews, bigramsTwitter)
totalBigrams <- data.table(totalBigrams)
totalBigrams <- totalBigrams[, lapply(.SD, sum), by = ngram]
save(totalBigrams, file = "totalBigrams.RData")
rm(bigramsBlogs, bigramsTwitter, bigramsNews)

load("trigramsBlogs")
load("trigramsNews")
load("trigramsTwitter")
totalTrigrams <- rbind.fill(trigramsBlogs, trigramsNews, trigramsTwitter)
totalTrigrams <- data.table(totalTrigrams)
totalTrigrams <- totalTrigrams[, lapply(.SD, sum), by = ngram]
save(totalTrigrams, file = "totalTrigrams.RData")
rm(trigramsBlogs, trigramsTwitter, trigramsNews)

load("fourgramsBlogs")
load("fourgramsNews")
load("fourgramsTwitter")
totalFourgrams <- rbind.fill(fourgramsBlogs, fourgramsNews, fourgramsTwitter)
rm(fourgramsBlogs, fourgramsNews, fourgramsTwitter)
gc()
totalFourgrams <- data.table(totalFourgrams)
totalFourgrams <- totalFourgrams[, lapply(.SD, sum), by = ngram]
save(totalFourgrams, file = "totalFourgrams.RData")