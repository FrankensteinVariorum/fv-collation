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
                <xsl:variable name="ms-rest" select="tokenize(regex-group(1), '-')"/>
                <xsl:variable name="ms" select="$ms-rest[1]"/>
                <xsl:variable name="parts" select="tokenize($ms-rest[2], '__')"/>
                <xsl:variable name="surface" select="$parts[1]"/>
                <xsl:variable name="zone" select="$parts[2]"/>
                <xsl:variable name="line" select="$parts[3]"/>
                <xsl:value-of select="concat('ox-ms_abinger_', $ms, '/ox-ms_abinger_', $ms, '-', $surface, '.xml', '#')"/>
                <xsl:text>string-range(//zone[@type='</xsl:text>
                <xsl:value-of select="$zone"/>
                <xsl:text>']//line[</xsl:text>
                <xsl:value-of select="$line"/>
                <xsl:text>]</xsl:text>
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
                        <xsl:when test="contains(normalize-space(.), 'lb n=&quot;')">
                            <xsl:for-each select="tokenize(normalize-space(.), '&lt;lb\s+n')">                                
                                <xsl:variable name="pointer">
                                    <xsl:value-of select="pitt:getLbPointer(normalize-space(current()))"/>
                                </xsl:variable>
                                <xsl:if test="not($pointer = '')">
                                    <xsl:variable name="text" select="
                                        replace(
                                        replace(
                                        normalize-space(current()), '&lt;.*?&gt;', ''
                                        ),
                                        '^=&quot;[^&quot;]+?&quot;\s*?/&gt;', ''
                                        )"/>
                                    <ptr target="{pitt:getLbPointer(normalize-space(current()))},0,{string-length($text)})"/>
                                    <line_text>
                                        <xsl:value-of select="$text"/>                                        
                                    </line_text>
                                </xsl:if>                                
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="str" select="tokenize(normalize-space(string-join(preceding::rdg[@wit='#fMS'])), '&lt;lb\s+n')[last()]"/>
                            <xsl:variable name="pointer">
                                <xsl:value-of select="pitt:getLbPointer(normalize-space(tokenize(preceding::rdg[@wit='#fMS'][contains(normalize-space(.), 'lb n=&quot;')][1], '&lt;lb\s+n')[last()]))"/>
                            </xsl:variable>
                            <xsl:if test="not($pointer = '')">
                                <xsl:variable name="pre_text" select="replace(replace($str, '&lt;.*?&gt;', ''), '^=&quot;[^&quot;]+?&quot;\s*?/&gt;', '')"/>
                                <xsl:variable name="cur_text" select="replace(normalize-space(.), '&lt;.*?&gt;', '')"/>
                                <ptr target="{$pointer},{string-length($pre_text)},{string-length($cur_text)+1})"/> <!-- +1 accounts for a normalized white space between pre_text and cur_text -->
                                <line_text>
                                    <xsl:value-of select="concat('(', $pre_text, ') ', $cur_text)"/>
                                </line_text>
                            </xsl:if>               
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