# Import csv files first

# Create dataset without the bodies of the questions
questions_nobody = questions[,c(1:2,4:9)]

save(questions, file = "questions.RData")
remove(questions)

# join question and answer file