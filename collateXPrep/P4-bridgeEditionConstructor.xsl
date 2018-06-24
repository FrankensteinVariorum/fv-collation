<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P3-BridgeColl" as="document-node()+" select="collection('bridge-P3')"/>
    <xsl:variable name="testerDoc" as="document-node()" select="doc('bridge-P3/P3-f1818_C10.xml')"/>
<!--In Bridge Construction Phase 4, we are converting self-closed edition elements into full elements to "unflatten" the edition files . -->    
   <xsl:template match="/">
       <!--<xsl:for-each select="$P3-BridgeColl//TEI">
           <xsl:variable name="currentP3File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>P4-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P3-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
           <xsl:result-document method="xml" indent="yes" href="bridge-P4/{$filename}">-->
          <TEI> <xsl:apply-templates/></TEI>
          <!-- </xsl:result-document>
       </xsl:for-each>-->
       
   </xsl:template>
    <xsl:template match="titleStmt/title">
        <title>
            <xsl:text>Bridge Phase 4: </xsl:text><xsl:value-of select="tokenize(., ':')[last()]"/>
        </title>
    </xsl:template>
   <xsl:template match="div[type='collation']">
       <div type="collation" xml:id="{@xml:id}">
           <xsl:variable name="editionFullElements" as="element()+" select="descendant::*[not(self::seg) and matches(@ana, '[Ss]tart')][following-sibling::*[name() = ./name() and matches(@ana, '[Ee]nd')]]"/>
          <xsl:for-each select="$editionFullElements">
              <xsl:variable name="currentElem" select="current()" as="element()"/>
              <xsl:variable name="elemName" select="$currentElem/name()" as="xs:string"/>
              <xsl:variable name="atts" select="$currentElem/@*" as="attribute()*"/>
              <xsl:for-each-group select="$currentElem/following-sibling::*[name() = current()/name() and matches(@ana, '[Ee]nd')][1]" group-starting-with="$currentElem">
                  <xsl:element name="{$elemName}">
                      <xsl:for-each select="$atts[not(name() = 'ana')]">
                       <xsl:attribute name="{current()/name()}">
                           <xsl:value-of select="current()"/>
                       </xsl:attribute>
                      </xsl:for-each>
                      <xsl:apply-templates select="current-group()"/> 
                      
                  </xsl:element>
               
           </xsl:for-each-group>
          </xsl:for-each>
       </div>
   </xsl:template>
   
  
</xsl:stylesheet>


