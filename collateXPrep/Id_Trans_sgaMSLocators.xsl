<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
    <!--ebb: This XSLT adds xml:ids to every lb element, to prepare the files we are calling "flagged" such that each line-break element contains a flag indicating its specific location in its manuscript page.  -->
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="lb">
        <xsl:choose>
            <xsl:when test="parent::zone[@type = 'main']">
                <lb
                    n="{substring-after(ancestor::surface/@xml:id, 'ox-ms_abinger_')}__main__{count(preceding-sibling::lb) + 1}">
                    <xsl:apply-templates/>
                </lb>
            </xsl:when>
            <xsl:when test="parent::zone[@corresp]">
                <lb
                    n="{substring-after(ancestor::surface/@xml:id, 'ox-ms_abinger_')}__{parent::zone/@type}__{count(preceding-sibling::lb) + 1}">
                    <xsl:apply-templates/>
                </lb>

            </xsl:when>
        </xsl:choose>


    </xsl:template>

</xsl:stylesheet>
