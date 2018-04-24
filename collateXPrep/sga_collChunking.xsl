<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

   <xsl:template match="/">
       <xsl:for-each-group select="//anchor[@type='collate']/following::*" group-starting-with="anchor[@type='collate']">
           <!--2018-04-01 ebb: CHANGE THE FILE DIRECTORY BELOW if/as needed. -->
       <xsl:result-document href="collationChunksPrep/{substring-before(tokenize(ancestor::xml/base-uri(), '/')[last()], '.')}_{current()/@xml:id}.xml" method="xml" indent="yes">
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
    
</xsl:stylesheet>