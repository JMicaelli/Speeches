from nltk.tokenize import RegexpTokenizer
from nltk.stem.porter import PorterStemmer
from glob import glob
import sys

# open the sentiment dictionary
comments = 0
categories = {}
dict = {}
for l in open('sentiment/LIWC2007_English080730.dic'):
  l = l.strip()
  if l == '%':
    comments += 1
  else:
    if comments == 1:
      id, cat = l.split('\t')
      categories[id] = cat
    else:
      t = l.split('\t')
      w = t.pop(0).rstrip('*')
      try:
        t = [int(ti) for ti in t]
        dict[w] = t
      except:
        pass

tokenizer = RegexpTokenizer(r'\w+')
stemmer = PorterStemmer()

def find(src):
  for f in glob(src + '/*.txt'):
    cats = {}
    tokens = tokenizer.tokenize(open(f).read())
    words = 0
    for t in tokens:
      t = t.lower()
      t = stemmer.stem_word(t)
      while len(t):
        if t in dict:
          for c in dict[t]:
            if c in cats:
              cats[c] += 1
            else:
              cats[c] = 1
          break
        t = t[0:len(t)-1]
      words += 1
    d = f.replace('.txt','')
    d = d.replace(src+'/', '')
    for c in cats.keys():
      print '%s, %s, %f' % (d, c, float(cats[c]) / words)

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print "Usage:\n\tpython sent.py <Obama|Romney>\n"
    sys.exit()
    
  find(sys.argv[1])
