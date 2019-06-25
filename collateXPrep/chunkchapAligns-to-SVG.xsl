<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
<!-- 2019-06-24 ebb: This file is designed to create an SVG document of the collation units and how they compare with one another in size, as well as where major text divisions within them. 
       
The variable below reads a document storing string-length measurements for each collation unit, and each of the five versions at that collation unit. Where present, it lists the string-length measurements up to the point of each milestone that marks a major text division, whether volume, letter, or chapter. If multiple milestones appear in a unit, each one's position is measured from the start of the collation unit.  -->       
<xsl:variable name="chunkAlignments" as="document-node()" select="doc('chunkChapMeasures.xml')"/>
<xsl:variable name="collChunkUnits" as="element()+" select="$chunkAlignments//fLib/fs[@type='collationUnit']"/>
<xsl:variable name="collChunkIds" as="xs:string+" select="$collChunkUnits/@xml:id/string()"/>

    <!--ebb: Sketching notes: Between 14 and 228 width if you want to compare size of collation unit on the X axis as stroke-widths based on string-lengths. Set 20 between each. 
 3 column layout: Widest is around 60, but we need to add sidebar info, so try making each column 200 wide, 9 coll units long. 
        This makes 4 columns @200 = 800 wide -->
   
   <!--COLORS -->
    <xsl:variable name="color_MS" as="xs:string" select="concat('#', '8380E2')"/>
    <xsl:variable name="color_1818" as="xs:string" select="concat('#', 'FDB27B')"/>
    <xsl:variable name="color_Thom" as="xs:string" select="concat('#', 'c96464')"/>
    <!-- ebb: This is meant to be tomato red. 
        Agile design flat for Thomas was originally soft green: #98C99F. 
        I'm moving this to green to replace their 1823.
      -->
    <xsl:variable name="color_1823" as="xs:string" select="concat('#', '98C99F')"/>
    <!-- ebb: Agile's original color for this was aqua. I'm replacing it with their green that
        they originally used in Thomas. -->
    <xsl:variable name="color_1831" as="xs:string" select="concat('#', '4650bf')"/>
    <!-- ebb: Agile's original carnivalesque pink (#E378BF) looks weird with the red I selected for Thomas, so I'm trying navy blue ('#1825ba') and a soft dark blue-grey (#024e82) and a purplish blue.
    -->
    <xsl:variable name="colorArray" as="xs:string+" select="concat($color_MS, ', ', $color_1818, ', ', $color_Thom, ', ', $color_1823, ', ', $color_1831)"/>
    
    <xsl:template match="/">
        <svg width="1500" height="1300" viewBox="0 0 2200 2550">
            <g id="wrapper" transform="translate(-100, 50)">
        
          <xsl:for-each select="$collChunkUnits">
              <xsl:sort select="@xml:id"/>
            <xsl:variable name="cu_pos" select="position()"/>
            <xsl:variable name="vertPos" as="xs:integer" select="$cu_pos mod 9"/>
            <xsl:variable name="columnPos" as="xs:decimal" select="(floor($cu_pos div 9) + 1) * 500"/>
            <xsl:variable name="ySpacer" select="20"/>
            <xsl:variable name="xSpacer" select="10"/>
            <xsl:variable name="widthFactor" select="20"/>
            <xsl:variable name="heightFactor" select="120"/>
            <g id="{current()/@xml:id}"><!--Collation unit wrapper-->
             <xsl:variable name="cu_MaxestoHere" as="xs:double*">
                 <xsl:for-each select="preceding-sibling::fs[@type='collationUnit'][position() le $vertPos]">
                     <xsl:value-of select="f/@fVal/string() ! number() => max()"/>
                 </xsl:for-each>
             </xsl:variable>
         
              <xsl:variable name="Sum_MaxestoHere" select="sum($cu_MaxestoHere)"/> 
                <xsl:comment>Array of CU Maxes to Here: <xsl:value-of select="string-join($cu_MaxestoHere, ', ')"/></xsl:comment>
                <xsl:comment>Sum of max values to here: <xsl:value-of select="$Sum_MaxestoHere div $heightFactor"/>
                </xsl:comment>
                <xsl:variable name="yPos1" as="xs:double" select="($Sum_MaxestoHere div $heightFactor) + ($ySpacer * $vertPos) "/>
            <text x="{-($xSpacer * 3) + $columnPos}" y="{$yPos1}" fill="black" font-size="20" font-weight="bold">cu <xsl:value-of select="current()/@xml:id ! substring-after(., 'C')"/></text>
               
               <xsl:for-each select="f">
                   <xsl:variable name="fPos" select="position()"/>
                  <xsl:variable name="xPos" select="($widthFactor + $xSpacer) * $fPos + $columnPos"/>
       <g class="{./text() ! normalize-space()}">
           <line x1="{$xPos}" x2="{$xPos}" y1="{$yPos1}" y2="{$yPos1 + (@fVal/string() ! number() div $heightFactor)}" style="stroke:{tokenize($colorArray, ', ')[$fPos]};stroke-width:{$widthFactor}">
               <title><xsl:value-of select="@name ! substring-before(., '_')"/></title>
           </line>
           
        <xsl:if test="contains(@name, '1818') and fs[@type='milestoneMeasures']">
              <xsl:for-each select="fs[@type='milestoneMeasures']/f[starts-with(., 'LETTER') or starts-with(., 'CHAPTER')]"> 
                  <text x="{(-$xSpacer * 25) + $columnPos}" y="{$yPos1 + @fVal div $heightFactor}" fill="black" font-size="22" font-weight="400">1818: <xsl:value-of select="text() ! tokenize(., ' ')[position() lt 3] => string-join(' ')"/></text></xsl:for-each>
           
           </xsl:if>
           
           <xsl:for-each select="fs[@type='milestoneMeasures']/f">
      <xsl:variable name="yMile" select="$yPos1 + @fVal div $heightFactor"/>
          <!--  <text x="{($xSpacer * position() - 200) + $columnPos}" y="{$yMile}" fill="black" font-size="20"><xsl:value-of select="@name"/></text>-->
            <line x1="{$xPos - $widthFactor div 2}" x2="{$xPos + $widthFactor div 2}" y1="{$yMile + 15 div 2}" y2="{$yMile + 15 div 2}" style="stroke:black; stroke-width:15">
                <title><xsl:value-of select="."/></title>
                </line>
        </xsl:for-each>
       </g>              
               </xsl:for-each>  
            </g>
          </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
    
</xsl:stylesheet>