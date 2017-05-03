from collatex import *
from xml.dom import pulldom
import string
import re
import json

regexWhitespace = re.compile(r'\s+')
regexEmptyTag = re.compile(r'/>$')

# Element types: xml, div, head, p, hi, pb, note, lg, l; comment()
# Tags to ignore, with content to keep: xml
# Structural elements: div, p, lg, l
# Inline elements (empty) retained in normalization: pb
# Inline elements (with content) retained in normalization: note, hi, head

# GIs fall into one three classes
ignore = ['xml']
inlineEmpty = ['pb']
inlineContent = ['note', 'hi', 'head','l','lg', 'div', 'p']

def normalizeSpace(inText):
    """Replaces all whitespace spans with single space characters"""
    return regexWhitespace.sub(' ', inText)

def extract(input_xml):
    """Process entire input XML document, firing on events"""
    # Start pulling; it continues automatically
    doc = pulldom.parse(input_xml)
    output = ''
    for event, node in doc:
        print(event, node.toxml())
        # elements to ignore: xml
        if event == pulldom.START_ELEMENT and node.localName in ignore:
            continue
        # copy comments intact
        if event == pulldom.COMMENT:
            print('FOUND A COMMENT')
            doc.expandNode(node)
            output += node.toxml()
        # empty inline elements: pb
        elif event == pulldom.START_ELEMENT and node.localName in inlineEmpty:
            output += node.toxml()
        # non-empty inline elements: note, hi, head, l, lg, div, p
        elif event == pulldom.START_ELEMENT and node.localName in inlineContent:
            output += regexEmptyTag.sub('>', node.toxml())
        elif event == pulldom.END_ELEMENT and node.localName in inlineContent:
            output += '</' + node.localName + '>\n'
        elif event == pulldom.CHARACTERS:
            output += normalizeSpace(node.data)
    return output

with open('1818_Ch1.xml', 'rb') as f1818file, \
    open('1823_Ch1.xml', 'rb') as f1823file, \
    open('1831_Chs1-2.xml', 'rb') as f1831file, \
    open('output.txt', 'w') as outputFile:
    parseResult = extract(f1831file)
    print(parseResult)
