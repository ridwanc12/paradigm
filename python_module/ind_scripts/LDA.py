# Necessary modules from NLTK
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer

# Import Gensim
import gensim

lemmatizer = WordNetLemmatizer()
stemmer = PorterStemmer()

journal_directory = 'journal_examples/'
journal_name = journal_directory + 'positive1.txt'
# journal_name = journal_directory + 'negative1.txt'

with open(journal_name, 'r') as f:
    content = f.readline()

print(content)


def lemmatize_stemming(text):
    return stemmer.stem(WordNetLemmatizer().lemmatize(text, pos='v'))

# Tokenize and lemmatize


def preprocess(text):
    result = []
    for token in gensim.utils.simple_preprocess(text):
        if token not in gensim.parsing.preprocessing.STOPWORDS and len(token) > 3:
            result.append(lemmatize_stemming(token))

    return result


processed = preprocess(content)
print(processed)

dictionary = gensim.corpora.Dictionary([processed])
print(dictionary)

bow_corpus = [dictionary.doc2bow(processed)]
print(bow_corpus)

lda_model = gensim.models.LdaMulticore(
    bow_corpus, num_topics=8, id2word=dictionary, passes=10, workers=2)
