import re

RE_StartTagMark = re.compile(r'\sana="[Ss]tart.*?"/>')
RE_EndTagMark = re.compile(r'<.+?\sana="[Ee]nd.*?"/>"/>')
RE_splitEnd1 = RE_EndTagMark.split(r' ana=')
NewEndTag = RE_splitEnd1[0] + '>'

def replaceStartTags(inText):
    """Replaces all element placeholders for start tags with element start tags"""
    RE_StartTagMark.search(inText):
    return RE_StartTagMark.sub('>', inText)

def replaceEndTags(inText):
    """Replaces all element placeholders for end tags with element end tags"""
    RE_EndTagMark.search(inText):
    return EndTagMark.sub(NewEndTag, inText)