<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-26 ebb: Spine Reconstructor: Once the <seg>...</seg> elements are set in their places and the XML hierarchy of the edition files is regenerated, add data about the seg elements (where they've been subdivided) to the "spine" holding standoff info for pointers.    
    -->
<xsl:output method="xml" indent="yes"/>  

    <xsl:variable name="bridge-P5Files" as="document-node()+" select="collection('bridge-P5-C10')"/>
       
   
</xsl:stylesheet>