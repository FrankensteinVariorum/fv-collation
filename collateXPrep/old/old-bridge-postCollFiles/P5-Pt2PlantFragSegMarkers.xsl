<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
xmlns:mith="http://mith.umd.edu/sc/ns1#"  xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P5-BridgeColl" as="document-node()+" select="collection('bridge-P5A')"/> 
<!--2018-07-29: Bridge Construction Phase 5: What we need to do:      
       *  where the end markers of seg elements are marked we reconstruct them in pieces. 
        * raise the <seg> marker elements marking hotspots
       *  deliver seg identifying locations to the Spinal Column file.
    In this first stage of Part 5, we are converting the seg elements into Trojan markers using the th:namespace, and explicitly designating those that are fragments (that will break hierarchy if raised) as parts by adding a part attribute. This should help to ease the handling of these in the next stage as we adapt CMSpMq's left-to-right sibling traversal for raising flattened elements.  
    -->    
   <xsl:template match="/">
       <xsl:for-each select="$P5-BridgeColl//TEI">
           <xsl:variable name="currentP5File" as="element()" select="current()"/>
           <xsl:variable name="filename" as="xs:string" select="tokenize(base-uri(), '/')[last()]"/>
         <xsl:variable name="chunk" as="xs:string" select="tokenize(base-uri(), '/')[last()] ! substring-before(., '.') ! substring-after(., '_')"/> 

           <xsl:result-document method="xml" indent="yes" href="bridge-P5B/{$filename}">
               <TEI xmlns="http://www.tei-c.org/ns/1.0"                 xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein" xmlns:mith="http://mith.umd.edu/sc/ns1#"  xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse">
         <xsl:copy-of select="descendant::teiHeader" copy-namespaces="no"/>
        <text>
            <body>
                <xsl:apply-templates select="descendant::div[@type='collation']"/>
            </body>
        </text>
        </TEI>
         </xsl:result-document>
       </xsl:for-each>      
   </xsl:template>
 
      <xsl:template match="*[child::seg[@part]]">
          <xsl:element name="{name()}">
              <xsl:copy-of select="@*"/>
          <xsl:if test="child::seg[1][@part and @th:eID]">
              <seg th:sID="{child::seg[1][@part and @th:eID]/@th:eID}" part="{child::seg[1][@part and @th:eID]/@part}"/>
          </xsl:if>
          <xsl:apply-templates/>
              <xsl:if test="child::seg[last()][@part and @th:sID]">
                  <seg th:eID="{child::seg[last()][@part and @th:sID]/@th:sID}" part="{child::seg[last()][@part and @th:sID]/@part}"/>
              </xsl:if>
          </xsl:element>
      </xsl:template>
</xsl:stylesheet>


