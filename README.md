## Objective
The purpose of this project is to create a mental health app where users will input a short journal each day that is no longer than a tweet (280 characters) and have the app analyze their journals and determine topics they should focus on. Essentially, with a short journal each day about what they did and how they felt, users can take a statistical look at their emotional wellbeing over time, including areas in which they feel great/happy, and areas where they could look to improve/avoid. 

The principle behind the journals will be asking users to tell us the biggest thing they did today and how they felt overall.

## Methodology
Natural Language Processing (NLP) will be used to analyze these short journals. More specifically, a combination of Naive Bayes Classifier (NBC) through TextBlob for sentiment analysis and Latent Dirichlet Allocation (LDA) through NLTK and Gensim for topic modelling will allow us to identify topics the user faces each day along with their corresponding sentiment. As an alternative to LDA, we can utilize noun chunk phrase modelling by utilizing the TextBlob library and the CoNLL 2000 Corpus to train a tagger for our journals.

## Architecture
Currently, work is being done purely on the Python portion of the project. This includes the sentiment analysis and topic modelling for each journal. Later on, we will have multiple components to make this a mobile application.

#### Mobile UI
The front-end will be developed on Swift in order to run on iPhones.

#### Database
The back-end database will use 000webhost or AWS DynamoDB or GCP Firebase to host an SQL database containing data for all of our users

#### AWS Cloud Component
Because analysis is done in Python and this is difficult to natively integrate with XCode and iOS, an AWS Lambda function will be created to serve as an HTTP endpoint for our application. This will accept HTTP requests from the iOS front-end, process using Python in the lambda, and return the necessary data.

### Lambda Deployment
aws configure (on aws cli)
pip install -r requirements.txt -t .