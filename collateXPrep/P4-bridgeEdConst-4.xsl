<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

 <!-- <xsl:mode on-no-match="shallow-copy"/>-->
    <xsl:variable name="P3-BridgeColl-C10" as="document-node()+" select="collection('bridge-P3-C10')"/>
    <xsl:variable name="testerDoc" as="document-node()" select="doc('bridge-P3/P3-f1818_C10.xml')"/>
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files . -->    
   <xsl:template match="/">
       <xsl:for-each select="$P3-BridgeColl-C10//TEI">
           <xsl:variable name="currentP3File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>P4-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P3-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/{$filename}">
        <TEI><xsl:apply-templates select="descendant::teiHeader"/>
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
        <xsl:variable name="divNode" select="." as="element()"/>
        <div type="collation" xml:id="{@xml:id}">
            <xsl:variable name="editionFullElements" as="element()+" select="descendant::*[not(self::seg) and matches(@ana, '[Ss]tart')][following-sibling::*[name() = ./name() and matches(@ana, '[Ee]nd')]]"/>
            <!--2018-06-24 This should identify all the elements that in the original edition files should contain full text. However, it's posing problems to try to process them all together in one for-each-group. So I'm proceeding with the paragraphs first... -->
       
                <xsl:for-each-group select="descendant::p[@ana='Start']/following-sibling::node()" group-by="@loc">
                    <xsl:variable name="groupKey" select="current-grouping-key()"/>            
  <xsl:variable name="currentElem" select="$divNode//p[@loc=$groupKey][@ana='Start']"/> 
   <p xml:id="{$groupKey}">
     <xsl:for-each select="$divNode//p[@loc=$groupKey and @ana='Start']/following-sibling::node()[following-sibling::p[@loc=$groupKey and @ana='End']]">
         <xsl:copy-of select="current()"/></xsl:for-each>
   </p>
                </xsl:for-each-group>
           
                        
        </div>
         </xsl:template>
  
</xsl:stylesheet>


