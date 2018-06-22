<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <xsl:template match="/">
        <xsl:for-each-group select="//anchor/following-sibling::node()" group-starting-with="anchor">
            <xsl:result-document
                href="collationChunks/{substring-before(tokenize(base-uri(), '/')[last()], '.')}_{current()/@xml:id}.xml"
                method="xml" indent="yes">
                <xml>
                    <xsl:apply-templates select="current-group()"/>
                </xml>

            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
