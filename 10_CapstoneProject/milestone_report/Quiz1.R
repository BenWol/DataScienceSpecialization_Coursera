## Quiz 1

# Question1 - file size in MB
file.info("/Users/benwo/Dropbox/DataScience/Coursera_DataScience_JHU/10_CapstoneProject/data/en_US/en_US.blogs.txt")$size/1024^2
#200MB

# Question2 - lines in US_twitter data set
US_twitter <- readLines("/Users/benwo/Dropbox/DataScience/Coursera_DataScience_JHU/10_CapstoneProject/data/en_US/en_US.twitter.txt")
length(US_twitter)/1e6 #2.36e6

# Question3 - length of longest line of all data sets
US_blogs <- readLines("/Users/benwo/Dropbox/DataScience/Coursera_DataScience_JHU/10_CapstoneProject/data/en_US/en_US.blogs.txt")
US_news <- readLines("/Users/benwo/Dropbox/DataScience/Coursera_DataScience_JHU/10_CapstoneProject/data/en_US/en_US.news.txt")

max(nchar(US_twitter))  #140
max(nchar(US_blogs))    #40833
max(nchar(US_news))     #11384

# Question4 - number of love / number of hate
sum(grepl("love",US_twitter)) / sum(grepl("hate",US_twitter)) #4

# Question5 - One tweet about biostats
US_twitter[grepl("biostats",US_twitter)] #"i know how you feel.. i have biostats on tuesday and i have yet to study =/"

# Question6 - how many tweets match "A computer once beat me at chess, but it was no match for me at kickboxing"
sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing",US_twitter))
