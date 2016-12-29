<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
version="3.0">

   <!--2016-12-28 ebb: Prepared to process from a collection organized unambiguously by filename and output a single file. Filenames were prefaced by a number to process in sequential order.-->  
  <xsl:strip-space elements="*"/>
    <xsl:output method="text" encoding="UTF-8"/>

   <!--ebb: Uncomment one of the following lines to process the appropriate edition, either 1818 or 1831.--> 
  <!-- <xsl:variable name="paEdition" select="collection('../frankenTexts_HTML/PA_Electronic_Ed/1818_ed')"/> -->
   
<xsl:variable name="paEdition" select="collection('../frankenTexts_HTML/PA_Electronic_Ed/1831_ed')"/>
   
   <xsl:template match="/">
     
      <xsl:text>Number of distinct links coded in this PA Electronic Edition: </xsl:text><xsl:value-of select="count(distinct-values($paEdition//body//a/@href))"/>
      <xsl:apply-templates select="$paEdition//body"/>
   </xsl:template>
   
<xsl:template match="br">
   <xsl:text>
      
   </xsl:text>
</xsl:template>
   <xsl:template match="p">
      <xsl:apply-templates/><xsl:text>
         
      </xsl:text>
</xsl:template> 
  <!-- <xsl:template match="text()">
      <xsl:apply-templates select="normalize-space(.)"/>
     2016-12-28 ebb: normalize-space() causes problems: too much tightening up of the output so words are run together, also when applied at <p> template, child nodes aren't processed. 
  Using regex and Text-Wrangler on the output file to remove its excess lines.
   </xsl:template>-->
   
<xsl:template match="i">
   <xsl:text>_</xsl:text><xsl:apply-templates/><xsl:text>_</xsl:text>
</xsl:template> 

   <xsl:template match="small">
      <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
   </xsl:template> 
       
</xsl:stylesheet>