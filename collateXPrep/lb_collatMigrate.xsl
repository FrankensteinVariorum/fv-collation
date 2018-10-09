<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="collationFiles" as="document-node()+" select="collection('Full_Part8_xmlOutput/')"/>
    <xsl:template match="/">
        <xsl:for-each select="$collationFiles">
            <xsl:variable name="filePath" as="xs:string" select="tokenize(base-uri(.), '\.xml')[1]"/>
            <xsl:result-document href="{$filePath}_new.xml" method="xml" indent="yes">
                <xsl:processing-instruction name="xml-model">href="../collationOutputTester.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
                <xsl:apply-templates/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="app[rdgGrp/@n='['''']'][count(rdgGrp) eq 1][descendant::rdg[@wit='fMS']]"/>
    <xsl:template match="rdg[@wit='fMS'][ancestor::app[not(rdgGrp/@n='['''']')][preceding-sibling::app[rdgGrp/@n='['''']'][descendant::rdg[@wit='fMS']][count(rdgGrp) eq 1]]]">
        
       <rdg wit="fMS"> 
           <xsl:value-of select="ancestor::app/preceding-sibling::app[rdgGrp/@n='['''']'][count(rdgGrp) eq 1][descendant::rdg[@wit='fMS']][1]//rdg[@wit='fMS']"/>  
       <xsl:apply-templates/> 
       </rdg>
    </xsl:template>   

</xsl:stylesheet>