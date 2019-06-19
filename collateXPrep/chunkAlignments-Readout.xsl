<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
    <xsl:variable name="anchorPoints1818" as="element()+" select="$frankenChunks//anchor[@type='collate'][contains(tokenize(base-uri(), '/')[last()], '1818') ]"/>

   
    <xsl:template match="/">
      <xml><xsl:apply-templates select="$anchorPoints1818">
          <xsl:sort select="@xml:id"/>
      </xsl:apply-templates>
      </xml>  
    </xsl:template>
    <xsl:template match="anchor[@type='collate']">
            <xsl:value-of select="tokenize(current()/base-uri(), '/')[last()]"/>: 
        <xsl:copy-of select="current()"/>
        <xsl:copy-of select="current()/following-sibling::*[1]"/>
        <xsl:for-each select="$frankenChunks[not(contains(tokenize(base-uri(), '/')[last()], '1818'))]//anchor[@xml:id = current()/@xml:id] => sort()">
            <xsl:copy-of select="current()"/>
            <xsl:copy-of select="current()/following-sibling::*[1]"/>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>