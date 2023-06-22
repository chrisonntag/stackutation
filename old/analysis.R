# Plotting the data
library(ggplot2)
library(dplyr)

ggplot(answers_processed, aes(x = log(user_reputation_score), y = log(responder_reputation_score))) +
  geom_point() +
  labs(x = "User Reputation Score", y = "Responder Reputation Score") +
  ggtitle("Reputation Scores")


ggplot(answers_processed, aes(x = log(user_reputation_score), y = log(as.numeric(answers_processed$time_to_response)))) +
  geom_point() +
  labs(x = "User Reputation Score", y = "Time to Response") +
  ggtitle("Reputation Scores")

# First models
model <- lm(question_views ~ log(user_reputation_score), data = question_df)

# Print the model summary
summary(model)
