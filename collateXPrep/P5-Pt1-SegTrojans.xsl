<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P4-BridgeColl" as="document-node()+" select="collection('bridge-P4')"/> 
<!--2018-07-27: Bridge Construction Phase 5: What we need to do:      
       *  where the end markers of seg elements are marked we reconstruct them in pieces. 
        * raise the <seg> marker elements marking hotspots
       *  deliver seg identifying locations to the Spinal Column file. -->    
   <xsl:template match="/">
       <xsl:for-each select="$P4-BridgeColl//TEI">
           <xsl:variable name="currentP4File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>P5-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P4-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="tokenize(base-uri(), '/')[last()] ! substring-before(., '.') ! substring-after(., '_')"/> 

           <xsl:result-document method="xml" indent="yes" href="bridge-P5A/{$filename}">
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
            <xsl:text>Bridge Phase 5:</xsl:text><xsl:value-of select="tokenize(., ':')[last()]"/>
        </title>
    </xsl:template>
 

  <!--  <xsl:template match="seg[contains(@xml:id, '_start') and substring-before(@xml:id, '_start') = following-sibling::seg[1]/substring-before(@xml:id, '_end')]">
      <xsl:variable name="currentIDFlag" select="@xml:id" as="xs:string"/>
      <xsl:variable name="currentID" select="substring-before($currentIDFlag, '_start')"/>
 <seg sID="{$currentID}"/>
  </xsl:template>
  
    <xsl:template match="seg[contains(@xml:id, '_end') and substring-before(@xml:id, '_end') = preceding-sibling::seg[1]/substring-before(@xml:id, '_start')]">
        <xsl:variable name="currentIDFlag" select="@xml:id" as="xs:string"/>
        <xsl:variable name="currentID" select="substring-before($currentIDFlag, '_end')"/>
      <seg eId="{$currentID}"/>
    </xsl:template>-->
        <xsl:template match="*[seg[@xml:id, '_start'] and not(following-sibling::seg[@xml:id, '_end'])]">
          <xsl:element name="{name()}">
              <xsl:copy-of select="@*"/>
              <xsl:for-each select="child::node()">
                  <xsl:choose>
                      <xsl:when test="self::node()[not(self::seg)][preceding-sibling::seg[1][contains(@xml:id, '_start')] and following-sibling::seg[1][contains(@xml:id, 'end')]]">
                        <xsl:apply-templates select="current()"/>  
                      </xsl:when>
                      <xsl:when test="self::seg[contains(@xml:id, '_start') and not(following-sibling::seg[1][contains(@xml:id, '_end')])]">
                          <xsl:variable name="currentIDFlag" select="@xml:id" as="xs:string"/>
                          <xsl:variable name="currentID" select="substring-before($currentIDFlag, '_end')"/>
                          <seg xml:id="{$currentID}__I" part="I">
                              <xsl:apply-templates select="following-sibling::node()"/>
                          </seg>
                      </xsl:when> 
                      <xsl:when test="self::node()[not(self::seg)][following-sibling::seg[1][contains(@xml:id, '_end')] and not(preceding-sibling::seg[1][contains(@xml:id, '_start')])]">
                          <xsl:variable name="currentIDFlag" select="following-sibling::seg[1]/@xml:id" as="xs:string"/>
                          <xsl:variable name="currentID" select="substring-before($currentIDFlag, '_end')"/>
                          <seg xml:id="{$currentID}__F" part="F">
                              
                              <xsl:apply-templates select="following-sibling::node()[following-sibling::seg[1][contains(@xml:id, '_end')]]"/> 
                          </seg>
                      </xsl:when>
                      <xsl:when test="self::seg[contains(@xml:id, '_end') and not(preceding-sibling::seg[1][contains(@xml:id, '_start')])]">
                          <xsl:variable name="currentIDFlag" select="@xml:id" as="xs:string"/>
                          <xsl:variable name="currentID" select="substring-before($currentIDFlag, '_end')"/>
                          <seg xml:id="{$currentID}__F" part="F"/>    
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:copy-of select="."/>
                      </xsl:otherwise>
                  </xsl:choose>
              </xsl:for-each>
          </xsl:element>
                
               
         
    </xsl:template>

</xsl:stylesheet>


