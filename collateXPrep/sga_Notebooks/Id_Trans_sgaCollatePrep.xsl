<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
 
<xsl:mode on-no-match="shallow-copy"/> 
   <xsl:strip-space elements="surface zone"/><!-- ebb: 
        This effectively removes spaces in between w elements marking words broken around line-breaks. -->  
<!--INEFFECTIVE: <xsl:template match="text()[preceding-sibling::w[@ana='start'][1]]">
    <xsl:value-of select="replace(., '\s+', '')[1]"/>
</xsl:template>-->

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
    
<!--ebb: To reduce collation "noise" from miniscule del/adds, look inside mod elements and remove del elements of 2 characters or less. -->
<xsl:template match="mod//del[string-length() le 2]"/>
    
<!--ebb: CONSIDER removing any del elements of 2 characters or less regardless of location.-->
 
 <!--ebb: Removing elements irrelevant to collation. -->
  <xsl:template match="space"/>
  
  <xsl:template match="listTranspose"/>
    
</xsl:stylesheet>