<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
    <xsl:variable name="msCollChunks" as="document-node()+" select="collection('collationChunks/?select=msColl_*.xml')"/>
   <!-- <xsl:variable name="anchorPoints-msColl" as="element()+" select="$frankenChunks//anchor[@type='collate'][contains(tokenize(base-uri(), '/')[last()], 'msColl') ]"/>
-->
    <!-- 2019-06-20 ebb: This XSLT is designed to construct a file for each collation unit's scope of S-GA files. It is designed to list xi:includes for each file that constitutes a page surface in the collation unit. 
        
        Right now, the file reliably accommodates xincludes of page <surface> elements and does not go looking for other kinds of elements that could precede a first surface, or that could follow a last surface in a chunk file. We have determined that these instances are rare and do not affect the first 10 collation units, but will need special scoping with XPath/XPointers. 
        The transformation now simply flag the presence of such elements in a given chunk. We'll continue to develop this to include them with an XPointer and an xpath() to resolve to specific elements.
              -->
    <xsl:variable name="filepath" as="xs:string" select="'https://raw.githubusercontent.com/umd-mith/sga/master/data/tei/ox/'"/>
    <xsl:template match="/">
      <xsl:for-each select="$msCollChunks">
          <xsl:variable name="filename" select="concat('sga_collChunkAssembly/', 'fMS-', descendant::anchor[@type='collate']/@xml:id, '.xml')"/>
          <xsl:result-document method="xml" indent="yes" href="{$filename}">     
              <TEI xml:id="fMS-{descendant::anchor[@type='collate']/@xml:id}" xmlns:xi="http://www.w3.org/2001/XInclude">
          <teiHeader><fileDesc>
              <titleStmt>
                  <title type="main">Frankenstein manuscripts, Chunk <xsl:value-of select="tokenize(current()/base-uri(), '/')[last()]"/></title>
              </titleStmt>
              <editionStmt>
                  <edition>Shelley-Godwin Archive edition, <date>2012-2015</date>
                  </edition>
              </editionStmt>
              <publicationStmt>
                  <distributor>Oxford University</distributor>
                  <address>
                      <addrLine>
                          <ref target="http://www.shelleygodwinarchive.org/">http://www.shelleygodwinarchive.org/</ref>
                      </addrLine>
                  </address>
                  <availability status="free">
                      <licence target="http://creativecommons.org/publicdomain/zero/1.0/">
                          <p>CC0 1.0 Universal.</p>
                          <p> To the extent possible under law, the creators of the metadata records for the Shelley-Godwin Archive 
                              have waived all copyright and related or neighboring rights to this work.</p>
                      </licence>
                  </availability>
                  <pubPlace>Oxford, UK, and College Park, MD</pubPlace>
              </publicationStmt>
              <sourceDesc>
                  <msDesc>
                      <msIdentifier>
                          <settlement>Oxford</settlement>
                          <repository>Bodleian Library, University of Oxford</repository>
                          <idno type="Bod">MS. Abinger <xsl:value-of select="string-join(descendant::anchor[@type='collate']/following::surface/@base ! substring-before(., '/') ! substring-after(., 'ox-ms_abinger_') => distinct-values(), ', ')"/></idno>
                      </msIdentifier>
                      <physDesc>
                          <handDesc>
                              <handNote scope="major" xml:id="mws"><persName>Mary Shelley</persName></handNote>
                              <handNote scope="minor" xml:id="pbs"><persName>Percy Shelley</persName></handNote>
                          </handDesc>
                      </physDesc>
                  </msDesc>
              </sourceDesc>
          </fileDesc>
              <revisionDesc>
                  <change who="#ebb" when="2019-06-19">Constructed this to help organize S-GA files to be included as 
                      collation units for the Frankenstein Variorum project.</change>
                  <change who="#ebb" when="2019-06-20">Working on pinpointing where there are elements outside of page zone boundaries in collation chunks for fMS. Not finished.</change>
              </revisionDesc>
          </teiHeader>
          <sourceDoc>
              <xsl:if test="descendant::anchor[@type='collate'][following-sibling::*[1][not(self::surface[@sID])]]">
                  <xsl:variable name="preBase" as="xs:string" select="concat(descendant::anchor[@type='collate']/following::surface[@eID][1]/@eID ! replace(., '-\d+$', ''), '/', descendant::anchor[@type='collate']/following::surface[@eID][1]/@eID)"/>
                  
                  <xsl:for-each select="descendant::anchor[@type='collate']/following::element()[self::milestone or self::*[@sID]][following::surface[@sID][not(preceding::surface[@sID])]]">  
                      <xsl:variable name="elemName" as="xs:string">
                          <xsl:choose>
                              <xsl:when test="self::milestone"><xsl:value-of select="concat(name(), '[@unit=', @unit, ']')"/></xsl:when>
                              <xsl:when test="self::lb">
                                  <xsl:value-of select="concat('line', '[ancestor::zone[@type=', '&quot;', tokenize(@n, '__')[2], '&quot;', '[2]', '[', tokenize(@n, '__')[last()], ']')"/>
                              </xsl:when>
                              <xsl:when test="self::zone">
                                  <xsl:value-of select="concat(name(), '[@type=', @type, ']', '[', '@corresp=', @corresp, ']')"/>             
                              </xsl:when>
                              <xsl:when test="not(self::zone) and not(self::lb) and @sID">
                                  <xsl:value-of select="concat(name(), '[ancestor::zone[@type=', '&quot;', tokenize(@sID, '__')[2], '&quot;', '[2]')"/>                      
                              </xsl:when>
                          </xsl:choose>
                      </xsl:variable>
                      <xsl:element name="xi:include">
                          <xsl:attribute name="href">
                              <xsl:value-of select="concat($filepath, $preBase, '#', $elemName)"/>
                          </xsl:attribute>
                      </xsl:element></xsl:for-each>
                  
              </xsl:if>
             <xsl:for-each select="descendant::anchor[@type='collate']/following::surface[@sID]">

                 <xsl:variable name="base" as="xs:string" select="@base/string()"/>
                 
                 
                 <!-- On surface elements in our source XML, the @base attributes hold last part of pointer.  -->
              <xsl:element name="xi:include">
                  <xsl:attribute name="href">
                      <xsl:value-of select="concat($filepath, $base)"/>
                  </xsl:attribute>
              </xsl:element>
               <!--     <include href="{concat($filepath, $base)}" />-->
         </xsl:for-each>
              <xsl:if test="(descendant::surface[@eID])[last()][following-sibling::surface[@sID]]">
                  <xsl:variable name="postBase" as="xs:string" select="concat(descendant::surface[@eID][last()]/following-sibling::*[1][self::surface[@sID]]/@sID ! replace(., '-\d+$', ''), '/', descendant::surface[@eID][last()]/following-sibling::*[1][self::surface[@sID]]/@sID)"/>
                  <xsl:comment>Elements follow the last complete page surface in this collation chunk.</xsl:comment>
              <!--    
                  <xsl:for-each select="descendant::surface[@eID][last()][following-sibling::surface[@sID]]/following::*">  
                      <xsl:variable name="elemNamePost" as="xs:string">
                          <xsl:choose>
                              <xsl:when test="self::milestone"><xsl:value-of select="concat(name(), '[@unit=', '&quot;', @unit, '&quot;', ']')"/></xsl:when>
                              <xsl:when test="self::lb">
                                  <xsl:value-of select="concat('line', '[ancestor::zone[@type=', '&quot;', tokenize(@n, '__')[2], '&quot;', '[2]', '[', tokenize(@n, '__')[last()], ']')"/>
                              </xsl:when>
                              <xsl:when test="self::zone">
                                  <xsl:value-of select="concat(name(), '[@type=', '&quot;', @type, '&quot;', ']')"/>             
                              </xsl:when>
                              <xsl:when test="not(self::zone) and not(self::lb) and @sID">
                                  <xsl:value-of select="concat(name(), '[ancestor::zone[@type=', '&quot;', tokenize(@sID, '__')[2], '&quot;', '[2]')"/>                      
                              </xsl:when>
                          </xsl:choose>
                      </xsl:variable>
                      <xsl:element name="xi:include">
                          <xsl:attribute name="href">
                              <xsl:value-of select="concat($filepath, $postBase, '#', $elemNamePost)"/>
                          </xsl:attribute>
                      </xsl:element></xsl:for-each>-->
                  
              </xsl:if>
          </sourceDoc>
      </TEI>  
     </xsl:result-document>
      </xsl:for-each>
    </xsl:template>

      
        
        
   
    
    
</xsl:stylesheet>