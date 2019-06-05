<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/> 
    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
    
    <xsl:variable name="collChunkIds" as="item()+" select="$frankenChunks//anchor[@type='collate']/@xml:id => distinct-values() => sort()"/>
    <xsl:template match="/">
        <svg>
        <xsl:for-each select="$collChunkIds">   
            <g id="{current()}"><!--Collation unit wrapper-->
                <!--msColl data -->
                <xsl:variable name="CU_msColl" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('msColl')][tokenize(base-uri(), '/')[last()] => substring-before('.xml') => substring-after('_') = current()]"/> 
                <xsl:variable name="SL_msColl" select="$CU_msColl//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>             
                <!--1818 data-->
   <xsl:variable name="CU_1818" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1818')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1818" select="$CU_1818//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                <!--Thomas data -->
                <xsl:variable name="CU_Thomas" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('Thomas')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_Thomas" select="$CU_Thomas//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>  
                <!--1823 data -->
                <xsl:variable name="CU_1823" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1823')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1823" select="$CU_1823//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                <!--1831 data -->
                <xsl:variable name="CU_1831" as="item()" select="$frankenChunks//xml[tokenize(base-uri(), '/')[last()] => starts-with('1831')][anchor[@type='collate']/@xml:id = current()]"/> 
                <xsl:variable name="SL_1831" select="$CU_1831//text()[not(matches(., '^\s+$'))]/normalize-space() ! string-length() => sum()"/>
                
                <g class="notebooks">String length here: <xsl:value-of select="$SL_msColl"/></g>
            <g class="1818ed">String length here: <xsl:value-of select="$SL_1818"/></g>
                <g class="Thomas">String length here: <xsl:value-of select="$SL_Thomas"/></g>
                <g class="1823ed">String length here: <xsl:value-of select="$SL_1823"/></g>
                <g class="1831ed">String length here: <xsl:value-of select="$SL_1831"/></g>
           
           </g></xsl:for-each>
            
        </svg>
        
    </xsl:template>
    
</xsl:stylesheet>