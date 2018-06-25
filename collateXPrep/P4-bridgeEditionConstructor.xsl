<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
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
           <xsl:variable name="flat-not-p" select="$currentP3File//*[@ana and @loc and not(self::p)]" as="element()+"/>
           <xsl:result-document method="xml" indent="yes" href="bridge-P4-C10/output/output-{$filename}">
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
    <xsl:template match="*[matches(@ana, '[Ss]tart')]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="current()"/>
                </xsl:attribute>   
            </xsl:for-each>
            <xsl:apply-templates select="following-sibling::node()[1]">
                <xsl:with-param name="thisEndTag" select="following-sibling::*[@loc = current()/@loc and matches(@ana, '[Ee]nd')]" as="element()" tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*[matches(@ana, '[Ee]nd')]">
        <xsl:param name="thisEndTag"/>
        <xsl:message>This end tag: <xsl:value-of select="$thisEndTag"/></xsl:message>   
    </xsl:template>


   <!-- <xsl:template match="div[@type='collation']">
        <xsl:param name="flat-not-p" tunnel="yes"/>
        <xsl:variable name="divNode" select="." as="element()"/>
        <div type="collation" xml:id="{@xml:id}">
            <xsl:variable name="editionFullElements" as="element()+" select="descendant::*[not(self::seg) and matches(@ana, '[Ss]tart')][following-sibling::*[name() = ./name() and matches(@ana, '[Ee]nd')]]"/>
            <!-\-2018-06-24 This should identify all the elements that in the original edition files should contain full text. However, it's posing problems to try to process them all together in one for-each-group. So I'm proceeding with the paragraphs first... -\->
       
                <xsl:for-each-group select="descendant::p[@ana='Start']/following-sibling::node()" group-by="@loc">
                    <xsl:variable name="groupKey" select="current-grouping-key()"/>            
  <xsl:variable name="currentElem" select="$divNode//p[@loc=$groupKey][@ana='Start']"/> 
   <p xml:id="{$groupKey}">
     <xsl:for-each select="$divNode//p[@loc=$groupKey and @ana='Start']/following-sibling::node()[following-sibling::p[@loc=$groupKey and @ana='End']]">
         
            <xsl:apply-templates select="current()"/>
     
     </xsl:for-each>
   </p>
                </xsl:for-each-group>
           
                        
        </div>
         </xsl:template>
    <xsl:template match="del">
      <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
 
            <xsl:if test="matches(@ana, '[Ss]tart')">
                <del loc="{@loc}">
                    <xsl:apply-templates select="following-sibling::node()[following-sibling::del[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
                </del>
              <!-\- <xsl:element name="{$elementName}">
                   <xsl:for-each select="@*[not(name() = 'ana')]">
                       <xsl:attribute name="{current()/name()}">
                           <xsl:value-of select="current()"/>
                       </xsl:attribute>
                   </xsl:for-each>
                   <xsl:apply-templates select="following-sibling::node()[following-sibling::*[name() = $elementName and @loc=$loc and matches(@ana, '[Ee]nd')]]"/>
               </xsl:element>-\->         
            </xsl:if>
    </xsl:template>
    <xsl:template match="cit">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <cit loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::cit[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </cit>          
        </xsl:if>
    </xsl:template>
    <xsl:template match="quote">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <quote loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::quote[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </quote>
              
        </xsl:if>
    </xsl:template>
    <xsl:template match="lg">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <lg loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::lg[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </lg>      
        </xsl:if>
    </xsl:template>
    <xsl:template match="l">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <l loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::l[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </l>  
        </xsl:if>
    </xsl:template>
    <xsl:template match="note">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <note loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::note[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </note>
        </xsl:if>
    </xsl:template>
    <xsl:template match="bibl">
        <!-\-  <xsl:variable name="elementName" select="name()"/>-\->
        <xsl:variable name="loc" select="@loc"/>
        
        <xsl:if test="matches(@ana, '[Ss]tart')">
            <bibl loc="{@loc}">
                <xsl:apply-templates select="following-sibling::node()[following-sibling::bibl[@loc=$loc and matches(@ana, '[Ee]nd')]]"/>
            </bibl>
        </xsl:if>
    </xsl:template>-->
</xsl:stylesheet>


