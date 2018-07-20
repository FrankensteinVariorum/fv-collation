<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mith="http://mith.umd.edu/sc/ns1#"
    xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"    
    exclude-result-prefixes="xs mith pitt"
    version="3.0">
    <!--2018-07-10 ebb: Run this second in the process of flattening the SGA files. Run it over the msColl_fullFlat files after you've planted the sgaMSLocator @n flags on the lb elements.-->
    <!--2018-07-20 ebb: This stylesheet now sets "trojan-horse" style start and end markers with @th:sID and @th:eID on the elements as they are being flattened. (We used to use xml:ids with flags planted at the ends of the attribute values, but this is not optimal.) On up-conversion, we can convert the trojan-horse marker elements back into xml:ids again. -->
   <xsl:output method="xml" indent="no"/>
    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
   <xsl:template match="pitt:mdel">
       <xsl:element name="{local-name()}">
           <xsl:apply-templates/>
       </xsl:element>
    </xsl:template>

    <xsl:template match="surface">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:sID">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>    
        </xsl:copy>    
     <xsl:apply-templates/>   
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:eID">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>    
        </xsl:copy>   
    </xsl:template>
    <xsl:template match="zone">
      <xsl:variable name="locFlag">
          <xsl:value-of select="substring-after(ancestor::surface/@xml:id, 'abinger_')"/><xsl:text>__</xsl:text><xsl:value-of select="@type"/> 
      </xsl:variable>  
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:sID">
 <xsl:value-of select="$locFlag"/>
            </xsl:attribute>     
        </xsl:copy>
        
        <xsl:apply-templates/>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:eID">
                <xsl:value-of select="$locFlag"/>
            </xsl:attribute>    
        </xsl:copy>
    </xsl:template>
    <xsl:template match="mod | add | del">
        <xsl:variable name="locFlag">
            <xsl:value-of select="substring-after(ancestor::surface/@xml:id, 'abinger_')"/><xsl:text>__</xsl:text><xsl:value-of select="ancestor::zone[1]/@type"/><xsl:text>__</xsl:text><xsl:value-of select="generate-id(.)"/> 
        </xsl:variable>  
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:sID">
                <xsl:value-of select="$locFlag"/>
            </xsl:attribute>     
        </xsl:copy>
        
        <xsl:apply-templates/>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="th:eID">
                <xsl:value-of select="$locFlag"/>
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