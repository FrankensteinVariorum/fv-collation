<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-07-09 updated 2018-07-21 ebb: 
        We were namespacing new elements but have determined that namespaces are a bad idea for the collation process (every element is output in its original namespaces, and we were making three of them). We were preparing pitt:mdel elements, but these are now just mdel elements. And pitt:hi will become just shi elements. We'll need to apply namespaces to the output. 
        
     2018-07-09:   This stylesheet prepares sga files for their pre-collation state: It changes line elements into self-closed <lb/> elements and removes elements unnecessary for the collation. It also marks <del> elements inside <mod> that contain two characters or less and gives them a special pitt:mdel element so that they may be screened from the collation process (but still output because we need them), while their counterpart del elements are preserved for full comparison. It also recodes the `<hi>` elements as `<pitt:hi>` so that these may be treated specially in the collation process.
        Run it on the msCollPrep_c??_PreCollate.xml files in the sga-Notebooks directory (prepared without namespaces and with simple xml root elements), and output becomes the msColl files in the directory above (collateXPrep). Apply carefully to the right files: some sga Notebook files are fragments of c57 and c58: be sure to find the right ones to transform and name appropriately on the other side.
    Following this stage of preparation, the msColl files will be "chunked" into collation units and filed in their respective folders. Again, this is a complicated process because of the fragmented state of the notebooks. Collation with collateX requires that the files present from each witness to be compared in a given directory be equal in number.-->
<xsl:mode on-no-match="shallow-copy"/> 
   <xsl:strip-space elements="surface zone"/><!-- ebb: 
        This effectively removes spaces in between w elements marking words broken around line-breaks. -->  
<!--INEFFECTIVE: <xsl:template match="text()[preceding-sibling::w[@ana='start'][1]]">
    <xsl:value-of select="replace(., '\s+', '')[1]"/>
</xsl:template>-->

    <xsl:variable name="PreCollate" as="document-node()+" select="collection('PreCollate')"/>
    <xsl:template match="/">
        <xsl:for-each select="$PreCollate//xml">
            <xsl:variable name="currFile" as="xs:string">
        <xsl:value-of select="concat('msColl', tokenize(base-uri(.), '/')[last()] ! substring-before(., '_PreCollate.xml') ! substring-after(., 'msCollPrep'))"/>
            </xsl:variable> 
            <xsl:result-document method="xml" indent="yes" href="../msColl-full/{$currFile}.xml">
                <xml>
                  <!--  <xsl:namespace name="pitt" select="'https://github.com/ebeshero/Pittsburgh_Frankenstein'"/> 
                    <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
<xsl:namespace name="mith" select="'http://mith.umd.edu/sc/ns1#'"/>
                    <xsl:namespace name="th" select="'http://www.blackmesatech.com/2017/nss/trojan-horse'"/>-->
                           
                    <xsl:apply-templates/>
                </xml>
            </xsl:result-document> 
        </xsl:for-each>
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
        <mdel><xsl:apply-templates/></mdel>
    </xsl:template>
 <!--2018-07-21 ebb: This template rule below converts the S-GA <hi> elements into <pitt:hi> so that they may be treated differently in the collation process, since these will remain inline-content elements, while <hi> elements have been flattened (and are much simpler) in the source XML files representing the published editions. -->   
    <xsl:template match="hi">
        <xsl:element name="shi">
            <xsl:copy-of select="@*"/>        
                <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
 <!--ebb: Removing elements irrelevant to collation. -->
  <xsl:template match="space"/>
  
  <xsl:template match="listTranspose"/>
    
</xsl:stylesheet>