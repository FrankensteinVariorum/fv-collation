<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
   <xsl:output method="text"/>
 <xsl:variable name="witnesses" as="xs:string+" select="distinct-values(//rdg/@wit)"/>   
    <xsl:template match="/">
        <xsl:text>App ID</xsl:text>
        <xsl:for-each select="$witnesses">
            <xsl:text>&#x9;</xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="descendant::app"/>
    </xsl:template>
    
    <xsl:template match="app">
        <xsl:variable name="currentApp" select="." as="element()"/>
       <xsl:value-of select="@xml:id"/>
        <xsl:for-each select="$witnesses">
            <xsl:variable name="currWit" as="xs:string" select="."/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:value-of select="$currentApp/rdg[@wit=$currWit]"/>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
 
</xsl:stylesheet>