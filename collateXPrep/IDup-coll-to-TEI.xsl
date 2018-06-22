<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
    
<!--2018-06-17 ebb: Run this over the collection of collated XML files to pull them into a teiCorpus, and build this up with an xsl:for-each to generate an internal TEI element for each collation unit.  -->
    
<xsl:output method="xml" indent="yes"/>    
<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="collUnit" as="xs:string" select="substring-before(substring-after(tokenize(base-uri(.), '/')[last()], '_'), '.')"/>
  
   <xsl:template match="root">
    <!--   <xsl:param name="app" select="descendant::app" xmlns="http://www.tei-c.org/ns/1.0" as="element()+" tunnel="yes"/>-->
        <teiCorpus>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Frankenstein variorum collation <xsl:value-of select="$collUnit"/></title>
                       <!--Flesh out editor / collaboration info. -->
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
                      
           <TEI xml:id="{$collUnit}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Collation unit <xsl:value-of select="$collUnit"/></title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
             <body><xsl:apply-templates/>
             </body> 
            </text>
        </TEI>
        
        </teiCorpus>
    </xsl:template> 
    <xsl:template match="app">
        <xsl:choose>
            <xsl:when test="@type">
                <app type="{@type}"><xsl:apply-templates/></app>
            </xsl:when>
            <xsl:otherwise><app><xsl:apply-templates/></app></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="rdg">
        <rdg wit="{@wit}"><xsl:apply-templates/></rdg>
    </xsl:template>
       
    
</xsl:stylesheet>