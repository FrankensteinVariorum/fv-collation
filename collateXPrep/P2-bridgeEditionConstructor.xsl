<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-21 ebb: Bridge Edition Constructor Part 2: This second phase consumes the <app> and and <rdg> elements to replace them with <seg> elements that hold the identifiers of their apps and indication of whether they are portions.-->
<xsl:output method="xml" indent="yes"/>    
    <xsl:variable name="bridge-P1Files" as="document-node()+" select="collection('bridge-P1')"/>
    <xsl:variable name="witnesses" as="xs:string+" select="distinct-values($bridge-P1Files//@wit)"/>
    <xsl:function name="pitt:compareWits" as="xs:boolean">
      <xsl:param name="rdgs"/>
        <xsl:message>This function is firing, and the value of $rdgs is <xsl:value-of select="$rdgs"/></xsl:message>
       <xsl:choose>
           <xsl:when test="not(matches(string-join($rdgs/string()), '&lt;'))">
               <xsl:message>This test checking for rdgs without flattened tags, is responding, and the value of $rdgs is <xsl:value-of select="$rdgs"/></xsl:message>
               <xsl:variable name="comparableRdgs" as="element()+" select="for $i in $rdgs return $i[following-sibling::rdg]"/>
               <xsl:message>Here's the value of $comparableRdgs: <xsl:value-of select="$comparableRdgs"/></xsl:message>
               <xsl:variable name="untaggedTestSequence" as="xs:string+"><xsl:for-each select="$comparableRdgs">
                   <xsl:message>The for-each loop in this function is running over this value: <xsl:value-of select="current()"/></xsl:message>
    <xsl:value-of select="current()/string() eq current()/following-sibling::rdg[1]/string()"/>
</xsl:for-each>   </xsl:variable>  
               <xsl:variable name="testResults" as="xs:string" select="string-join($untaggedTestSequence)"/>
               <xsl:variable name="booleanResult" as="xs:boolean" select="not(contains($testResults, 'false'))"/>
               <xsl:message>Test result for Untagged Text Test Sequence: Are the strings all matching?<xsl:value-of select="$booleanResult"/></xsl:message>
               <xsl:value-of select="$booleanResult"/>
           </xsl:when>
           <xsl:otherwise>
               <xsl:message>Now we're seeing FLATTENED TAGS!</xsl:message>
               <xsl:variable name="comparableTaggedRdgs" as="element()+" select="for $i in $rdgs return $i[following-sibling::rdg]"/>
         <xsl:variable name="taggedTestSequence" as="xs:string+">
               <xsl:for-each select="$comparableTaggedRdgs">
                   <xsl:variable name="nonTagPieces" as="xs:string+">
                       <xsl:value-of select="tokenize(current(), '&lt;.+?/&gt;')"/> 
                   </xsl:variable>
                   <xsl:variable name="textMissingTags" as="xs:string" select="string-join($nonTagPieces, ' ')"/>
                   <xsl:value-of select="normalize-space($textMissingTags) eq normalize-space(string-join(tokenize(current()/following-sibling::rdg[1], '&lt;.+?/&gt;'), ' '))"/>     
               </xsl:for-each> 
         </xsl:variable>
                   <xsl:variable name="taggedTestResults" as="xs:string" select="string-join($taggedTestSequence)"/>
                   <xsl:variable name="taggedBooleanResult" as="xs:boolean" select="not(contains($taggedTestResults, 'false'))"/>
                   <xsl:message>Test result for TAGGED Text Test Sequence: Are the strings all matching?<xsl:value-of select="$taggedBooleanResult"/></xsl:message>
                   <xsl:value-of select="$taggedBooleanResult"/>                
           </xsl:otherwise>
       </xsl:choose>
   </xsl:function> 
    
   <xsl:template match="/">    
       <xsl:for-each select="$bridge-P1Files//TEI"> 
           <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>
           <xsl:result-document method="xml" indent="yes" href="bridge-P2/bridge-P2_{$chunk}.xml">
           <TEI xml:id="bridgeP2-{$chunk}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Bridge Phase 2: Collation unit <xsl:value-of select="$chunk"/></title>
                    </titleStmt>
                    <publicationStmt>
                        <authority>Frankenstein Variorum Project</authority>
                        <date>2018</date>
                        <availability>
                            <licence>Distributed under a Creative Commons
                                Attribution-ShareAlike 3.0 Unported License</licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Produced from collation output:<xsl:value-of select="./../comment()"/></p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
           <body> 
        <ab type="alignmentChunk" xml:id="{$chunk}">
            <xsl:apply-templates  select="descendant::app"/>
                
               </ab>
           </body>
                    
            </text>
        </TEI>
           </xsl:result-document>
        </xsl:for-each>
  
    </xsl:template> 
  
<xsl:template match="app">
    <xsl:param name="rdgs" select="rdg" as="element()+" tunnel="yes"/>
    <xsl:message>From the template on app: I'm the parameter rdgs: <xsl:value-of select="$rdgs"/></xsl:message>
  <xsl:choose>
      <xsl:when test="@type='invariant'">
          <xsl:apply-templates mode="invariant"/>
      </xsl:when>
      <xsl:when test="count($rdgs) eq 4">
      <xsl:choose><xsl:when test="contains(string(pitt:compareWits($rdgs)), 'false')">  <xsl:message>Strings do not match! </xsl:message>
      <xsl:apply-templates mode="variant"/>
      </xsl:when>
          <xsl:when test="contains(string(pitt:compareWits($rdgs)), 'true')">
          <rdgGrp type="invariant">
              <xsl:message>Strings Match! but we're missing a witness.</xsl:message>
              <xsl:apply-templates mode="invariant-MissingWit"/></rdgGrp>
      </xsl:when>
      </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates mode="variant"/>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    <xsl:template match="rdg" mode="invariant">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="rdg" mode="variant">
      <seg xml:id="{parent::app/@xml:id}-{@wit}_start"/>
        <xsl:apply-templates/><seg xml:id="{parent::app/@xml:id}-{@wit}_end"/> 
    </xsl:template>
    <xsl:template match="rdg" mode="invariant-MissingWit">
        <xsl:message>found a missing witness! but the others agree.</xsl:message>
        <seg xml:id="{parent::app/@xml:id}-{@wit}_start"/><xsl:apply-templates/><seg xml:id="{parent::app/@xml:id}-{@wit}_end"/>
    </xsl:template>
</xsl:stylesheet>