<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">  
    <xsl:output method="text"/>
    
    <xsl:variable name="MS_collFlagged" select="collection('../collateXPrep/c56_FlagcollationChunks')"/>
   
 <!--2017-11-27 ebb: This XSLT outputs everything marked in Percy's hand.--> 

    <xsl:variable name="witnesses" select="distinct-values(//app/rdg/tokenize(@wit, ' '))"/>
    
<xsl:template match="/">
    <xsl:text>Mary Wollstonecraft Shelley's Hand &#10;</xsl:text>
    <xsl:apply-templates select="$MS_collFlagged/descendant::*[not(@hand='#pbs') and not(ancestor::*[@hand='#pbs'])][contains(base-uri(), 'msColl')]"/> 
</xsl:template>
    
    <xsl:template match="*[not(@hand='#pbs') and not(ancestor::*[@hand='#pbs'])]">
   <xsl:choose>
       <xsl:when test="child::*[child::text()]">
           <xsl:apply-templates/>
       </xsl:when>
       <xsl:otherwise> <xsl:text>[</xsl:text><xsl:value-of select="name()"/><xsl:text>]&#x9;</xsl:text>
    <xsl:apply-templates/><xsl:text>&#10;</xsl:text></xsl:otherwise></xsl:choose>
</xsl:template>
    
    <xsl:template match="*[child::text()]">
        <xsl:text>[</xsl:text><xsl:value-of select="name()"/><xsl:text>]&#x9;</xsl:text>
        <xsl:apply-templates/><xsl:text>&#10;</xsl:text>
    </xsl:template>

</xsl:stylesheet>