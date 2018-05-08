<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <!--2018-05-08 ebb: This XSLT is meant to be the first stage in preparing the Thomas copy for collation according to the new paragraph-flattened and signal-flagged protocol. -->
    <xsl:variable name="OldThomas" select="collection('ThomasCopy_orig')"/>
    <xsl:variable name="Old1818" select="collection('1818chunks_orig')"/>
    <xsl:template match="/">
        <xml>
        <xsl:for-each select="$OldThomas//xml">
        
         <xsl:choose>    
          <xsl:when test="not(descendant::*)">
              <xsl:variable name="match1818file" select="$Old1818//xml[substring-after(tokenize(base-uri(), '/')[last()], 'fullFlat_') = current()/substring-after(tokenize(base-uri(), '/')[last()], 'fullFlat_')]"/> 
              <xsl:apply-templates select="$match1818file"/>
          </xsl:when>  
             <xsl:otherwise>
              <xsl:apply-templates/>
             </xsl:otherwise>
         
         </xsl:choose>  
                 
            
        </xsl:for-each>
        </xml>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
 
</xsl:stylesheet>