<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-21 ebb: Bridge Edition Constructor Part 2: This second phase consumes the <app> and and <rdg> elements to replace them with <seg> elements that hold the identifiers of their apps and indication of whether they are portions.-->
<xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="bridge-P1Files" as="document-node()+" select="collection('bridge-P1')"/>
    <xsl:variable name="witnesses" as="xs:string+" select="distinct-values($bridge-P1Files//@wit)"/>
    <xsl:function name="pitt:compareWits" as="xs:boolean">
        <xsl:param name="rdg"/>
       <xsl:choose>
           <xsl:when test="$rdg[not(matches(., '&lt;.+?/&gt;'))]">
<xsl:for-each select="$rdg[not(last())]">
    <xsl:value-of select="normalize-space(.) eq normalize-space(following-sibling::rdg[1])"/>
</xsl:for-each>             
           </xsl:when>
           <xsl:otherwise>
               <xsl:variable name="nonTagPieces" as="xs:string+">
                   <xsl:value-of select="tokenize($rdg, '&lt;.+?/&gt;')"/>         
               </xsl:variable>
               <xsl:variable name="textMissingTags" as="xs:string" select="string-join($nonTagPieces, ' ')"/>
               <xsl:for-each select="$rdg[not(last())]">
                   <xsl:value-of select="normalize-space($textMissingTags) eq normalize-space(string-join(tokenize(following-sibling::rdg[1], '&lt;.+?/&gt;'), ' '))"/>     
               </xsl:for-each>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:function> 
    
   <xsl:template match="/">    
       <xsl:for-each select="$bridge-P1Files//TEI"> 
           <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>
           <xsl:result-document method="xml" indent="yes" href="bridge-P1/bridge-P2_{$chunk}.xml">
           <TEI xml:id="bridgeP2-{$chunk}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Bridge Phase 2: Collation unit <xsl:value-of select="$chunk"/></title>
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
        <div type="collation">
            <xsl:apply-templates  select="descendant::app"/>
                
               </div>
           </body>
                    
            </text>
        </TEI>
           </xsl:result-document>
        </xsl:for-each>
  
    </xsl:template> 
  
<xsl:template match="app">
    <xsl:param name="rdg" select="rdg" as="element()+"/>
  <xsl:choose>
      <xsl:when test="@type='invariant'">
          <xsl:apply-templates mode="invariant"/>
      </xsl:when>
      <xsl:when test="count($rdg) eq 4">
        <xsl:value-of select="pitt:compareWits($rdg)"/>
        
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates mode="variant"/>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    <xsl:template match="rdg" mode="invariant">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="rdg" mode="variant">
      <seg xml:id="{parent::app/@xml:id}_start"/>
        <xsl:apply-templates/><seg xml:id="{parent::app/@xml:id}_end"/> 
    </xsl:template>
</xsl:stylesheet>