<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cx="http://interedition.eu/collatex/ns/1.0"
    
    exclude-result-prefixes="xs math"
    version="3.0">
    <!--2021-09-24 ebb with wdjacca and amoebabyte: We are writing XSLT to try to move
    solitary apps reliably into their neighboring app elements representing all witnesses. 
    
    -->
  <xsl:mode on-no-match="shallow-copy"/>
  
<!-- ********************************************************************************************
        LONER DELS: These templates deal with collateX output of app elements 
        containing a solitary MS witness containing a deletion, which we interpret as usually a false start, 
        before a passage.
     *********************************************************************************************
    -->  
    <xsl:template match="app[count(descendant::rdg) = 1][contains(descendant::rdg, '&lt;del')]">
  
        <xsl:if test="following-sibling::app[1][count(descendant::rdgGrp) = 1 and count(descendant::rdg) gt 1]">
               <xsl:apply-templates select="following-sibling::app[1]" mode="restructure">
                  <xsl:with-param as="node()" name="loner" select="descendant::rdg" tunnel="yes" />
                   <xsl:with-param as="attribute()" name="norm" select="rdgGrp/@n" tunnel="yes"/>
               </xsl:apply-templates>
               
           </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="app[preceding-sibling::app[1][count(descendant::rdg) = 1][contains(descendant::rdg, '&lt;del')]]"/>


    <xsl:template match="app" mode="restructure">
        <xsl:param name="loner" tunnel="yes"/>
        <xsl:param name="norm" tunnel="yes"/>
        <app>
        <xsl:apply-templates select="rdgGrp" mode="restructure">
                <xsl:with-param  as="node()" name="loner" tunnel="yes" select="$loner"/>
            </xsl:apply-templates>
            <xsl:variable name="TokenSquished">
                <xsl:value-of select="$norm ! string()||descendant::rdgGrp[descendant::rdg[@wit=$loner/@wit]]/@n"/>
            </xsl:variable>
            <xsl:variable name="newToken">
                <xsl:value-of select="replace($TokenSquished, '\]\[', ', ')"/>
            </xsl:variable>
           <rdgGrp n="{$newToken}">
              <rdg wit="{$loner/@wit}"><xsl:value-of select="$loner/text()"/>
              <xsl:value-of select="descendant::rdg[@wit = $loner/@wit]"/>
              </rdg>
               
           </rdgGrp> 
        </app> 
    </xsl:template>
    
    <xsl:template match="rdgGrp" mode="restructure">
        <xsl:param name="loner" tunnel="yes"/>

           <xsl:if test="rdg[@wit ne $loner/@wit]">
            <xsl:copy-of select="current()" />
        </xsl:if>
    </xsl:template>
   
    
    
</xsl:stylesheet>