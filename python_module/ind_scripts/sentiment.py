from textblob import TextBlob

journal_directory = 'journal_examples/'
journal_name = journal_directory + 'positive1.txt'
# journal_name = journal_directory + 'negative1.txt'

with open(journal_name, 'r') as f:
    content = f.readline()

print(content)

journal = TextBlob(content)
print(journal.sentiment)
