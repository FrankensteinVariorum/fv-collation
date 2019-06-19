<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="frankenChunks" as="document-node()+" select="collection('collationChunks/?select=*.xml')"/>
    <xsl:variable name="msCollChunks" as="document-node()+" select="collection('collationChunks/?select=msColl_*.xml')"/>
   <!-- <xsl:variable name="anchorPoints-msColl" as="element()+" select="$frankenChunks//anchor[@type='collate'][contains(tokenize(base-uri(), '/')[last()], 'msColl') ]"/>
-->
 <!-- 2019-06-19 Output new file for each chunk (xsl:result-document), 
     keep Header physDesc. Drop original revisionDesc but maybe start
a new one. Keep creative commons license in <availability>. 
 
 These are ONLY for ms sga stuff.
 Reconstruct the filenames from the surface xml:ids. 
 -->
    <xsl:template match="/">
      <xsl:for-each select="$msCollChunks">
          <xsl:variable name="filename" select="concat('sga_collChunkAssembly/', 'fMS-', descendant::anchor[@type='collate']/@xml:id, '.xml')"/>
     <xsl:result-document method="xml" indent="yes" href="{$filename}">     
          <TEI xml:id="fMS-{descendant::anchor[@type='collate']/@xml:id}">
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
                          <idno type="Bod">MS. Abinger c.56, c.57, and c.58</idno>
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
                  <change who="#ebb">Constructed this to help organize S-GA files to be included as 
                      collation units for the Frankenstein Variorum project.</change>
              </revisionDesc>
          </teiHeader>
          <sourceDoc>
          <xsl:apply-templates select="descendant::anchor[@type='collate']">
          <xsl:sort select="@xml:id"/>
      </xsl:apply-templates>
          </sourceDoc>
      </TEI>  
     </xsl:result-document>
      </xsl:for-each>
    </xsl:template>
    <xsl:template match="anchor[@type='collate']"> 
        <xsl:copy-of select="current()"/>
        <xsl:copy-of select="current()/following-sibling::*[1]"/>
   
    </xsl:template>
    
</xsl:stylesheet>