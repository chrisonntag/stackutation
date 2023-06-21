# Data transformation steps
answers_processed = answers

# Calculate time difference
answers_processed$time_to_response = difftime(answers_processed$answer_time, answers_processed$question_time)

answers_processed$user_reputation_score <- ifelse(
  grepl("k$", answers_processed$user_reputation_score),
  as.numeric(gsub("k$", "", gsub(",", "", answers_processed$user_reputation_score))) * 1000,
  as.numeric(gsub(",", "", answers_processed$user_reputation_score))
)

answers_processed$responder_reputation_score <- ifelse(
  grepl("k$", answers_processed$responder_reputation_score),
  as.numeric(gsub("k$", "", gsub(",", "", answers_processed$responder_reputation_score))) * 1000,
  as.numeric(gsub(",", "", answers_processed$responder_reputation_score))
)

# Aggregate to question level
question_df <- answers_processed %>%
  group_by(number) %>%
  summarize(
    title = first(title),
    question_body = first(question_body),
    tags = first(tags),
    user_reputation_score = first(user_reputation_score),
    user_profile = first(user_profile),
    question_time = first(question_time),
    question_views = first(question_views),
    num_answers = n(),  # Number of answers for the given number (question id)
    highest_answer_score = max(answer_score),  # Highest answer score
    smallest_time_to_response = min(time_to_response)  # Smallest time to response
  )

question_df$num_answers[is.na(question_df$highest_answer_score)] = 0
question_df$highest_answer_score[is.na(question_df$highest_answer_score)] = 0

