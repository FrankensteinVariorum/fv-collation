<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
version="3.0">
   <!--2016-12-22 ebb: Prepared for batch transforms with saxonHE -->
    <!--<xsl:strip-space elements="*"/>-->
    
    <xsl:output method="text" encoding="UTF-8"/>
 <!--<xsl:variable name="paEdition" select="collection('../frankenTexts_HTML/PA_Electronic_Ed/1818_ed')"/>   --> 
    
   <xsl:template match="head">
   </xsl:template>
    
   <xsl:template match="body">
       <xsl:apply-templates select="descendant::text()"/>
        
    </xsl:template>  
    
</xsl:stylesheet>