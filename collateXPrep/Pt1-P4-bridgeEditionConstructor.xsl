<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<!--<xsl:mode on-no-match="shallow-copy"/>-->
    <xsl:variable name="P3-BridgeColl-C10" as="document-node()+" select="collection('bridge-P3-C10')"/>
    <xsl:variable name="testerDoc" as="document-node()" select="doc('bridge-P3-C10/P3-fThomas_C10.xml')"/>  
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files . -->    
   <xsl:template match="/">
       <xsl:for-each select="$P3-BridgeColl-C10//TEI">
           <xsl:variable name="currentP3File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>P4-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P3-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/> 
           <xsl:variable name="flat-not-p" select="$currentP3File//*[@ana and @loc and not(self::p)]" as="element()+"/>
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/output1/output1-{$filename}">
        <TEI>
            <xsl:apply-templates select="descendant::teiHeader"/>
        <text>
            <body>
                <xsl:apply-templates select="descendant::div[@type='collation']"/>
            </body>
        </text>
        </TEI>
         </xsl:result-document>
       </xsl:for-each>
       
   </xsl:template>
 <xsl:template match="teiHeader">
     <teiHeader>
         <fileDesc>
         <titleStmt><xsl:apply-templates select="descendant::titleStmt/title"/></titleStmt>
         <xsl:copy-of select="descendant::publicationStmt"/>
         <xsl:copy-of select="descendant::sourceDesc"/>
     </fileDesc>
     </teiHeader>
 </xsl:template>
    <xsl:template match="titleStmt/title">
        <title>
            <xsl:text>Bridge Phase 4:</xsl:text><xsl:value-of select="tokenize(., ':')[last()]"/>
        </title>
    </xsl:template>
    <xsl:template match="div[@type='collation']">
        <div type="collation">
           <xsl:apply-templates select="descendant::*[@loc = following-sibling::*[@loc][1]/@loc]"/> 
          <!--  <xsl:apply-templates select="descendant::*[@loc]"/>-->
        </div>
    </xsl:template>
 
 <xsl:template match="*[@loc = following-sibling::*[@loc][1]/@loc]">
     <xsl:variable name="currNode" select="current()" as="node()"/>
        <xsl:variable name="currLoc" select="@loc" as="xs:string"/>
        <xsl:comment>This template rule for text- and sig-bearing loc nodes is firing now.</xsl:comment>
     
   <xsl:variable name="beforeThis" as="node()*">
        <!-- <xsl:copy-of select="preceding-sibling::node()"/>-->
        <xsl:copy-of select="$currNode/preceding-sibling::node()[preceding-sibling::*[@loc]/@loc = $currNode/preceding-sibling::*[@loc][1]/@loc or self::*[@loc = $currNode/preceding-sibling::*[@loc][1]/@loc]]"/>
     </xsl:variable>
     <xsl:choose><xsl:when test="$beforeThis[self::*[@loc]]">
        <xsl:comment>Found @loc node(s) before this point: <xsl:value-of select="$beforeThis[self::*[@loc]]/name()"/></xsl:comment>
         <xsl:apply-templates select="$beforeThis[self::*[@loc]]"/>
     </xsl:when>
     <xsl:otherwise>
         <xsl:copy-of select="$beforeThis[not(@loc)]"/>
     </xsl:otherwise>
     </xsl:choose>
        <xsl:element name="{name()}">
            <xsl:for-each select="@*[not(name() = 'ana')]">
                <xsl:attribute name="{current()/name()}">
                    <xsl:value-of select="current()"/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="following-sibling::node()[following-sibling::*[@loc = $currLoc]]"/>
        </xsl:element>
    <xsl:variable name="afterThis" as="node()*">
         <!--<xsl:copy-of select="following-sibling::node()[preceding-sibling::*[@loc][1][@loc = $currLoc and @ana='end']]"/>-->
         <xsl:copy-of select="$currNode/following-sibling::node()[self::*[@loc = $currNode/preceding-sibling::*[@loc][1]/@loc] or preceding-sibling::*[@loc eq $currLoc and @ana='end'] and following-sibling::*[@loc]/@loc = $currNode/following-sibling::*[@loc][1]/@loc]"/>
     </xsl:variable>
     <xsl:choose><xsl:when test="$afterThis[@loc]">
         <xsl:comment>Found @loc node(s) after this point: <xsl:value-of select="$afterThis[@loc]/name()"/></xsl:comment>
         <xsl:apply-templates select="$afterThis[@loc]"/></xsl:when>
     <xsl:otherwise>
             <xsl:apply-templates select="$afterThis[not(@loc)]"/>
     </xsl:otherwise>
     </xsl:choose>
    </xsl:template>
   
    <xsl:template match="div[@type='collation']//*[not(@loc)]">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    
    <xsl:template match="*[@ana='start' and @loc = following-sibling::*[@ana][1]/following-sibling::*[@ana='end']/@loc]">
        <xsl:comment>This template rule for outer-hull elements is firing now.</xsl:comment>
        <xsl:variable name="currentLoc" as="xs:string" select="@loc"/>
        <xsl:comment>The value of currentLoc is <xsl:value-of select="$currentLoc"/></xsl:comment>
        <xsl:variable name="thisEndTag" select="following-sibling::*[@loc = $currentLoc and @ana='end']" as="element()"/>
        <xsl:variable name="thisEndTagName" select="$thisEndTag/name()" as="xs:string"/> 
        <xsl:element name="{name()}">
            <xsl:for-each select="@*[not(name() = 'ana')]">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="current()"/>
                </xsl:attribute>   
            </xsl:for-each>
            <xsl:apply-templates select="following-sibling::node()[following-sibling::*[@loc][1][@loc ne $currentLoc] and following-sibling::*[@loc=$currentLoc and @ana='end']]"/>
 
        </xsl:element>
    </xsl:template>
    
  <xsl:template match="*[@ana='end'][@loc = preceding-sibling::*[@ana='start']/@loc]">
    </xsl:template>
</xsl:stylesheet>


