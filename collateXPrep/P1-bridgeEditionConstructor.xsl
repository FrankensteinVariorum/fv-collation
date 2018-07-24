<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-21 ebb: Bridge Edition Constructor Part 1: This first phase up-converts to TEI and adds xml:ids to each <app> element in the output collation. In the event that the collation process broke apart the self-closed elements into two tags, this stylesheet catches these and restores them to single tags.  -->
<xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="collFiles" as="document-node()+" select="collection('Full_xmlOutput')"/>
    
    <xsl:variable name="witnesses" as="xs:string+" select="distinct-values($collFiles//@wit)"/>
   <xsl:template match="/">    
       <xsl:for-each select="$collFiles//root"> 
           <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>
           <xsl:result-document method="xml" indent="yes" href="bridge-P1/bridge-P1_{$chunk}.xml">
           <TEI xml:id="bridgeP1-{$chunk}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Bridge Phase 1: Collation unit <xsl:value-of select="$chunk"/></title>
                    </titleStmt>
                    <publicationStmt>
                        <authority>Frankenstein Variorum Project</authority>
                        <date>2018</date>
                        <availability>
                            <licence>Distributed under a Creative Commons
                                Attribution-ShareAlike 3.0 Unported License</licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Produced from collation output:<xsl:value-of select="./../comment()"/></p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
           <body> 
        <ab type="alignmentChunk">
            <xsl:apply-templates  select="descendant::app">
                 <xsl:with-param name="chunk" select="$chunk" tunnel="yes"/>
             </xsl:apply-templates>
            </ab>
           </body>
                    
            </text>
        </TEI>
           </xsl:result-document>
        </xsl:for-each>
  
    </xsl:template> 
  
<xsl:template match="app">
    <xsl:param name="chunk" tunnel="yes"/>
   <xsl:choose><xsl:when test="@type"> <app type="{@type}" xml:id="{$chunk}_app{count(preceding::app) + 1}"><xsl:apply-templates/></app></xsl:when>
   <xsl:otherwise>
       <app xml:id="{$chunk}_app{count(preceding::app) + 1}"><xsl:apply-templates select="rdg"/></app>
   </xsl:otherwise>
   </xsl:choose>
</xsl:template>
    <xsl:template match="rdg">
        <rdg wit="{@wit}"><xsl:analyze-string select="." regex="&lt;([^/]+?)&gt;\s*&lt;/\1&gt;">
          <xsl:matching-substring>
              <xsl:value-of select="tokenize(., '\s*&lt;/')[1] ! substring-before(., '&gt;')"/><xsl:text>/&gt;</xsl:text>
          </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
      </xsl:analyze-string></rdg>  
    </xsl:template>
    
</xsl:stylesheet>