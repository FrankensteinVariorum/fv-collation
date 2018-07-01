from typing import Pattern

from collatex import *
from xml.dom import pulldom
import string
import re
import json
import glob

regexWhitespace = re.compile(r'\s+')
regexNonWhitespace = re.compile(r'\S+')
regexEmptyTag = re.compile(r'/>$')
regexBlankLine = re.compile(r'\n{2,}')
regexLeadingBlankLine = re.compile(r'^\n')
regexPageBreak = re.compile(r'<pb.+?/>')
RE_MARKUP = re.compile(r'<.+?>')
RE_AMP = re.compile(r'&amp;')
RE_AND = re.compile(r'and')
RE_mOrning = re.compile(r'mOrning')
# Element types: xml, div, head, p, hi, pb, note, lg, l; comment()
# Tags to ignore, with content to keep: xml, comment, anchor
# Structural elements: div, p, lg, l
# Inline elements (empty) retained in normalization: pb, milestone, xi:include
# Inline and block elements (with content) retained in normalization: note, hi, head, ab

# GIs fall into one three classes
# 2017-05-21 ebb: Due to trouble with pulldom parsing XML comments, I have converted these to comment elements
# 2017-05-22 ebb: I've set anchor elements with @xml:ids to be the indicators of collation "chunks" to process together
ignore = ['xml']
inlineEmpty = ['milestone', 'anchor', 'include', 'pb']
inlineContent = ['hi']
blockElement = ['p', 'div', 'lg', 'l', 'head', 'comment', 'note', 'ab', 'cit', 'quote', 'bibl', 'header']

def normalizeSpace(inText):
    """Replaces all whitespace spans with single space characters"""
    if regexNonWhitespace.search(inText):
        return regexWhitespace.sub('\n', inText)
    else:
        return ''

def extract(input_xml):
    """Process entire input XML document, firing on events"""
    # Start pulling; it continues automatically
    doc = pulldom.parseString(input_xml)
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

# def normalize(inputText):
#   return regexPageBreak.sub('',inputText)


def normalize(inputText):
   return RE_AMP.sub('and',\
          RE_MARKUP.sub('', inputText)).lower()

def processToken(inputText):
    return {"t": inputText + ' ', "n": normalize(inputText)}

def processWitness(inputWitness, id):
    return {'id': id, 'tokens' : [processToken(token) for token in inputWitness]}

fms_input = '''It was on a dreary night of November that I beheld the frame on whic my man completeed, and with an 
        anxiety that almost amounted to agony I collected the instruments of life around me that I might infuse a 
        spark of being into the lifeless thing that lay at my feet. '''
f1818_input = '''From this time Elizabeth Lavenza became my playfellow, and, as we grew older, my
            friend. She was docile and good tempered, yet gay and playful as a summer insect.
            Although she was lively and animated, her feelings were strong and deep, and her
            disposition uncommonly affectionate. No one could better enjoy liberty, yet no one could
            submit with more grace than she did to constraint and caprice.'''
fThomas_input=''' '''
f1823_input = '''<p>The following morning the rain poured down in torrents, and thick mists hid the summits
            of the mountains. I rose early, but felt unusually melancholy. The rain depressed me; my
            old feelings recurred, and I was miserable. I knew how disappointed my father would be
            at this sudden change, and I wished to avoid him until I had recovered myself so far as
            to be enabled to conceal those feelings that overpowered me. I knew that they would
            remain that day at the inn; <pb xml:id="F1823_v1_218" n="199"/>and as I had ever inured
            myself to rain, moisture, and cold, I resolved to go alone to the summit of Montanvert.
            I remembered the effect that the view of the tremendous and ever-moving glacier had
            produced upon my mind when I first saw it. It had then filled me with a sublime ecstacy
            that gave wings to the soul, and allowed it to soar from the obscure world to light and
            joy. The sight of the awful and majestic in nature had indeed always the effect of
            solemnizing my mind, and causing me to forget the passing cares of life. I determined to
            go alone, for I was well acquainted with the path, and the presence of another would
            destroy the solitary grandeur of the scene.</p>'''
f1831_input = ''' '''

fms_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(fms_input))).split('\n')
f1818_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1818_input))).split('\n')
fThomas_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(fThomas_input))).split('\n')
f1823_tokens = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1823_input))).split('\n')
f1831_input = regexLeadingBlankLine.sub('',regexBlankLine.sub('\n', extract(f1831_input))).split('\n')
f1818_tokenlist = processWitness(f1818_tokens, 'f1818')
f1823_tokenlist = processWitness(f1823_tokens, 'f1823')
collation_input = {"witnesses": [f1818_tokenlist, f1823_tokenlist]}
table = collate(collation_input, segmentation=True, output="svg")
outputFile = open('C10-NormalizedTokens/C-10portion' + '.svg', 'w')
print(table, file=outputFile)
# table = collate(collation_input, segmentation=True, layout='vertical')
# test = normalize(f1818_input)
# print(test, table)
# print(f1818_tokenlist)

