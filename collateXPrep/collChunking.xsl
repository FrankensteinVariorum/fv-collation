<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
    <xsl:variable name="printCollFlat" as="document-node()+" select="collection('print-fullFlat')"/>
    <xsl:template match="/">
        <xsl:for-each select="$printCollFlat">
            <xsl:variable name="currFile" as="document-node()" select="current()"/>
        <xsl:for-each-group select="$currFile//anchor/following-sibling::node()" group-starting-with="anchor">
            <xsl:result-document
                href="collationChunks/{substring-before(tokenize(base-uri(), '/')[last()], '.')}_{current()/@xml:id}.xml"
                method="xml" indent="yes">
                <xml>
                    <xsl:apply-templates select="current-group()"/>
                </xml>

            </xsl:result-document>
        </xsl:for-each-group>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
