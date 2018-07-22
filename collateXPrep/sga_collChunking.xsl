<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:template match="/">
        <xsl:for-each-group select="//anchor[@type='collate']/following-sibling::node()" group-starting-with="anchor[@type='collate']">
            <!--2018-05-07 ebb: Things discovered the hard way: when creating new XML out of groups of elements like this, the elements that define the groups really must be at the same hierarchical level. Otherwise the output is full of weird duplicated stuff. Don't use the following:: axis here. Make sure the input is properly flattened accordingly. -->
            <!--2018-04-01 ebb: CHANGE THE FILE DIRECTORY BELOW (to collChunkFrags_c58) as needed. -->
            <xsl:result-document href="collationChunks/{substring-before(tokenize(ancestor::xml/base-uri(), '/')[last()], '.')}_{current()/@xml:id}.xml" method="xml" indent="no">
                <xml>
                    
                    <xsl:apply-templates select="current-group()"/>
                </xml>
                
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!--2018-05-12 ebb: With the next template rule, I'm making sure there's a white space following every lb element that isn't inside word-boundary markup. This may help to prevent squishing of word tokens together in the output collation. -->
    <xsl:template match="lb[not(following-sibling::node()[2]/@ana='end')]">
        <xsl:copy><xsl:apply-templates select="@*"/></xsl:copy><xsl:text> </xsl:text>
    </xsl:template>
    
</xsl:stylesheet>