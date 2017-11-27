<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">  
    <xsl:output method="xml"/>

    <xsl:variable name="witnesses" select="distinct-values(//app/rdg/tokenize(@wit, ' '))"/>
    
<xsl:template match="/">
   <xml> <xsl:apply-templates select="descendant::app"/> </xml>
</xsl:template>
    
<xsl:template match="app">

      <xsl:if test="rdg[contains(@wit, '#fMSc56') and not(contains(@wit, '#f1818'))]">
          <xsl:analyze-string select="rdg[contains(@wit, '#fMSc56')]" regex="&lt;.+?&gt;">
            
              <xsl:non-matching-substring><xsl:text> </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:non-matching-substring>
          </xsl:analyze-string>
          <xsl:text> &#x9;</xsl:text>
          <xsl:apply-templates select="rdg[contains(@wit, '#fMSc56')]/following-sibling::rdg[contains(@wit, '#f1818')]"/><xsl:text>&#10;</xsl:text>
      </xsl:if>

  
</xsl:template>

</xsl:stylesheet>