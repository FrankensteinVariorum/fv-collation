<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:variable name="ThomasOld" select="collection('ThomasCopy')"/>
   <!-- <xsl:mode on-no-match="shallow-copy"/>-->
    <xsl:template match="/">
        <xsl:for-each select="$ThomasOld//xml">
            <xsl:result-document href="ThomasCopyReflattened/{tokenize(base-uri(), '/')[last()]}" method="xml" indent="yes">
           <xml>
             <xsl:apply-templates/>  
           </xml>      
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p">
       <!-- <xsl:variable name="locationFlag">
            <xsl:for-each select="ancestor::div">
                <xsl:value-of select="@type"/>
                <xsl:value-of select="count(current()/preceding-sibling::div) + 1"/>
                <xsl:text>__</xsl:text>
            </xsl:for-each>
        </xsl:variable>-->
        <xsl:copy>
           <!-- <xsl:attribute name="loc">
                <xsl:value-of select="$locationFlag"/>
                <xsl:text>Start</xsl:text>
            </xsl:attribute>-->
        </xsl:copy>
       
   <xsl:apply-templates/>
        <xsl:copy>
           <!-- <xsl:attribute name="loc">
                <xsl:value-of select="$locationFlag"/>
                <xsl:text>End</xsl:text>
            </xsl:attribute>-->
        </xsl:copy>
    </xsl:template>
   
    
</xsl:stylesheet>