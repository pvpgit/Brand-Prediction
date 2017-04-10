# Brand-Prediction
The file Survey_Key_and_Complete_Responses_excel is an Excel file that includes answers to all the questions in the market research survey, including which brand of computer products the customer prefers. This file is used to build trained and predictive models using the caret package.

The file Survey_Incomplete.csv is a CSV file  which is used to test the model. It includes 10,000 observations, but no brand preference.

I used this data set to train and test the classifier to make predictions. The training data represents 75% of the total data and the remaining 25% is used for testing.
Run the KNN classifier on the training set with 10-fold cross validation. Using the KNN model that was built and the testing set created previously make predictions using the predict() function.

Repeat the same steps for Random Forest and compare the results for both the predictions.
