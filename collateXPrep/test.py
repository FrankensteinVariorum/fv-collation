from xml.dom import pulldom

def extract(input_xml):
    doc = pulldom.parse(input_xml)
    for event, node in doc:
        print(event, node)
    return True

with open('test.xml', 'rb') as testfile:
    extract(testfile)
