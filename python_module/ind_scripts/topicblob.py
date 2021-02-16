from textblob import TextBlob
from textblob.np_extractors import ConllExtractor
from textblob.sentiments import NaiveBayesAnalyzer

journal_directory = 'journal_examples/'
journal_name = journal_directory + 'positive1.txt'
# journal_name = journal_directory + 'negative1.txt'

with open(journal_name, 'r') as f:
    content = f.readline()

print(content)

# journal = TextBlob(content)
journal = TextBlob(content, analyzer=NaiveBayesAnalyzer(), np_extractor=ConllExtractor())
print(journal.sentiment)
print(journal.noun_phrases)