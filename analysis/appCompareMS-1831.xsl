<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">  
    <xsl:output method="text"/>
    
    <xsl:variable name="MS_1818Coll" select="collection('../collateXPrep/sga_1818_FlagXMLOutput')"/>
    <xsl:variable name="MS_1823Coll" select="collection('../collateXPrep/sga_1823_FlagXMLOutput')"/>
    <xsl:variable name="MS_1831Coll" select="collection('../collateXPrep/sga_1831_FlagXMLOutput')"/> 
    <xsl:variable name="f1818_1823Coll" select="collection('../collateXPrep/f1818_1823_FlagXMLOutput')"/>  
    <xsl:variable name="f1818_1831Coll" select="collection('../collateXPrep/f1818_1831_FlagXMLOutput')"/> 
    <xsl:variable name="f1823_1831Coll" select="collection('../collateXPrep/f1823_1831_FlagXMLOutput')"/> 
 <!--2017-11-26 ebb: This XSLT can produce TSV outputs to compare each edition to each of the others one at a time. I've output simple collation files that collate the editions in pairs. This version is set to compare the MS to 1831.--> 

    <xsl:variable name="witnesses" select="distinct-values(//app/rdg/tokenize(@wit, ' '))"/>
    
<xsl:template match="/">
    <xsl:text>MS: </xsl:text><xsl:text> &#x9;</xsl:text> <xsl:text> 1831: </xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="$MS_1831Coll/descendant::app[not(@type='invariant')]"/> 
</xsl:template>
    
<xsl:template match="app[not(@type='invariant')]">
    <xsl:apply-templates select="rdg[contains(@wit, '#fMSc56') and not(contains(@wit, '#f1831'))]"/>
</xsl:template>
    <xsl:template match="rdg[contains(@wit, '#fMSc56') and not(contains(@wit, '#f1831'))]">
        <xsl:variable name="simpleTextBefore">
            <xsl:analyze-string select="." regex="^(.+?)&lt;">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)[not(matches(., '&lt;'))]"/> 
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:value-of select="$simpleTextBefore"/>

                <xsl:variable name="del">
                    <xsl:analyze-string select="." regex="(.*?)&lt;del\s.+?&gt;(.+?)&lt;/del&gt;(.*?)">                       <xsl:matching-substring>
                        <xsl:text>[DELstart] </xsl:text>
                        <xsl:value-of select="regex-group(2)"/>
                        <xsl:text>[DELend]</xsl:text>
                    </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
       
                <xsl:variable name="delTrimmed">
                    <xsl:analyze-string select="$del" regex="&lt;.+?&gt;">
                        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>             
              <xsl:value-of select="$delTrimmed"/>             

                <xsl:variable name="add">
                    <xsl:analyze-string select="." regex="(.*?)&lt;add\s.+?&gt;(.+?)&lt;/add&gt;(.*?)">                       <xsl:matching-substring>
                    <xsl:text>[ADDstart] </xsl:text>
                    <xsl:value-of select="regex-group(2)"/>
                    <xsl:text>[ADDend]</xsl:text>
                </xsl:matching-substring>
                </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="addTrimmed">
                    <xsl:analyze-string select="$add" regex="&lt;/?.+?&gt;">                   <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>             
                <xsl:value-of select="$addTrimmed"/>                   

            <xsl:variable name="otherMarkedUp">   
               <xsl:analyze-string select="." regex="(.*?)&lt;(.+?)&gt;(.*?)">
          <xsl:non-matching-substring>
              <xsl:if test="not(matches(regex-group(2), 'del ')) and not(matches(regex-group(2), 'add '))">
              <xsl:text> </xsl:text><xsl:value-of select="."/>
              </xsl:if>
          </xsl:non-matching-substring>
         </xsl:analyze-string>
 </xsl:variable>
<xsl:value-of select="$otherMarkedUp"/>
       
        
      <!--2017-11-26 ebb This variable appears to be superfluous; when it contains content, it duplicates $otherMarkedUp  <xsl:variable name="simpleTextAfter">
            <xsl:analyze-string select="." regex="&gt;(.+?)$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)[not(matches(., '&lt;'))]"/> 
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
       <xsl:if test="$simpleTextAfter != $otherMarkedUp and string-length($simpleTextAfter) gt 0"> <xsl:text>AFTER</xsl:text><xsl:value-of select="$simpleTextAfter"/><xsl:text>AFTER</xsl:text></xsl:if>
          -->
        <xsl:text>&#x9;</xsl:text>
        <!--PROCESS 1818-->
        
        <xsl:choose><xsl:when test="./parent::app/rdg[contains(@wit, '#f1831')]"> <xsl:analyze-string select="./parent::app/rdg[contains(@wit, '#f1831')]" regex="&lt;.+?&gt;">
            <xsl:non-matching-substring><xsl:text> </xsl:text><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string></xsl:when>
       <xsl:otherwise>
           <xsl:text>[NO 1831 VARIANT]</xsl:text>
       </xsl:otherwise>
       </xsl:choose>
<xsl:text>&#10;</xsl:text>
    </xsl:template>

</xsl:stylesheet>