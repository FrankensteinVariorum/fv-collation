from collatex import *
from xml.dom import pulldom
import re
import glob
from datetime import datetime, date
# import pytz
# from tzlocal import get_localzone

# today = date.today()
# utc_dt = datetime(today, tzinfo=pytz.utc)
# dateTime = utc_dt.astimezone(get_localzone())
# strDateTime = str(dateTime)

now = datetime.utcnow()
nowStr = str(now)

regexWhitespace = re.compile(r'\s+')
regexNonWhitespace = re.compile(r'\S+')
regexEmptyTag = re.compile(r'/>$')
regexBlankLine = re.compile(r'\n{2,}')
regexLeadingBlankLine = re.compile(r'^\n')
regexPageBreak = re.compile(r'<pb.+?/>')
RE_MARKUP = re.compile(r'<.+?>')

# Element types: xml, div, head, p, hi, pb, note, lg, l; comment()
# Tags to ignore, with content to keep: xml, comment, anchor
# Structural elements: div, p, lg, l
# Inline elements (empty) retained in normalization: pb, milestone, xi:include
# Inline and block elements (with content) retained in normalization: note, hi, head, ab

# GIs fall into one three classes
# 2017-05-21 ebb: Due to trouble with pulldom parsing XML comments, I have converted these to comment elements,
# 2017-05-21 ebb: to be ignored during collation.
# 2017-05-30 ebb: Determined that comment elements cannot really be ignored when they have text nodes (the text is
# 2017-05-30 ebb: collated but the tags are not). Decision to make the comments into self-closing elements with text
# 2017-05-30 ebb: contents as attribute values, and content such as tags simplified to be legal attribute values.
# 2017-05-22 ebb: I've set anchor elements with @xml:ids to be the indicators of collation "chunks" to process together
ignore = ['sourceDoc', 'xml', 'pb', 'comment', 'w', 'mod']
inlineEmpty = ['milestone', 'anchor', 'include', 'lb', 'delSpan', 'addSpan', 'gap', 'handShift', 'damage', 'restore']
inlineContent = ['hi', 'add', 'del', 'metamark', 'unclear', 'retrace', 'damage', 'restore', 'zone']
blockElement = ['p', 'div', 'lg', 'l', 'head', 'note', 'ab', 'cit', 'quote', 'bibl', 'header', 'surface', 'graphic']
# ebb: Tried removing 'comment', from blockElement list above, because we don't want these to be collated.

# 10-23-2017 ebb rv:

def normalizeSpace(inText):
    """Replaces all whitespace spans with single space characters"""
    if regexNonWhitespace.search(inText):
        return regexWhitespace.sub('\n', inText)
    else:
        return ''


def extract(input_xml):
    """Process entire input XML document, firing on events"""
    # Start pulling; it continues automatically
    doc = pulldom.parse(input_xml)
    output = ''
    for event, node in doc:
        # elements to ignore: xml
        if event == pulldom.START_ELEMENT and node.localName in ignore:
            continue
        # copy comments intact
        elif event == pulldom.COMMENT:
            doc.expandNode(node)
            output += node.toxml()
        # empty inline elements: pb, milestone
        elif event == pulldom.START_ELEMENT and node.localName in inlineEmpty:
            output += node.toxml()
        # non-empty inline elements: note, hi, head, l, lg, div, p, ab, 
        elif event == pulldom.START_ELEMENT and node.localName in inlineContent:
            output += regexEmptyTag.sub('>', node.toxml())
        elif event == pulldom.END_ELEMENT and node.localName in inlineContent:
            output += '</' + node.localName + '>'
        elif event == pulldom.START_ELEMENT and node.localName in blockElement:
            output += '\n<' + node.localName + '>\n'
        elif event == pulldom.END_ELEMENT and node.localName in blockElement:
            output += '\n</' + node.localName + '>'
        elif event == pulldom.CHARACTERS:
            output += normalizeSpace(node.data)
        else:
            continue
    return output


def normalize(inputText):
    return RE_MARKUP.sub('', inputText)
#    return regexPageBreak('',inputText)


def processToken(inputText):
    return {"t": inputText + ' ', "n": normalize(inputText)}


def processWitness(inputWitness, id):
    return {'id': id, 'tokens': [processToken(token) for token in inputWitness]}


for name in glob.glob('collationChunks/1818_fullFlat_*'):
    matchString = name.split("fullFlat_", 1)[1]
    # ebb: above gets C30.xml for example
    matchStr = matchString.split(".", 1)[0]
    # ebb: above strips off the file extension
    with open(name, 'rb') as f1818file, \
            open('collationChunks/Thomas_fullFlat_' + matchString, 'rb') as fThomasfile, \
            open('collationChunks/1823_fullFlat_' + matchString, 'rb') as f1823file, \
            open('collationChunks/msColl_c56_' + matchString, 'rb') as fMSc56file, \
            open('collationChunks/msColl_c57_' + matchString, 'rb') as fMSc57file, \
            open('collationChunks/msColl_c58_' + matchString, 'rb') as fMSc58file, \
            open('collationChunks/msColl_c57Frag_' + matchString, 'rb') as fMSc57Fragfile, \
            open('collationChunks/msColl_c58Frag_' + matchString, 'rb') as fMSc58Fragfile, \
            open('collationChunks/1831_fullFlat_' + matchString, 'rb') as f1831file, \
            open('teiOutput/collation_' + matchStr + '.xml', 'w') as outputFile:
        fMSc56_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fMSc56file))).split('\n')
        fMSc57_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fMSc57file))).split('\n')
        fMSc58_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fMSc58file))).split('\n')
        fMSc57Frag_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fMSc57Fragfile))).split('\n')
        fMSc58Frag_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fMSc58Fragfile))).split('\n')
        f1818_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(f1818file))).split('\n')
        fThomas_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(fThomasfile))).split('\n')
        f1823_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(f1823file))).split('\n')
        f1831_tokens = regexLeadingBlankLine.sub('', regexBlankLine.sub('\n', extract(f1831file))).split('\n')
        f1818_tokenlist = processWitness(f1818_tokens, 'f1818')
        fThomas_tokenlist = processWitness(fThomas_tokens, 'fThomas')
        f1823_tokenlist = processWitness(f1823_tokens, 'f1823')
        fMSc56_tokenlist = processWitness(fMSc56_tokens, 'fMSc56')
        fMSc57_tokenlist = processWitness(fMSc57_tokens, 'fMSc57')
        fMSc58_tokenlist = processWitness(fMSc58_tokens, 'fMSc58')
        fMSc57Frag_tokenlist = processWitness(fMSc57Frag_tokens, 'fMSc57Frag')
        fMSc58Frag_tokenlist = processWitness(fMSc58Frag_tokens, 'fMSc58Frag')
        f1831_tokenlist = processWitness(f1831_tokens, 'f1831')
        collation_input = {"witnesses": [f1818_tokenlist, fThomas_tokenlist, f1823_tokenlist, fMSc56_tokenlist, fMSc57_tokenlist, fMSc58_tokenlist, fMSc57Frag_tokenlist, fMSc58Frag_tokenlist, f1831_tokenlist]}
        table = collate(collation_input, output='tei', segmentation=True)
        # table = collate(collation_input, segmentation=True, layout='vertical')
        # table = collate(collation_input, output='xml', segmentation=True)
        print('<!-- ' + nowStr + ' -->' + table, file=outputFile)


