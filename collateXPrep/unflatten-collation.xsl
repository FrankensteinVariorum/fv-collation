<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-17 ebb: This is a false start but it begins to address the flattened markup. Save this for outputting HTML, and rewrite it to output HTML, too. Use xsl:analyze-string to unpack the flattened elements and address them. 
        Spans for the "hotspot" variant passages will have to be folded in, perhaps in a separate process. -->    
<xsl:output method="xml" indent="yes"/>    
<!--<xsl:mode on-no-match="shallow-copy"/>-->
    <xsl:variable name="collUnit" as="xs:string" select="substring-before(substring-after(tokenize(base-uri(.), '/')[last()], '_'), '.')"/>
    <xsl:variable name="witnesses" as="xs:string+" select="distinct-values(//@wit)"/>
   <xsl:template match="root">
       <xsl:param name="app" select="descendant::app" as="element()+" tunnel="yes"/>
       <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Frankenstein variorum project: Collation unit <xsl:value-of select="$collUnit"/></title>
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
                      
       
       <xsl:for-each select="$witnesses"> 
           <TEI xml:id="{$collUnit}-{substring-after(current(), '#')}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Collation unit <xsl:value-of select="$collUnit"/><xsl:text>-</xsl:text><xsl:value-of select="substring-after(current(), '#')"/></title>
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
             <xsl:apply-templates  select="$app/rdg[@wit=current()]">
                 <xsl:with-param name="currWit" select="current()" as="xs:string" tunnel="yes"/>
             </xsl:apply-templates>            
            </text>
        </TEI>
        </xsl:for-each>
        </teiCorpus>
    </xsl:template> 
  

    
    
</xsl:stylesheet>