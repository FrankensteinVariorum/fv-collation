<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="mod[not(child::*)]">
        <xsl:comment><xsl:value-of select="name()"/><xsl:text> </xsl:text><xsl:for-each select="@*">
            <xsl:text> </xsl:text><xsl:value-of select="name()"/><xsl:text>="</xsl:text><xsl:value-of select="current()"/><xsl:text>"</xsl:text>
        </xsl:for-each></xsl:comment>
    </xsl:template>
    <xsl:template match="mod[count(child::*) lt 2 and child::restore]">
      <xsl:comment>mod</xsl:comment>  <xsl:apply-templates/><xsl:comment>/mod</xsl:comment>
    </xsl:template>
</xsl:stylesheet>