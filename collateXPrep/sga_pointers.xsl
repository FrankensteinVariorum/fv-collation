<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math pitt tei"
    version="3.0">
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output indent="yes"/>    
    <xsl:strip-space elements="*"/>
    <xsl:param name="sga_loc" select="'https://raw.githubusercontent.com/umd-mith/sga/master/data/tei/ox/'"/>
    
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
                <xsl:value-of select="concat($sga_loc, 'ox-ms_abinger_', $ms, '/ox-ms_abinger_', $ms, '-', $surface, '.xml', '#')"/>
                <xsl:text>string-range(//tei:zone[@type='</xsl:text>
                <xsl:value-of select="$zone"/>
                <xsl:text>']//tei:line[</xsl:text>
                <xsl:value-of select="$line"/>
                <xsl:text>]</xsl:text>
            </xsl:matching-substring>
        </xsl:analyze-string>        
    </xsl:function>
    
    <xsl:function name="pitt:resolvePointer">
        <xsl:param name="pointer"/>
        <xsl:variable name="filename" select="substring-before($pointer, '#')"/>
        <xsl:variable name="string_range" select="tokenize(tokenize($pointer, 'string-range\(')[2],',')"/>
        <xsl:variable name="xpath" select="concat('doc(&quot;', $filename,'&quot;)', $string_range[1])"/>
        <xsl:variable name="line">
            <xsl:evaluate xpath="$xpath"/>
        </xsl:variable>
        <xsl:variable name="text" select="substring-before(substring(normalize-space($line), number($string_range[2])), 
            substring(normalize-space($line), number(substring-before($string_range[3], ')'))))"/>
        <xsl:choose>
            <xsl:when test="$text = ''">
                <!-- If there's no match, it means the second substring is empty (end of line) -->
                <xsl:value-of select="substring(normalize-space($line), number($string_range[2]))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="rdg">
        <xsl:choose>
            <xsl:when test="@wit='#fMS'">
                <rdg wit="#fMS">
                    <xsl:choose>
                        <!-- When a reading contains one or more LB elements, split the content around LB and determine the pointer based on the LB value -->                        
                        <xsl:when test="contains(normalize-space(.), 'lb n=&quot;')">
                            <xsl:variable name="rdg" select="."/> 
                            <xsl:for-each select="tokenize(normalize-space(.), '&lt;lb\s+n')">
                                <xsl:choose>
                                    <!-- EDGE CASE: the first token belongs to a previous line, in which case the previous line will need to be located -->
                                    <!-- Each token after an LB will start with '=', so check whether it's missing -->
                                    <xsl:when test="starts-with(normalize-space(.), '=')">
                                        <!-- Only process it if there's content after the lb -->
                                        <xsl:if test="string-length(substring-after(normalize-space(.), '/&gt;')) > 0">
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
                                                <xsl:variable name="full_pointer" select="concat(string-join(pitt:getLbPointer(normalize-space(current()))),',0,',string-length($text)+1, ')')"/>
                                                <ptr target="{$full_pointer}"/>
                                                <line_text>
                                                    <xsl:value-of select="$text"/>                                        
                                                </line_text>
                                                <resolved_text>
                                                    <xsl:value-of select="pitt:resolvePointer($full_pointer)"/>
                                                </resolved_text>
                                            </xsl:if> 
                                        </xsl:if>
                                    </xsl:when>
                                    <!-- Skip space-only or empty string nodes -->
                                    <xsl:when test="normalize-space(.) = ' ' or normalize-space(.)  = ''"/>
                                    <xsl:otherwise>
                                        <xsl:call-template name="lookback">
                                            <xsl:with-param name="rdg" select="$rdg"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>                           
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="lookback"/>                            
                        </xsl:otherwise>
                    </xsl:choose>
                </rdg>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="."/>
            </xsl:otherwise>
        </xsl:choose>         
    </xsl:template>
    
    <xsl:template name="lookback">
        <xsl:param name="rdg" select="."/>
        <xsl:variable name="str" select="tokenize(normalize-space(string-join($rdg/preceding::rdg[@wit='#fMS'])), '&lt;lb\s+n')[last()]"/>
        <xsl:variable name="pointer">
            <xsl:value-of select="pitt:getLbPointer(normalize-space(tokenize($rdg/preceding::rdg[@wit='#fMS'][contains(normalize-space(.), 'lb n=&quot;')][1], '&lt;lb\s+n')[last()]))"/>
        </xsl:variable>
        <xsl:if test="not($pointer = '')">
            <xsl:variable name="pre_text" select="replace(replace($str, '&lt;.*?&gt;', ''), '^=&quot;[^&quot;]+?&quot;\s*?/&gt;', '')"/>
            <xsl:variable name="cur_text" select="replace(normalize-space(.), '&lt;.*?&gt;', '')"/>
            <xsl:variable name="full_pointer" select="concat($pointer,',',string-length($pre_text)+1,',',string-length($pre_text)+string-length($cur_text)+2, ')')"/> <!-- "2" accounts for needed extra space and index number -->
            <ptr target="{$full_pointer}"/>
            <line_text>
                <xsl:value-of select="concat('(', $pre_text, ') ', $cur_text)"/>
            </line_text>
            <resolved_text>
                <xsl:value-of select="pitt:resolvePointer($full_pointer)"/>
            </resolved_text>
        </xsl:if>      
    </xsl:template>
    
</xsl:stylesheet>