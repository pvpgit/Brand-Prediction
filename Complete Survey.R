##Load the excel library and read the data
library(readxl)
survey_complete <- read_excel(paste("https://github.com/pvpgit/Brand-Prediction/Survey_Key_and_Complete_Responses_excel.xlsx"), sheet = 2, col_names = TRUE)

install.packages("caret", dependencies = c("Depends", "Suggests"))
library(caret)
library(mlbench)
library(pander)

set.seed(107)
##Create Data Partition
ptr=0.75
inTrain <- createDataPartition(y = survey_complete$brand, p=ptr, list=FALSE)
str(inTrain)

training <- survey_complete[ inTrain,]
testing <- survey_complete[-inTrain,]
nrow(training)
nrow(testing)
testing
colnames(survey_complete)<- c("Original", "Training", "Testing")
pander(survey_complete, style="rmarkdown", caption="Brand")

##trainControl
training[["brand"]]=factor(training[["brand"]])
ctrl <- trainControl(method = "repeatedcv",number=10, repeats = 1)

##train                   
knnFit <- train(brand ~ ., data = training, method = "knn",
                 tuneLength = 15, trControl=ctrl, preProcess = c("center", "scale"))
knnFit
plot(knnFit)

##predict
knnPredict <- predict(knnFit, newdata = testing)

##Confusion Matrix
confusionMatrix(knnPredict, testing$brand)
mean(knnPredict == testing$brand)
plot(knnFit, print.thres = 0.5, type="S")

##Use the testset incomplete responses
incomplete_survey<-read.csv(paste("https://github.com/pvpgit/Brand-Prediction/Incomplete.csv", sep=""), header = TRUE)

##Use KNN to predict using new data set
newKNNPred<-cbind(incomplete_survey, pred=predict(knnFit, newdata=incomplete_survey))
mean(newKNNPred == incomplete_survey$brand)

##testing$brand<-as.factor(testing$brand)
##postResample(knnPredict,testing$brand)
write.csv(newKNNPred, "~/Desktop/predictionsCaretKNN.csv", row.names = F)


##Random Forest
install.packages("randomForest")
##Random Forest Model 10 fold cross validation
rf_model<-train(brand ~. ,data=training, method="rf",
                trControl=trainControl(method="cv",number=10),
                prox=TRUE,allowParallel=TRUE)

print(rf_model)
print(rf_model$finalModel)

rfFit <- train(brand ~ ., data = training, method = "rf",
                tuneLength = 15, trControl=ctrl, preProcess = c("center", "scale"))
rfFit
plot(rfFit)
##predict
rfPredict <- predict(rfFit, newdata = testing)
mean(rfPredict == testing$brand)

plot(rfFit, print.thres = 0.5, type="S")

confusionMatrix(rfPredict, testing$brand)
##testing$brand<-as.factor(testing$brand)
##postResample(rfPredict,testing$brand)

##Use the testset incomplete responses
incomplete_survey<-read.csv(paste("~/Desktop/SurveyIncomplete.csv", sep=""), header = TRUE)

## Use Random Forest to predict using new data set
newRFPrediction<-cbind(incomplete_survey, pred=predict(rfFit, newdata=incomplete_survey))
mean(newRFPrediction == incomplete_survey$brand)

#Create a predictions.csv file on desktop
write.csv(newRFPrediction, "~/Desktop/predictionsCaretRF.csv", row.names = F)
