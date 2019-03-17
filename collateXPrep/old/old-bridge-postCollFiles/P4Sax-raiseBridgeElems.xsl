<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="no"/>
   <!--ebb: This version of the stylesheet is designed to run at command line (so references to specific file collections are commented out). Run this in the terminal or command line by navigating to the directory holding this XSLT (and the saxon files necessary) and entering
       java -jar saxon9ee.jar -s:bridge-P3b -xsl:P4Sax-raiseBridgeElems.xsl -o:bridge-P4
       
       <xsl:variable name="bridge-P3b" as="document-node()+" select="collection('bridge-P3b/')"/>-->
    
    <!--2018-07-15 ebb: Bridge Phase 4 raises the hierarchy of elements from the source documents, leaving the seg elements unraised. This stylesheet uses an "inside-out" function to raise the elements from the deepest levels (those with only text nodes between their start and end markers) first. This and other methods to "raise" flattened or "Trojan" elements are documented in https://github.com/djbpitt/raising with thanks to David J. Birnbaum and Michael Sperberg-McQueen for their helpful experiments. 
        Input is bridge-P3b. Output is bridge-P4. -->
 <xsl:template match="@* | node()" mode="#all">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:function name="th:raise">
        <xsl:param name="input" as="element()"/>
        <xsl:choose>
            <xsl:when test="exists($input//@ana)">
                <xsl:variable name="result" as="element()">
                    <div type="collation">
                        <xsl:apply-templates select="$input" mode="loop"/>                            
                    </div>
                </xsl:variable>
                <xsl:sequence select="th:raise($result)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>  
    <xsl:template match="/">
      <!-- <xsl:for-each select="$bridge-P3b//TEI">
           <xsl:variable name="currentFile" as="element()" select="current()"/>
                <xsl:variable name="filename">
                    <xsl:text>P4-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., '-')"/>
                </xsl:variable>
                <xsl:variable name="chunk" as="xs:string" select="tokenize(base-uri(), '/')[last()] ! substring-before(., '.') ! substring-after(., '_')"/>          
                -           <xsl:result-document method="xml" indent="yes" href="bridge-P4/{$filename}">-->
                    <TEI>
                        <xsl:apply-templates select="descendant::teiHeader"/>
                        <text>
                            <body>
                                <xsl:apply-templates select="descendant::div[@type='collation']"/>
                            </body>
                        </text>
                    </TEI>
               <!-- </xsl:result-document>-->
        <!--</xsl:for-each>-->
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
        <xsl:sequence select="th:raise(.)"/>
    </xsl:template>
    <xsl:template match="div[@type='collation']" mode="loop">
        <xsl:apply-templates/>
    </xsl:template> 
    <xsl:template match="*[@ana='start' and @loc eq following-sibling::*[@ana eq 'end'][1]/@loc]">
        <xsl:variable name="currNode" select="current()" as="element()"/>
        <xsl:variable name="currLoc" select="@loc" as="xs:string"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@loc"/>
            </xsl:attribute>
            <xsl:copy-of select="following-sibling::node()[following-sibling::*[@loc = $currLoc]]"/>
        </xsl:element>
    </xsl:template>
    <!--suppressing nodes that are being reconstructed. --> 
    <xsl:template match="node()[preceding-sibling::*[@ana eq 'start'][1]/@loc eq following-sibling::*[@ana eq 'end'][1]/@loc]"/>

    <xsl:template match="*[@ana='end'][@loc = preceding-sibling::*[@ana='start'][1]/@loc]"/>
    
</xsl:stylesheet>
