<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="app[rdgGrp/@n='['''']'][count(rdgGrp) eq 1][descendant::rdg[@wit='fMS']]"/>
    
    <xsl:template match="rdg[@wit='fMS'][ancestor::app[not(rdgGrp/@n='['''']')][preceding-sibling::app[rdgGrp/@n='['''']'][descendant::rdg[@wit='fMS']][count(rdgGrp) eq 1]]]">
        
       <rdg wit="fMS"> 
           <xsl:value-of select="ancestor::app/preceding-sibling::app[rdgGrp/@n='['''']'][count(rdgGrp) eq 1][descendant::rdg[@wit='fMS']][1]//rdg[@wit='fMS']"/>  
       <xsl:apply-templates/> 
       </rdg>
    </xsl:template>   

</xsl:stylesheet>