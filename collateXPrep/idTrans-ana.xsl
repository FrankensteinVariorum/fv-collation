<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.tei-c.org/ns/1.0"   xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
  <!--2018-07-04 ebb: This was first built in the "raising" repo for the Balisage late-breaking paper, 1 July 2018, and I've added to the xsl:stylesheet so it can process TEI and pitt namespaces used in the Frankenstein Variorum project. -->
<xsl:output method="xml" indent="no"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="*[matches(@ana, '[Ss]tart')]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*[not(name() = 'ana')]">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="current()"/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:attribute name="ana">
                <xsl:text>start</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[matches(@ana, '[Ee]nd')]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*[not(name() = 'ana')]">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="current()"/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:attribute name="ana">
                <xsl:text>end</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
  
</xsl:stylesheet>