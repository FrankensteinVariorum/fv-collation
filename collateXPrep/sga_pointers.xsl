<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    exclude-result-prefixes="xs math pitt"
    version="3.0">
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output indent="yes"/>    
    <xsl:strip-space elements="*"/>
    <xsl:param name="sga_loc" select="'https://github.com/umd-mith/sga/tree/master/data/tei/ox/'"/>
    
    <xsl:function name="pitt:getLbPointer" as="item()*">
        <xsl:param name="str"/>
        <xsl:analyze-string select="$str" regex="^=&quot;([^&quot;]+?)&quot;\s*?/&gt;">
            <xsl:matching-substring>
                <!--<xsl:message>+++<xsl:value-of select="regex-group(1)"/>+++</xsl:message>-->
                <xsl:variable name="ms-rest" select="tokenize(regex-group(1), '-')"/>
                <xsl:variable name="ms" select="$ms-rest[1]"/>
                <xsl:variable name="parts" select="tokenize($ms-rest[2], '__')"/>
                <xsl:variable name="surface" select="$parts[1]"/>
                <xsl:variable name="zone" select="$parts[2]"/>
                <xsl:variable name="line" select="$parts[3]"/>
                <xsl:value-of select="concat('ox-ms_abinger_', $ms, '/ox-ms_abinger_', $ms, '-', $surface, '.xml', '#')"/>
                <xsl:text>xpath(//zone[@type='</xsl:text>
                <xsl:value-of select="$zone"/>
                <xsl:text>']//line[</xsl:text>
                <xsl:value-of select="$line"/>
                <xsl:text>])</xsl:text>
            </xsl:matching-substring>
        </xsl:analyze-string>        
    </xsl:function>
    
    <!--<xsl:function name="pitt:removeTags">
        <xsl:param name="str"/>
        <xsl:value-of select="replace($str, '&lt;[^&gt;]+&gt;', '')"/>
    </xsl:function>-->
    
    <xsl:template match="rdg">
        <xsl:choose>
            <xsl:when test="@wit='#fMS'">
                <rdg wit="#fMS">
                    <xsl:choose>
                        <xsl:when test="contains(., 'lb n=&quot;')">
                            <xsl:for-each select="tokenize(., '&lt;lb\s+n')">
                                <xsl:variable name="pointer">
                                    <xsl:value-of select="pitt:getLbPointer(current())"/>
                                </xsl:variable>
                                <xsl:if test="not($pointer = '')">
                                    <ptr target="{pitt:getLbPointer(current())}"/>
                                </xsl:if>                                
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <otherwise/>
                            <ptr target="{pitt:getLbPointer(preceding::rdg[@wit='#fMS'][contains(., 'lb n=&quot;')][1])}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdg>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="."/>
            </xsl:otherwise>
        </xsl:choose>         
    </xsl:template>
    
</xsl:stylesheet>