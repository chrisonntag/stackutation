library(dplyr)

# Import csv files first

# Create dataset without the bodies of the questions
questions_nobody = questions[,c(1:2,4:9)]

save(questions, file = "questions.RData")
remove(questions)

# Rename ids
names(questions_nobody)[names(questions_nobody) == 'id'] <- 'question_id'
names(answers)[names(answers) == 'id'] <- 'answer_id'
names(answers)[names(answers) == 'parent_id'] <- 'question_id'
names(users)[names(users) == 'id'] <- 'user_id'

# Add reputation to both files
questions_nobody = questions_nobody %>% left_join(users[, c('user_id', 'reputation')],by=c("owner_user_id"="user_id"))
names(questions_nobody)[names(questions_nobody) == 'reputation'] <- 'reputation_owner'

answers = answers %>% left_join(users[, c('user_id', 'reputation')],by=c("owner_user_id"="user_id"))
names(answers)[names(answers) == 'reputation'] <- 'reputation_responder'


# join question and answer file
qa_combinations = questions_nobody %>% inner_join(answers,by="question_id")


# Calculate response time
qa_combinations$time_to_response = difftime(qa_combinations$creation_date.y, qa_combinations$creation_date.x)
