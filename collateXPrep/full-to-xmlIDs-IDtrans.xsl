<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs"
    version="3.0">
<!--2019-11-02 ebb: This is meant to assist migration of hypothes.is annotations originally made on HTML versions of pre-collation files, to determine their locations in the constructed Variorum edition. -->
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="printColl" as="document-node()+" select="collection('print-full')[tokenize(base-uri(), '/')[last()] ! contains(., 'C')]"/>
    <xsl:template match="/">
        <xsl:for-each select="$printColl//xml">
            <xsl:variable name="currFile" as="xs:string">
                <xsl:value-of select="concat(tokenize(base-uri(.), '/')[last()] ! substring-before(., 'C'), '.xml')"/>
            </xsl:variable> 
            <xsl:result-document method="xml" indent="yes" href="../../fv-data/hypothesis/migration/xml-ids/{$currFile}">
                <TEI>
                    <xsl:comment>ebb: for standoff inclusion, add XInclude namespace to root element: xmlns:xi='http://www.w3.org/2001/XInclude', and apply
                        xi: namespace prefix to include elements in the document.</xsl:comment>
                    <teiHeader>
                        <fileDesc>
                        <titleStmt>
                            <title>Uncollated TEI: <xsl:value-of select="descendant::header/include ! substring-after(@href, '../standOff_Includes/') ! substring-before(., '_')"/> edition</title>
                        </titleStmt>
                        <publicationStmt>
                            <authority>Frankenstein Variorum Project</authority>
                            <date><xsl:value-of select="current-dateTime()"/></date>
                            <availability>
                                <licence>Distributed under a Creative Commons
                                    Attribution-ShareAlike 3.0 Unported License</licence>
                            </availability>
                        </publicationStmt>
                            <sourceDesc><p>The source is an XML file of one complete print edition of Frankenstein prior to flattening all elements for collation. The source document is not in any namespace. Where div elements would be expected in a TEI document to structure the full edition, these are represented by milestone markers signalling the beginning and end of a text division.</p>
</sourceDesc>
                    </fileDesc>
                        <encodingDesc><p>This TEI was produced to assist migration of hypothes.is annotations made on distinct HTML editions prior to collation. The document contains TEI elements representing the basic structure of each edition file as they appear in the Variorum edition, but lacking the markup of variorum "hotspots" indicating loci of variance with other editions. Currently this TEI document is not valid against the TEI All schema because div elements are absent, having been flattened to milestone start and end markers. Also, there are include elements present that are not active because they are not in the xi:include namespace. To activate them, apply the xi: namespace prefix to include elements in the document, and (in the oXygen XML Editor) run canonicalize to resolve them. The include elements are currently here as placeholders representing more material present in each edition (such as title pages and backmatter) that was not part of the collation process.</p></encodingDesc>
                    
                    </teiHeader>
                   <xsl:apply-templates select="descendant::text"/>
                </TEI>
            </xsl:result-document> 
        </xsl:for-each>
    </xsl:template>
    
    <!--ebb: Suppress comment elements -->
    <xsl:template match="comment"/>
    
    <xsl:template match="text">
        <text xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </text>
    </xsl:template>
<xsl:template match="include">
    <include href="https://raw.githubusercontent.com/FrankensteinVariorum/fv-collation/master/collateXPrep/{substring-after(@href, '../')}" parse="xml"/> 
</xsl:template>
    <xsl:template match="text//*[not(self::div)][not(self::comment)][not(self::include)]">
        <xsl:variable name="nodeName" as="xs:string" select="name()"/>
        <xsl:variable name="locationFlag">
            <xsl:for-each select="ancestor::div">
                <xsl:value-of select="@type"/>
                <xsl:value-of select="count(current()/preceding-sibling::div[@type=current()/@type]) + 1"/>
                <xsl:text>_</xsl:text>
            </xsl:for-each>
        <!--    <xsl:if test="ancestor::*[not(self::div)]/ancestor::div[1]">-->
                <xsl:for-each select="ancestor::*[ancestor::div[1]]">
                    <xsl:variable name="ancNodeName" as="xs:string" select="name()"/>
                    <xsl:value-of select="$ancNodeName"/>
                    <xsl:value-of select="count(preceding-sibling::*[name() = $ancNodeName]) + 1"/>
                    <xsl:text>_</xsl:text>
                </xsl:for-each>
            <!--</xsl:if>-->
            <xsl:value-of select="$nodeName"/>
            <xsl:value-of select="count(preceding-sibling::*[name() = $nodeName]) + 1"/>
        </xsl:variable>
        <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
           <xsl:if test="not(@xml:id)"> <xsl:attribute name="xml:id">
                <xsl:value-of select="$locationFlag"/>
            </xsl:attribute></xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
      
            
        
    </xsl:template>
    
    <xsl:template match="div">
        <milestone unit="{@type}" type="start">
            <xsl:choose><xsl:when test="@n">
                <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute></xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="n">
                    <xsl:value-of select="count(preceding::div[@type=current()/@type]) + 1"/>
                </xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            </milestone>
            <xsl:apply-templates/>
        <milestone unit="{@type}" type="end">
            <xsl:choose><xsl:when test="@n">
                <xsl:attribute name="n">
                    <xsl:value-of select="@n"/>
                </xsl:attribute></xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="n">
                        <xsl:value-of select="count(preceding::div[@type=current()/@type]) + 1"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            </milestone>
    </xsl:template>
    
</xsl:stylesheet>