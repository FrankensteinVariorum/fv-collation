<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="p">
        <xsl:variable name="locationFlag">
            <xsl:for-each select="ancestor::div">
                <xsl:value-of select="@type"/>
                <xsl:value-of select="count(current()/preceding-sibling::div) + 1"/>
                <xsl:text>__</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="loc">
                <xsl:value-of select="$locationFlag"/><xsl:text>p</xsl:text>
                <xsl:value-of select="count(preceding::p) + 1"/><xsl:text>__</xsl:text>
                <xsl:text>Start</xsl:text>
            </xsl:attribute>
        </xsl:copy>
       
   <xsl:apply-templates/>
        <xsl:copy>
            <xsl:attribute name="loc">
                <xsl:value-of select="$locationFlag"/>
                <xsl:text>End</xsl:text>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div">
        <milestone unit="{@type}" type="start">
            <xsl:choose><xsl:when test="@n">
                <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute></xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="n">
                    <xsl:value-of select="count(preceding::div[@type=current()/@type]) + 1"/>
                </xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            </milestone>
            <xsl:apply-templates/>
        <milestone unit="{@type}" type="end">
            <xsl:choose><xsl:when test="@n">
                <xsl:attribute name="n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute></xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="n">
                        <xsl:value-of select="count(preceding::div[@type=current()/@type]) + 1"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            </milestone>
    </xsl:template>
    
</xsl:stylesheet>