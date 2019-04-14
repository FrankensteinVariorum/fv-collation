<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <html lang="en">
            <head><title>Frankenstein (<xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '_')"/>)</title>
                <link rel="stylesheet" type="text/css" href="frankenStyle_Thom.css"/>
            </head>
        <body>
    <h1><xsl:apply-templates select="//header/title"/></h1>
            <h2><xsl:apply-templates select="//edition"/></h2>
            
            <div id="editIntro"><xsl:apply-templates select="//div[@type='editIntro']"/>
            <p>The XML version of this edition is in a simplified but consistent format optimized for automated collation, and is on its way to becoming TEI. View <a href="{tokenize(base-uri(), '/')[last()]}">the source XML here on our GitHub repository</a>.</p>
            </div>
            <xsl:apply-templates select="//text"/>
            
            <p class="boilerplate"><span><strong>Maintained by: </strong> Elisa E. Beshero-Bondar
                (ebb8 at pitt.edu)   <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://licensebuttons.net/l/by-nc-sa/4.0/80x15.png" /></a><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"></a> <xsl:text>  </xsl:text><strong>Last modified:
                </strong><xsl:value-of select="format-dateTime(current-dateTime(), '[h1]:[m01] [P] on [MNn] [D] [z]')"/>.</span></p>	
            
        </body>
        </html>
    </xsl:template>
    <xsl:template match="div[@type='editIntro']">
            <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="head">
        <h3><xsl:apply-templates/></h3>
    </xsl:template>
    <xsl:template match="p | resp">
        <p><xsl:apply-templates/></p>
    </xsl:template>
   <xsl:template match="cit | lg[not(parent::cit)]">
       <xsl:choose><xsl:when test="parent::epigraph"><div class="epi_cit"><xsl:apply-templates/></div></xsl:when><xsl:otherwise><span class="cit"><xsl:apply-templates/></span></xsl:otherwise></xsl:choose>
   </xsl:template>
    <xsl:template match="l">
        <xsl:choose>
            <xsl:when test="@rend"><span class="l_{@rend}"><xsl:apply-templates/></span></xsl:when>
            <xsl:otherwise><span class="l"><xsl:apply-templates/></span></xsl:otherwise></xsl:choose>
    </xsl:template>
    <xsl:template match="list[@type='numbered']">
        <ol><xsl:apply-templates/></ol>
    </xsl:template>
    <xsl:template match="list[not(@type)]">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>
    <xsl:template match="item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="hi[@rend='italic'] | title[@level='m']">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    <xsl:template match="hi[@rend='smallcaps']">
        <span class="smallcaps"><xsl:value-of select="lower-case(.)"/></span>
    </xsl:template>
    <xsl:template match="ref">
        <a href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
    <xsl:template match="ab">
        <xsl:choose>
            <xsl:when test="@rend='center'">
                <span class="ab_center"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="ab"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
   <xsl:template match="pb[not(ancestor::add) and not(ancestor::del) and not(ancestor::note)]">
       <span class="pb" id="e{@xml:id}"><xsl:if test="@n"><xsl:value-of select="@n"/></xsl:if></span>
    </xsl:template>
    <xsl:template match="note | bibl">
       <span class="note"><xsl:apply-templates/></span> 
    </xsl:template>
    <xsl:template match="add">
        <span class="add"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="del">
        <!--2019-04-14 ebb: For the Thomas copy, we want to visually distinguish strikeouts of the 1818 print text from deletions made inside inserted marginalia. The choices below will help distinguish delStruckPrint (strikeouts of the print edition) from deletions inside handwritten edits.  -->
       <xsl:choose><xsl:when test="ancestor::add"> <span class="delMS"><xsl:apply-templates/></span></xsl:when>
       <xsl:otherwise>
           <span class="delStruckPrint"><xsl:apply-templates/></span>
       </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
</xsl:stylesheet>