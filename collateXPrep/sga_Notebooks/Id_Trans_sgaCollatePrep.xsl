<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    exclude-result-prefixes="xs pitt"
    version="3.0">
<!--2018-07-09 ebb: This stylesheet prepares sga files for their pre-collation state: It changes line elements into self-closed <lb/> elements and removes elements unnecessary for the collation. It also marks <del> elements inside <mod> that contain two characters or less and gives them a special pitt:mdel element so that they may be screened from the collation process (but still output because we need them), while their counterpart del elements are preserved for full comparison. Run it on the msCollPrep_c??_PreCollate.xml files in the sga-Notebooks directory (prepared without namespaces and with simple xml root elements), and output becomes the msColl files in the directory above (collateXPrep). Apply carefully to the right files: some sga Notebook files are fragments of c57 and c58: be sure to find the right ones to transform and name appropriately on the other side.
    Following this stage of preparation, the msColl files will be "chunked" into collation units and filed in their respective folders. Again, this is a complicated process because of the fragmented state of the notebooks. Collation with collateX requires that the files present from each witness to be compared in a given directory be equal in number.-->
<xsl:mode on-no-match="shallow-copy"/> 
   <xsl:strip-space elements="surface zone"/><!-- ebb: 
        This effectively removes spaces in between w elements marking words broken around line-breaks. -->  
<!--INEFFECTIVE: <xsl:template match="text()[preceding-sibling::w[@ana='start'][1]]">
    <xsl:value-of select="replace(., '\s+', '')[1]"/>
</xsl:template>-->


<xsl:template match="xml">
    <xsl:element name="{local-name()}">
        <xsl:namespace name="pitt" select="'https://github.com/ebeshero/Pittsburgh_Frankenstein'"/>
        <xsl:apply-templates/>
    </xsl:element>
 </xsl:template>  
    
    <!--2017-10-24 ebb: Remove zone[@type="pagination"] and zone[@type="library"] -->
<xsl:template match="zone[@type='pagination'] | zone[@type='library']"/> 

<!--ebb: Remove XML comments. -->  
 <xsl:template match="comment()"/>
    
<!--ebb: flatten line to lb as "line-beginning" and control white spaces around words broken at ends of lines. -->
    <xsl:template match="line">
       <xsl:choose> <xsl:when test="preceding-sibling::line[1][w[@ana='start']]"><lb/><xsl:apply-templates/></xsl:when>
    <xsl:otherwise>
        <xsl:text> </xsl:text><lb/><xsl:apply-templates/>
    </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
    
<!--2018-07-09 ebb: Following trouble with setting Xpointers back to SGA, rv and I agree that it's better to keep these short del elements, but mark them clearly so they can be screen from collation. I'm reprocessing this rule now so that it preserves these dels under a new element named "pitt:mdel" so that it can easily be masked from collation in the python script for collateX.  This distinguishes it from the regular del element that we want to keep in the collation.--><!--OLD APPROACH: ebb: To reduce collation "noise" from miniscule del/adds, look inside mod elements and remove del elements of 2 characters or less. -->
<!--<xsl:template match="mod//del[string-length() le 2]"/>
-->
    <xsl:template match="mod//del[string-length(.) le 2]">
        <pitt:mdel><xsl:apply-templates/></pitt:mdel>
    </xsl:template>
    
    
 <!--ebb: Removing elements irrelevant to collation. -->
  <xsl:template match="space"/>
  
  <xsl:template match="listTranspose"/>
    
</xsl:stylesheet>