library(rvest)
library(selectr)
library(tidyverse)

# Create empty data frame
# Create an empty data frame
answers <- data.frame(
  number = numeric(),
  title = character(),
  question_body = character(),
  tags = character(),
  user_reputation_score = character(),
  user_profile = character(),
  question_time = character(),
  question_views = character(),
  answer_body = character(),
  responder_reputation_score = character(),
  responder_profile = character(),
  answer_score = numeric(),
  answer_time = character(),
  stringsAsFactors = FALSE
)

# Pick 1000 numbers between 76514626 and 76504626
set.seed(126)
# Generate 1000 random numbers between the range
random_numbers <- sample(76504626:76514626, 1000, replace = TRUE)

for (i in random_numbers){
  url = paste("https://stackoverflow.com/questions/", as.character(i), "/", sep = '')
  if (valid_url(url)){
    stack_overflow_page<-read_html(url)
    
    # question attributes
    title = html_text(html_node(stack_overflow_page, xpath='//*[@id="question-header"]/h1/a'))
    question_body = html_text(html_node(stack_overflow_page, xpath='//*[@id="question"]/div[2]/div[2]/div[1]'))
    tags = html_text(html_nodes(stack_overflow_page, xpath='//*[@id="question"]/div[2]/div[2]/div[2]/div/div/ul/li'))
    user_reputation_score = html_text(html_node(stack_overflow_page, xpath='//*[@id="question"]/div[2]/div[2]/div[3]/div')%>%html_nodes(".reputation-score"))
    user_profile = html_attr(html_node(stack_overflow_page, xpath='//*[@id="question"]/div[2]/div[2]/div[3]/div')%>%html_nodes(".user-details")%>%html_node('a'), name = 'href')
    if (length(user_profile)> 1){
      user_profile = user_profile[-1]
    }
    if (length(user_reputation_score)>1){
      user_reputation_score = user_reputation_score[-1]
    }
    question_time = html_attr(stack_overflow_page%>%html_nodes('#question')%>%html_nodes('.user-action-time')%>%html_nodes('span'), name = 'title')
    if (length(question_time) > 1){
      question_time = question_time[-1]
    }
    question_views = as.numeric(gsub("\\D", "", html_text(html_node(stack_overflow_page, xpath='//*[@id="content"]/div/div[1]/div[2]/div[3]'))))
    
    # answer list
    answer_list = html_nodes(stack_overflow_page, xpath='//*[@class="answer js-answer"]')
    
    for (k in answer_list){
      # answer attributes
      answer_body = html_text(k%>%html_nodes(".s-prose"))
      responder_reputation_score = html_text(k%>%html_nodes(".reputation-score"))
      responder_profile = html_attr(k%>%html_nodes(".user-details")%>%html_node('a'), name = 'href')
      if (length(responder_reputation_score) > 1){
        responder_reputation_score = responder_reputation_score[-1]
      }
      if (length(responder_profile)>1){
        responder_profile = responder_profile[-1]
      }
      answer_score = as.numeric(html_text(k%>%html_nodes('.js-vote-count')))
      answer_time = html_attr(k%>%html_nodes('.user-action-time')%>%html_nodes('span'), name = 'title')
      
      answers[nrow(answers)+1,] = c(i, title, question_body, paste(list(tags), sep = " "), user_reputation_score, user_profile, question_time, question_views, answer_body, responder_reputation_score, responder_profile, answer_score, answer_time)
    }
    if (length(answer_list) == 0){
      answers[nrow(answers)+1,] = c(i, title, question_body, paste(list(tags), sep = " "), user_reputation_score, user_profile, question_time, question_views, NA, NA, NA, NA, NA)
    }
  } else {
    print(i)
  }
}

valid_url <- function(url_in,t=2){
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  ifelse(is.null(check),TRUE,FALSE)
}


save(answers, file = 'answers.RData')

