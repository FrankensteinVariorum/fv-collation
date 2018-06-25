<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="Output1-P4-C10" as="document-node()+" select="collection('bridge-P4-C10/output1')"/>
     
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files . In this second stage, we're removing duplicate material following the previous collation. In the process of up-converting flattened elements, their contents were reproduced as following-sibling nodes. Where the following-sibling nodes are equal to those inside the reconstructed elements, we need to remove them. -->    
   <xsl:template match="/">
       <xsl:for-each select="$Output1-P4-C10//TEI">
           <xsl:variable name="currentP4File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>output2-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'output1-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/> 
         
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/output2/{$filename}">
        <TEI><xsl:apply-templates select="descendant::teiHeader"/>
        <text>
            <body>
                <xsl:apply-templates select="descendant::div[@type='collation']">
                   
                </xsl:apply-templates>
            </body>
        </text>
        </TEI>
         </xsl:result-document>
       </xsl:for-each>
       
   </xsl:template>
    <xsl:template match="div[@type='collation']//p//node()[. = preceding-sibling::*//node()]">
    </xsl:template>
    <!--ebb: attempting to suppress duplicated nodes from up-conversion. -->
</xsl:stylesheet>


