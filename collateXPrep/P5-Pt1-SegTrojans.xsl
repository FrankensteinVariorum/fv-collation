<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P4-BridgeColl" as="document-node()+" select="collection('bridge-P4')"/> 
<!--2018-07-27: STILL NOT WORKING Bridge Construction Phase 5: What we need to do:      
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

           <xsl:result-document method="xml" indent="yes" href="bridge-P5/{$filename}">
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
 
        <xsl:template match="*[child::seg]">
            <xsl:variable name="containerElem" as="element()" select="."/>
          <xsl:element name="{name()}">
              <xsl:copy-of select="@*"/>
              <xsl:for-each select="child::node()">
                  <xsl:choose>
                      <!--Test 2: nodes in between the instantly raisable segs -->
                      <xsl:when test="self::node()[not(self::seg)][preceding-sibling::seg[1][contains(@xml:id, '_start')][substring-before(@xml:id, '_start') eq following-sibling::seg[1]/substring-before(@xml:id, '_end')]]">
                          <!--ebb: Do nothing! These nodes are processed in a later template rule. -->
                      </xsl:when>
                      <!-- Process nodes that are inside broken hotspots, before an end-marker seg. Start with very first-child nodes that are not seg elements. -->
                      <xsl:when test="node()[not(self::seg) and following-sibling::seg[1][contains(@xml:id, '_end')] and not(preceding-sibling::seg[1][contains(@xml:id, '_start')])]">
                   <xsl:variable name="markerID" select="following-sibling::seg[1][contains(@xml:id, '_end')]/substring-before(@xml:id, '_end')"/>
                          <seg xml:id="{$markerID}__Pt2" part="F">
                    <xsl:copy-of select="current()"/>
                              <xsl:copy-of select="following-sibling::node()[following-sibling::seg[1][substring-before(@xml:id, '_end') eq $markerID ]]"/> 
                          </seg>
  
                      </xsl:when>
                    
                     <xsl:otherwise>
                         <xsl:apply-templates/>
                     </xsl:otherwise> 
                  </xsl:choose>
              </xsl:for-each>
          </xsl:element>
    </xsl:template>
    <xsl:template match="seg[contains(@xml:id, '_start')]">
        <xsl:variable name="currentIDFlag" as="xs:string" select="@xml:id"/>
        <xsl:variable name="currentID" as="xs:string" select="substring-before($currentIDFlag, '_start')"/>
        <xsl:choose>
            <xsl:when test="following-sibling::seg[1][contains(@xml:id, '_end') and substring-before(@xml:id, '_end') = $currentID]">
                <seg xml:id="{$currentID}">
                    <xsl:copy-of select="following-sibling::node()[following-sibling::seg[substring-before(@xml:id, '_end') = $currentID]]"/>  
                </seg>
            </xsl:when>
            <xsl:otherwise>
                <seg xml:id="{$currentID}__Pt1" part="I">
                    <xsl:copy-of select="following-sibling::node()"/>
                </seg>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="seg[contains(@xml:id, '_end')]">
      <!--Suppress these nodes. -->
    </xsl:template>

</xsl:stylesheet>


