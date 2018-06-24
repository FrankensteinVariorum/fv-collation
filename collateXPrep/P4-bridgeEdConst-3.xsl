<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<!--<xsl:mode on-no-match="shallow-copy"/>-->
    <xsl:variable name="output2-P4-C10" as="document-node()+" select="collection('bridge-P4-C10/output2')"/>
    
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files . -->    
   <xsl:template match="/">
       <xsl:for-each select="$output2-P4-C10//TEI">
           <xsl:variable name="currentP4File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'output2-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/output3/{$filename}">
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
       
                <xsl:for-each-group select="descendant::*[@ana='Start'][@loc]/following-sibling::node()" group-by="@loc">
                    <xsl:variable name="groupKey" select="current-grouping-key()"/>            
  <xsl:variable name="currentElem" select="$divNode//*[@loc=$groupKey][@ana='Start']"/> 
   <xsl:element name="{$currentElem}">
       <xsl:for-each select="$currentElem/@*">
           <xsl:attribute name="{current()/name()}">
               <xsl:value-of select="current()"/>
           </xsl:attribute>
       </xsl:for-each>
     <xsl:for-each select="$divNode//*[@loc=$groupKey and @ana='Start']/following-sibling::node()[following-sibling::*[@loc=$groupKey and @ana='End']]">
         <xsl:copy-of select="current()"/></xsl:for-each>
   </xsl:element>
                </xsl:for-each-group>
           
                        
        </div>
         </xsl:template>
  
</xsl:stylesheet>


