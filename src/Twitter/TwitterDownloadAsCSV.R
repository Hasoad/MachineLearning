#Installing software for to access the twitter From R

#install.packages("twitteR")
#install.packages("base64enc")
#install.packages("httpuv")
#install.packages("openssl")
#install.packages("leaflet") 
#install.packages("maps") 


library(twitteR)
library(base64enc)
library(openssl)
library(httpuv)
#library(leaflet) 
#library(maps)


#setting up the working dir
setwd('Your Working Directory')


# Accessing the oAuth by using customer API\token key, API\token secret key. 
# if failed to give Access Token and token secret, the twitter will 
# trying to access the broswer to authenticate. But, i never seen 
# twitter can be able to authenticate via broswer in R programming. 
# Instead, the token key will authenticate you from local, no need
# browser authentication. Advice to create Both the Api key's and token Key's

inilize.twitter.key <- function(apikey,apisecret,token,tokensecret){
  
  print('Inilizing the twitter Authentication')
  api_key <- apikey 
  api_secret <- apisecret
  token <- token
  token_secret <- tokensecret
  
  setup_twitter_oauth(api_key, api_secret,access_token = token,access_secret =token_secret)
  
  }


inilize.twitter.key(Your Api_Key, Your Api_Secret_Key, Your Access_Token, Your Token_secret)


searchForTwitter <- function(searchtext, lang, twitterCount){
  
  tweet <- searchTwitter(searchtext, n = twitterCount, lang = lang)

  return(tweet)  
}


SearchedTwitter <- searchForTwitter("SEARCH WHAT EVER YOU WANT","en",500)


tweets.df <-twListToDF(SearchedTwitter)

write.csv(tweets.df, "data/tweets.csv")



