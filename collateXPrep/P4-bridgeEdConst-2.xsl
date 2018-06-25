<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="output1-P4-C10" as="document-node()+" select="collection('bridge-P4-C10/output1/')"/>
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files. -->   
   <xsl:template match="/">
       <xsl:for-each select="$output1-P4-C10//TEI">
           <xsl:variable name="currentP4File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'output1-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/output2/output2-{$filename}">
        <TEI><xsl:copy-of select="$output1-P4-C10//teiHeader"/>
        <text>
            <xsl:apply-templates select="$output1-P4-C10//text"><xsl:with-param name="filename" select="$filename" as="xs:string"/></xsl:apply-templates>
        </text>
        </TEI>
         </xsl:result-document>
       </xsl:for-each>
       
   </xsl:template>
 
   <xsl:template match="*[matches(@ana, '[Ss]tart')]">
       <xsl:param name="filename"/>
      <xsl:variable name="elementName" select="current()/name()" as="xs:string"/>
          <xsl:element name="{$elementName}">
              <xsl:attribute name="loc">
                  <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elementName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elementName][matches(@ana, '[Ss]tart')][ancestor::div]) + 1"/>
              </xsl:attribute>
              <xsl:for-each select="current()/@*">
                  
                  <xsl:attribute name="{current()/name()}">
                      <xsl:value-of select="current()"/> 
                  </xsl:attribute>
              </xsl:for-each>
              <xsl:apply-templates/>
          </xsl:element>
   </xsl:template>
    <xsl:template match="*[matches(@ana, '[Ee]nd')]">
        <xsl:param name="filename"/>
        <xsl:variable name="elementName" select="current()/name()" as="xs:string"/>
        <xsl:element name="{$elementName}">
            <xsl:for-each select="current()/@*">
                <xsl:attribute name="loc">
                    <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elementName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elementName][matches(@ana, '[Ee]nd')][ancestor::div]) + 1"/>
                </xsl:attribute>
                <xsl:attribute name="{current()/name()}">
                    <xsl:value-of select="current()"/> 
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
  
</xsl:stylesheet>


