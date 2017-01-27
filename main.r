#https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

#Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")  
#install.packages(Needed, dependencies=TRUE)   
#library(tm) 

setwd("~/workspace/r/textMine")
dataDir <- file.path("data")
   
#create text mining corpus
docs <- Corpus(DirSource(dataDir))   

# normalize case
docs <- tm_map(docs, tolower) 

#homogenize stuff
for (j in seq(docs))
{
  #seperate hyphenated phrases
  docs[[j]] <- gsub("-", " ", docs[[j]])
  
  #forms of we
  docs[[j]] <- gsub("we've", "we", docs[[j]])
}

#remove symbols and numbers
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)   

#remove common english meaningless words (e.g. as a, as, the)
docs <- tm_map(docs, removeWords, x = stopwords("english")) 

#remove header and footer text
headerLinks = c("logo", "about", "case studies",  "services", "products", "news", "careers", "contact")
footer = c("spruce","street", "suite", "st", "louis" ,"mo", "wwt-logo-footer2", "wwtlogofooter", "footer")
docs <- tm_map(docs, removeWords, headerLinks)  
docs <- tm_map(docs, removeWords, footer)  

#remove endings
library(SnowballC)   
docs <- tm_map(docs, stemDocument) 

#indicate they are plain text
docs <- tm_map(docs, PlainTextDocument)   

#load up the matrix, neo
documentTermMatrix = DocumentTermMatrix(docs)
inspect(documentTermMatrix)

#organize by frequency
freq <- colSums(as.matrix(documentTermMatrix))
ord <- order(freq)

#This makes a matrix that is 10% empty space, maximum.   
documentTermMatrix <- removeSparseTerms(documentTermMatrix, .1)
inspect(documentTermMatrix)  

#see least and most frequent terms
freq[head(ord)]   
freq[tail(ord)]  

#terms by frequency
freq <- colSums(as.matrix(documentTermMatrix))   
freq  

#words that show up 50 or more times only
findFreqTerms(documentTermMatrix, lowfreq=50)
