from collatex import *
from xml.dom import pulldom
import string
import re
import json

regexWhitespace = re.compile(r'\s+')
regexNonWhitespace = re.compile(r'\S+')
regexEmptyTag = re.compile(r'/>$')
regexBlankLine = re.compile(r'\n{2,}')
regexLeadingBlankLine = re.compile(r'^\n')
regexPageBreak = re.compile(r'<pb.+?/>')

# Element types: xml, div, head, p, hi, pb, note, lg, l; comment()
# Tags to ignore, with content to keep: xml
# Structural elements: div, p, lg, l
# Inline elements (empty) retained in normalization: pb
# Inline elements (with content) retained in normalization: note, hi, head

# GIs fall into one three classes
ignore = ['xml']
inlineEmpty = ['pb']
inlineContent = ['hi']
blockElement = ['p', 'div', 'lg', 'l', 'head', 'comment', 'note']

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
        # empty inline elements: pb
        elif event == pulldom.START_ELEMENT and node.localName in inlineEmpty:
            output += node.toxml()
        # non-empty inline elements: note, hi, head, l, lg, div, p
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
    return regexPageBreak('',inputText)

def processToken(inputText):
    return {"t": inputText + ' ', "n": regexPageBreak.sub('',inputText)}

def processWitness(inputWitness, id):
    return {'id': id, 'tokens' : [processToken(token) for token in inputWitness]}

with open('1818_Ch1.xml', 'rb') as f1818file, \
    open('1823_Ch1.xml', 'rb') as f1823file, \
    open('1831_Chs1-2.xml', 'rb') as f1831file, \
    open('output.txt', 'w') as outputFile:
    f1818_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1818file))).split('\n')
    f1823_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1823file))).split('\n')
    f1831_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1831file))).split('\n')
    f1818_tokenlist = processWitness(f1818_tokens, 'f1818')
    f1823_tokenlist = processWitness(f1823_tokens, 'f1823')
    f1831_tokenlist = processWitness(f1831_tokens, 'f1831')
    collation_input = {"witnesses": [f1818_tokenlist, f1823_tokenlist, f1831_tokenlist]}
    table = collate(collation_input, output='tei', segmentation=True)
    print(table)

