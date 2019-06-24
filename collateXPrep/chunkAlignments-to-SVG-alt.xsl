<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
 <!--ebb: Redistributing the plots so the proportional length is on just the y axis.
     Maximum string-length (SL_max variable) is 22573. Divide string-lengths by 100. Largest will be 226. Alot 250 per plot? For 3 columns: 250 * 11 = 2750 (3000)
 -->  
    <!-- 3 column layout: Width of plots will be set at 150, and we need to add sidebar info, so try making each column 500 wide, 9 coll units long. 
        This makes 4 columns @500 = 2000 wide
    
    -->
   <!--2019-06-21 ebb: Lining up text unit milestones: 
   Look for milestone elements and get @unit and @n (mscoll has @unit)
   Get string-length, divide by max string-length to determine position...
   
   --> 
    
    <xsl:variable name="collChunkIds" as="item()+" select="$frankenChunks//anchor[@type='collate']/@xml:id => distinct-values() => sort()"/>
    <xsl:variable name="color_MS" as="xs:string" select="concat('#', '8380E2')"/>
    <xsl:variable name="color_1818" as="xs:string" select="concat('#', 'FDB27B')"/>
    <xsl:variable name="color_1823" as="xs:string" select="concat('#', '6FBCC0')"/>
    <xsl:variable name="color_1831" as="xs:string" select="concat('#', 'E378BF')"/>
    <xsl:variable name="color_Thom" as="xs:string" select="concat('#', '98C99F')"/>
    
    <xsl:template match="/">
        <svg width="2000" height="3000" viewBox="0 0 3000 4000">
            <g id="wrapper" transform="translate(30, 4000)">
        <xsl:for-each select="$collChunkIds">
            <xsl:sort order="descending"/>
            <xsl:variable name="vertPos" as="xs:decimal" select="(position() mod 9)"/>
            <xsl:variable name="columnPos" as="xs:decimal" select="(floor(position() div 9) + 1) * 200"/>
            <xsl:variable name="ySpacer" select="-200"/>
            <xsl:variable name="xSpacer" select="10"/>
            <xsl:variable name="widthFactor" select="20"/>
            <xsl:variable name="heightFactor" select="100"/>
            <g id="{current()}"><!--Collation unit wrapper-->
                <!--msColl data -->
                <xsl:variable name="CU_msColl" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('msColl')][tokenize(base-uri(), '/')[last()] => substring-before('.xml') => substring-after('_') = current()]"/> 
                <xsl:variable name="SL_msColl" select="$CU_msColl//text()[not(matches(., '^\s+$'))][not(preceding-sibling::del[1][@sID])]/normalize-space() ! string-length() => sum()"/>             
                <!--1818 data-->
                <xsl:variable name="CU_1818" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1818')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1818" select="$CU_1818//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                <!--1823 data -->
                <xsl:variable name="CU_1823" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1823')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1823" select="$CU_1823//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                <!--1831 data -->
                <xsl:variable name="CU_1831" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1831')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1831" select="$CU_1831//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                <!--Thomas data -->
                <xsl:variable name="CU_Thomas" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('Thomas')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_Thomas" select="$CU_Thomas//text()[not(matches(., '^\s+$'))][not(preceding-sibling::del[1][@sID])]/normalize-space() ! string-length() => sum()"/> 
                <!--ebb: Note: This is removing del spans from Thomas. -->
                <xsl:variable name="SL_max" select="max(($SL_Thomas, $SL_1818, $SL_1823, $SL_1831, $SL_msColl))"/>

                <xsl:variable name="yPos1" select="$vertPos * $ySpacer"/><!-- a negative value--> 
                <text x="{-($xSpacer * 3) + $columnPos}" y="{$yPos1}" fill="black"><xsl:value-of select="current()"/></text>
            
                <xsl:for-each select="($CU_msColl, $CU_1818, $CU_1823, $CU_1831, $CU_Thomas)">
          <xsl:variable name="xVal" select="$xSpacer * position() + $columnPos + $xSpacer"/>
                <g class="notebooks"><xsl:comment>String length here: <xsl:value-of select="$SL_msColl"/></xsl:comment>
                   
                    <xsl:variable name="yPos2_ms" select="$yPos1 - ($SL_msColl div $heightFactor) "/>
                    <line x1="{$xVal}" y1="{$yPos1}" x2="{$xVal}" y2="{$yPos2_ms}" style="stroke:{$color_MS};stroke-width:{$widthFactor}" />
                </g>
                <g class="1818ed"><xsl:comment>String length here: <xsl:value-of select="$SL_1818"/></xsl:comment>
                    <xsl:variable name="yPos2_1818" select="$yPos1 - ($SL_1818 div $heightFactor) "/>
                    <line x1="{$xVal}" y1="{$yPos1}" x2="{$xVal}" y2="{$yPos2_1818}" style="stroke:{$color_1818};stroke-width:{$widthFactor}" />     
                </g>
                <g class="1823ed"><xsl:comment>String length here: <xsl:value-of select="$SL_1823"/></xsl:comment>
                    <xsl:variable name="yPos2_1823" select="$yPos1 - ($SL_1823 div $heightFactor) "/>
                    <line x1="{$xVal}" y1="{$yPos1}" x2="{$xVal}" y2="{$yPos2_1823}" style="stroke:{$color_1823};stroke-width:{$widthFactor}" />
                </g>
                <g class="1831ed"><xsl:comment>String length here: <xsl:value-of select="$SL_1831"/></xsl:comment>
                    <xsl:variable name="yPos2_1831" select="$yPos1 - ($SL_1831 div $heightFactor) "/>
                    <line x1="{$xVal}" y1="{$yPos1}" x2="{$xVal}" y2="{$yPos2_1831}" style="stroke:{$color_1831};stroke-width:{$widthFactor}" />
                </g>
                <g class="Thomas"><xsl:comment>String length here: <xsl:value-of select="$SL_Thomas"/></xsl:comment>
                    <xsl:variable name="yPos2_Thomas" select="$yPos1 - ($SL_Thomas div $heightFactor) "/>
                    <line x1="{$xVal}" y1="{$yPos1}" x2="{$xVal}" y2="{$yPos2_Thomas}" style="stroke:{$color_Thom};stroke-width:{$widthFactor}" />
                </g>
            </xsl:for-each>
           
           </g></xsl:for-each>
            </g>   
        </svg>
        
    </xsl:template>
    
</xsl:stylesheet>