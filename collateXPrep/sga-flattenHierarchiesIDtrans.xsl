<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://mith.umd.edu/sc/ns1#"
    xmlns:mith="http://mith.umd.edu/sc/ns1#"    
    exclude-result-prefixes="xs #default"
    version="3.0">
   
    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="surface">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@xml:id"/><xsl:text>__Start</xsl:text>
            </xsl:attribute>    
        </xsl:copy>    
     <xsl:apply-templates/>   
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@xml:id"/><xsl:text>__End</xsl:text>
            </xsl:attribute>    
        </xsl:copy>   
    </xsl:template>
    <xsl:template match="zone">
      <xsl:variable name="locFlag">
          <xsl:value-of select="substring-after(ancestor::surface/@xml:id, 'abinger_')"/><xsl:text>__</xsl:text><xsl:value-of select="@type"/> 
      </xsl:variable>  
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="loc">
 <xsl:value-of select="$locFlag"/>            <xsl:text>__Start</xsl:text>
            </xsl:attribute>     
        </xsl:copy>
        
        <xsl:apply-templates/>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="loc">
                <xsl:value-of select="$locFlag"/>            <xsl:text>__End</xsl:text>
            </xsl:attribute>    
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mod | add | del">
        <xsl:variable name="locFlag">
            <xsl:value-of select="substring-after(ancestor::surface/@xml:id, 'abinger_')"/><xsl:text>__</xsl:text><xsl:value-of select="ancestor::zone[1]/@type"/><xsl:text>__</xsl:text><xsl:value-of select="generate-id(.)"/> 
        </xsl:variable>  
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="loc">
                <xsl:value-of select="$locFlag"/>            <xsl:text>__Start</xsl:text>
            </xsl:attribute>     
        </xsl:copy>
        
        <xsl:apply-templates/>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="loc">
                <xsl:value-of select="$locFlag"/>            <xsl:text>__End</xsl:text>
            </xsl:attribute>    
        </xsl:copy>
    </xsl:template>
    
    <!--2018-05-09 ebb: I wanted to suppress output namespaces that are propagating on these elements: -->
<!--  <xsl:template match="lb">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="n"><xsl:value-of select="@n"/></xsl:attribute> 
        </xsl:copy>
    </xsl:template>
    <xsl:template match="w">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="ana"><xsl:value-of select="@ana"/></xsl:attribute> 
        </xsl:copy>
    </xsl:template>
    <xsl:template match="anchor">
        <xsl:copy copy-namespaces="no">
            
        </xsl:copy>
    </xsl:template>-->
  
</xsl:stylesheet>