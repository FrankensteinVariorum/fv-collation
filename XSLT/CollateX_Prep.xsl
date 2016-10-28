<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
version="3.0">
    <!--<xsl:strip-space elements="*"/>-->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    
    <xsl:template match="text()">
       <xsl:value-of select="normalize-space(replace(., '&quot;', concat('\\', '&quot;')))"/>
        
    </xsl:template>
    <xsl:template match="teiHeader">
    </xsl:template>
    <xsl:variable name="Ed1831" select="doc('../frankenTexts_orig/frank27.1831v1.ch1.xml')//text/*"/>
        
    
    
   
    <xsl:template match="text"><xsl:text>{"witnesses" : [ {"id" : "Ed1818", "content" : "</xsl:text><xsl:apply-templates/><xsl:text>"},
        {"id" : "Ed1831", "content" : "</xsl:text><xsl:apply-templates select="$Ed1831"/><xsl:text>"}]<!--, "algorithm": "dekker"-->}</xsl:text>
       
   </xsl:template>
    

    
    
    
    
    
</xsl:stylesheet>