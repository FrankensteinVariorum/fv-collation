import re
regexWhitespace = re.compile(r'\s+')
regexNonWhitespace = re.compile(r'\S+')
RE_MARKUP = re.compile(r'<.+?>')
RE_PARA = re.compile(r'<p\s.+?/>')
RE_MILESTONE = re.compile(r'<milestone.+?/>')
RE_AMP_NSB = re.compile(r'\S&amp;')
RE_AMP_NSE = re.compile(r'&amp;\S')
RE_AMP = re.compile(r'&amp;')

def normalizeSpace(inText):
    """Replaces all whitespace spans with single space characters"""
    if RE_AMP.search(inText):
        split = RE_AMP.split(inText)
        return split[0] + ' &amp;' + split[1]

def normalize(inputText):
   return RE_AMP.sub('and', RE_MARKUP.sub('', inputText)).lower()

tester = normalizeSpace('Bonnie&amp; Clyde')
normTester = normalize(tester)
print(normTester)


