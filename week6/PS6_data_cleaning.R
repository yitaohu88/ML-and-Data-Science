library(dplyr)

vix_data<-as.data.frame(read.csv("vix_data.csv"))
news_data<-as.data.frame(read.csv("business_insider_text_data2.csv"))
names(news_data)[1]<-"Date"
names(vix_data)[1]<-"Date"
news_data$Date<-as.Date(news_data$Date)
vix_data$Date<-as.Date(vix_data$Date)

news_data<-news_data %>%
  group_by(Date) %>%
  slice(seq_len(5))


for (j in 1:508){
  for (i in 1:5){
    news_data$Headline_name[5*(j-1)+i]<-paste0("Headline_",i)
  }
}

news_data<-spread(news_data, Headline_name, Headline)

# Combine headlines into one text blob for each day and add sentence separation token
news_data$all<- paste(news_data$Headline_1,news_data$Headline_2,news_data$Headline_3,news_data$Headline_4,news_data$Headline_5, sep=' <s> ')

# Get rid of the special characters you see if you inspect the raw data
news_data$all <- gsub("[^0-9A-Za-z///' ]","'" , news_data$all ,ignore.case = TRUE)

# Get rid of all punctuation except headline separators, alternative to cleaning done in tm-package
news_data$all <- gsub("([<>])|[[:punct:]]", "\\1", news_data$all)

news_data<-merge(news_data,vix_data,all.x=FALSE)

assignment_data_final <- as.data.frame(news_data[, c('Date', 'all', 'label')])

