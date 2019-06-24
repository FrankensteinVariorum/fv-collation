<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
    <xsl:variable name="collChunkIds" as="item()+" select="$frankenChunks//anchor[@type='collate']/@xml:id => distinct-values() => sort()"/>
    <xsl:template match="/">
       <fLib n="collUnit-StringLengths"> 
           <xsl:comment>This contains string-length data from the collation units in the Frankenstein Variorum project. It includes string lengths preceding milestone markers to help determine relative positioning of volume, letter, and chapter beginnings.</xsl:comment>
           <xsl:for-each select="$collChunkIds">
            <xsl:sort/>
               <xsl:variable name="currID" as="xs:string" select="current()"/>
          <fs type="collationUnit" xml:id="{$currID}">  
              <!-- the documents at this unit -->
                  <xsl:variable name="CU_msColl" as="document-node()*" select="doc($frankenChunks[starts-with(tokenize(base-uri(), '/')[last()], 'msColl') and tokenize(base-uri(), '/')[last()] ! tokenize(., '_')[last()] ! substring-before(., '.xml') eq $currID]/base-uri())"/> 
                  <xsl:variable name="CU_1818" as="document-node()*" select="doc($frankenChunks[starts-with(tokenize(base-uri(), '/')[last()], '1818') and tokenize(base-uri(), '/')[last()] ! tokenize(., '_')[last()] ! substring-before(., '.xml') eq $currID]/base-uri())"/>
              <xsl:variable name="CU_Thomas" as="document-node()*" select="doc($frankenChunks[starts-with(tokenize(base-uri(), '/')[last()], 'Thomas') and tokenize(base-uri(), '/')[last()] ! tokenize(., '_')[last()] ! substring-before(., '.xml') eq $currID]/base-uri())"/>
                  <xsl:variable name="CU_1823" as="document-node()*" select="doc($frankenChunks[starts-with(tokenize(base-uri(), '/')[last()], '1823') and tokenize(base-uri(), '/')[last()] ! tokenize(., '_')[last()] ! substring-before(., '.xml') eq $currID]/base-uri())"/>  
              <xsl:variable name="CU_1831" as="document-node()*" select="doc($frankenChunks[starts-with(tokenize(base-uri(), '/')[last()], '1831') and tokenize(base-uri(), '/')[last()] ! tokenize(., '_')[last()] ! substring-before(., '.xml') eq $currID]/base-uri())"/> 
              <xsl:variable name="versionChunks" as="document-node()+" select="($CU_msColl, $CU_1818, $CU_Thomas, $CU_1823, $CU_1831)"/>

              <xsl:for-each select="$versionChunks">
                  <xsl:variable name="cu_SL" select="descendant::text()[not(matches(., '^\s+$'))][not(preceding-sibling::del[1][@sID])]/normalize-space() ! string-length() => sum()"/>
                  <f name="{tokenize(base-uri(), '/')[last()] ! substring-before(., '.xml')}--stringLength" fVal="{$cu_SL}"> 
                      <xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-before(., '.xml')"/>
             <xsl:variable name="milestones" as="element()*" select="descendant::milestone[not(@* = ('tei:p', 'tei:lg', 'tei:l', 'tei:note', 'tei:seg', 'end'))]"/>         
               <xsl:if test="$milestones"> 
                   <fs type="milestoneMeasures">
                       <xsl:comment>Note: These are measurements for all qualifying text nodes from the beginning of the collation unit to the point of the current milestone.</xsl:comment>
                   <xsl:for-each select="$milestones">  
                    <xsl:variable name="textUnit" as="xs:string*">
                        <xsl:value-of select="preceding::text()[not(matches(., '^\s+$'))][not(preceding-sibling::del[1][@sID])]/normalize-space()"/>        
                     </xsl:variable> 
                       <xsl:message><xsl:value-of select="$textUnit"/></xsl:message>
                       <xsl:variable name="stringLengthToHere" as="xs:integer">
                           <xsl:value-of select="$textUnit ! string-length() => sum()"/>
                       </xsl:variable>
                          <f name="{@unit}" fVal="{$stringLengthToHere}"/>        
          </xsl:for-each>
                   </fs>
               </xsl:if>
               </f>
               </xsl:for-each>
          </fs>
           
           </xsl:for-each>
       </fLib>
        
    </xsl:template>
    
</xsl:stylesheet>