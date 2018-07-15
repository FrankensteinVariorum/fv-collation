<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P4-BridgeColl-C10" as="document-node()+" select="collection('bridge-P4-C10')"/> 
<!--2018-06-26: NOT WORKING: This is Bridge Construction Phase 6: Here we "unpack" the self-closed <seg> elements marking hotspots, and where their ends are marked in following elements, we reconstruct them in pieces. We also deliver the seg identifying locations to the Spinal Column file. -->    
   <xsl:template match="/">
       <xsl:for-each select="$P4-BridgeColl-C10//TEI">
           <xsl:variable name="currentP4File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:text>P5-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P4-')"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/> 

           <xsl:result-document method="xml" indent="yes" href="bridge-P5-C10/{$filename}">
        <TEI>
            <xsl:apply-templates select="descendant::teiHeader"/>
        <text>
            <body>
                <xsl:apply-templates select="descendant::div[@type='collation']"/>
            </body>
        </text>
        </TEI>
         </xsl:result-document>
       </xsl:for-each>
       
   </xsl:template>
 <xsl:template match="teiHeader">
     <teiHeader>
         <fileDesc>
         <titleStmt><xsl:apply-templates select="descendant::titleStmt/title"/></titleStmt>
         <xsl:copy-of select="descendant::publicationStmt"/>
         <xsl:copy-of select="descendant::sourceDesc"/>
     </fileDesc>
     </teiHeader>
 </xsl:template>
    <xsl:template match="titleStmt/title">
        <title>
            <xsl:text>Bridge Phase 5:</xsl:text><xsl:value-of select="tokenize(., ':')[last()]"/>
        </title>
    </xsl:template>
   <xsl:template match="*[child::seg]">
       <xsl:variable name="currentTemplateNode" select="." as="element()"/>
       <xsl:choose>
           <!--Test 1 -->
           <xsl:when test="seg[matches(@xml:id, 'start')][following-sibling::seg[1][matches(@xml:id, 'end')]][substring-before(@xml:id, '_start') = substring-before(following-sibling::seg[1]/@xml:id, '_end')]">
               <xsl:variable name="Segs-case-A" select="seg[matches(@xml:id, 'start')][following-sibling::seg[1][matches(@xml:id, 'end')]][substring-before(@xml:id, '_start') = substring-before(following-sibling::seg[1]/@xml:id, '_end')]" as="element()+"/>
               <xsl:variable name="SegIds-case-A" select="seg[matches(@xml:id, 'start')][following-sibling::seg[1][matches(@xml:id, 'end')]][substring-before(@xml:id, '_start') = substring-before(following-sibling::seg[1]/@xml:id, '_end')]/@xml:id" as="attribute()+"/>
               <xsl:for-each select="$Segs-case-A">
                   <xsl:variable name="Seg-IdA" select="current()/@xml:id" as="attribute()"/>
                   <xsl:apply-templates select="$currentTemplateNode/node()[not(preceding-sibling::seg[@xml:id = $Seg-IdA])]"/>    
               </xsl:for-each>
           </xsl:when>
           <!--Test 2 -->
           <xsl:when test="seg[matches(@xml:id, 'start')][not(following-sibling::seg[matches(@xml:id, 'end')])]">
               <xsl:variable name="Segs-case-B" select="seg[matches(@xml:id, 'start')][not(following-sibling::seg[matches(@xml:id, 'end')])]" as="element()+"/>
               <xsl:variable name="SegIds-B" select="seg[matches(@xml:id, 'start')][not(following-sibling::seg[matches(@xml:id, 'end')])]/@xml:id" as="attribute()+"/>
             <xsl:for-each select="$Segs-case-B"> 
                 <xsl:variable name="Seg-Id-B" select="current()/@xml:id" as="attribute()"/> <xsl:apply-templates select="$currentTemplateNode/node()[not(preceding-sibling::seg[@xml:id = $Seg-Id-B])]"/></xsl:for-each>
           </xsl:when>
           <!--Test 3 -->
           <xsl:when test="seg[matches(@xml:id, 'end')][not(preceding-sibling::seg[matches(@xml:id, 'start')])]">
               <xsl:variable name="Segs-case-C" select="seg[matches(@xml:id, 'end')][not(preceding-sibling::seg[matches(@xml:id, 'start')])]" as="element()+"/>
               <xsl:variable name="SegIds-C" select="seg[matches(@xml:id, 'end')][not(preceding-sibling::seg[matches(@xml:id, 'start')])]/@xml:id" as="attribute()+"/>
             <xsl:for-each select="$Segs-case-C"> 
                 <xsl:variable name="Seg-Id-C" select="current()/@xml:id" as="attribute()"/>
                 <xsl:apply-templates select="$currentTemplateNode/node()[not(following-sibling::seg[@xml:id = $Seg-Id-C])]"/></xsl:for-each> 
           </xsl:when>  
           <xsl:otherwise>
               <xsl:apply-templates/>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:template>
    <xsl:template match="seg">
        <xsl:choose>
            <!--Test 1 -->
            <xsl:when test="matches(@xml:id, 'start') and substring-before(@xml:id, '_start') = substring-before(following-sibling::seg[1]/@xml:id, '_end')">
                <seg xml:id="{substring-before(@xml:id, '_start')}">
                    <xsl:apply-templates select="following-sibling::node()[following-sibling::seg[1][matches(@xml:id, 'end')]]"/>
                </seg>
            </xsl:when>
            <!--Test 2 -->
            <xsl:when test="matches(@xml:id, 'start') and not(following-sibling::seg[matches(@xml:id, 'end')])">
                <seg xml:id="{substring-before(@xml:id, '_start')}__Pt1">
                   <xsl:apply-templates select="following-sibling::node()"/> 
                </seg>
            </xsl:when>
            <!--Test 3 -->
            <xsl:when test="matches(@xml:id, 'end') and not(preceding-sibling::seg[matches(@xml:id, 'start')])">
                <seg xml:id="{substring-before(@xml:id, '_end')}__Pt2">
                   <xsl:apply-templates select="preceding-sibling::node()"/> 
                </seg>
            </xsl:when>       
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>


