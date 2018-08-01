<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    exclude-result-prefixes="xs"
    version="3.0">
<!--2018-06-21 ebb updated 2018-08-01: Bridge Edition Constructor Part 2: This second phase begins building the output Bridge editions by consuming the <app> and and <rdg> elements to replace them with <seg> elements that hold the identifiers of their apps and indication of whether they are portions.
   UPDATE: This stylesheet does NOT YET generate the spine file. We're deferring that to a later stage when we know where the <seg> elements turn up in relation to the hierarchy of the edition elements. I am preserving the code attempting to make the spine in this stylesheet in case we need to refer to it. The code attempted to compare when multiple (but not all) rdg witnesses agree with one another so that we could create rdgGrp elements. This code is flawed because it is removing app elements around rdgGrps (easy to fix), but also because it's generating rdgGrp around singleton rdg elements. 
   We are now generating the spine file following the edition files constructed in bridge P5, so that we have the benefit of seeing the <seg> elements where they need to be multiplied (e.g. around paragraph breaks). We can then generate pointers to more precise locations.   
   2018-08-01 ebb: TEST THIS SIMPLIFIED XSLT TO MAKE SURE IT WORKS!!!!
    -->
<xsl:output method="xml" indent="yes"/>  

    <xsl:variable name="bridge-P1Files" as="document-node()+" select="collection('bridge-P1')"/>
    <xsl:variable name="witnesses" as="xs:string+" select="distinct-values($bridge-P1Files//@wit)"/>
  <!--  <xsl:function name="pitt:compareWits" as="xs:boolean">
      <xsl:param name="rdgs"/>
        <xsl:message>This function is firing, and the value of $rdgs is <xsl:value-of select="$rdgs"/></xsl:message>
       <xsl:choose>
           <xsl:when test="not(matches(string-join($rdgs/string()), '&lt;'))">
               <xsl:message>This test checking for rdgs without flattened tags is responding, and the value of $rdgs is <xsl:value-of select="$rdgs"/></xsl:message>
               <xsl:variable name="comparableRdgs" as="element()*" select="for $i in $rdgs return $i[following-sibling::rdg]"/>
               <xsl:message>Here's the value of $comparableRdgs: <xsl:value-of select="$comparableRdgs"/></xsl:message>
               <xsl:variable name="untaggedTestSequence" as="xs:string*"><xsl:for-each select="$comparableRdgs">
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
               <xsl:variable name="comparableTaggedRdgs" as="element()*" select="for $i in $rdgs return $i[following-sibling::rdg]"/>
         <xsl:variable name="taggedTestSequence" as="xs:string*">
               <xsl:for-each select="$comparableTaggedRdgs">
                   <xsl:variable name="nonTagPieces" as="xs:string+">
                       <xsl:value-of select="tokenize(current(), '&lt;[^/]+?/&gt;')"/> 
                   </xsl:variable>
                   <xsl:variable name="textMissingTags" as="xs:string" select="string-join($nonTagPieces, ' ')"/>
                   <xsl:value-of select="normalize-space($textMissingTags) eq normalize-space(string-join(tokenize(current()/following-sibling::rdg[1], '&lt;[^/]+?/&gt;'), ' '))"/>     
               </xsl:for-each> 
         </xsl:variable>
                   <xsl:variable name="taggedTestResults" as="xs:string" select="string-join($taggedTestSequence)"/>
                   <xsl:variable name="taggedBooleanResult" as="xs:boolean" select="not(contains($taggedTestResults, 'false'))"/>
                   <xsl:message>Test result for TAGGED Text Test Sequence: Are the strings all matching?<xsl:value-of select="$taggedBooleanResult"/></xsl:message>
                   <xsl:value-of select="$taggedBooleanResult"/>                
           </xsl:otherwise>
       </xsl:choose>
   </xsl:function> -->
    
   <xsl:template match="/">
       <xsl:for-each select="$bridge-P1Files//TEI"> 
           <xsl:variable name="currentP1File" as="element()" select="current()"/>
           <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
  <!-- DEFER TO LATER STAGE AFTER P5: <xsl:result-document method="xml" indent="yes" href="standoff_Spine/spine_{$chunk}.xml">
               <TEI xml:id="spine-{$chunk}">
                   <teiHeader>
                       <fileDesc>
                           <titleStmt>
                               <title>Standoff Spine: Collation unit <xsl:value-of select="$chunk"/></title>
                           </titleStmt>
                           <xsl:copy-of select="descendant::publicationStmt"/>
                           <xsl:copy-of select="descendant::sourceDesc"/>
                       </fileDesc>
                   </teiHeader>
                   <text>
                       <body> 
                           <ab type="alignmentChunk" xml:id="spine_{$chunk}">
                               <xsl:apply-templates  select="descendant::app" mode="spinePtrs">
                                   <xsl:with-param name="chunk" select="$chunk" tunnel="yes"></xsl:with-param>
                               </xsl:apply-templates>
                               
                           </ab>
                       </body>
                       
                   </text>
               </TEI> 
           </xsl:result-document>-->
       
           
         <xsl:for-each select="$witnesses">

             <xsl:result-document method="xml" indent="yes" href="bridge-P2/bridge-P2_{substring-after(current(), '#')}_{$chunk}.xml">
                 <TEI xml:id="{substring-after(current(), '#')}_{$chunk}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Bridge Phase 2: Witness <xsl:value-of select="substring-after(current(), '#')"/>, Collation unit <xsl:value-of select="$chunk"/></title>
                    </titleStmt>
                    <xsl:copy-of select="$currentP1File//publicationStmt"/>
                    <xsl:copy-of select="$currentP1File//sourceDesc"/>
                </fileDesc>
            </teiHeader>
            <text>
           <body> 
        <ab type="alignmentChunk" xml:id="{$chunk}">
            <xsl:apply-templates  select="$currentP1File//app">
                <xsl:with-param name="currentWit" as="xs:string" select="current()" tunnel="yes"/>
            </xsl:apply-templates>
                
               </ab>
           </body>
                    
            </text>
        </TEI>
           </xsl:result-document>
         </xsl:for-each>
        </xsl:for-each>
  
    </xsl:template> 
  
<!--<xsl:template match="app">
    <xsl:param name="currentWit" tunnel="yes"/>
    <xsl:param name="rdgs" select="rdg" as="element()+" tunnel="yes"/>
    <xsl:message>From the template on app: the currentWit: <xsl:value-of select="$currentWit"/> And the parameter rdgs: <xsl:value-of select="$rdgs"/></xsl:message>
  <xsl:choose>
      <xsl:when test="@type='invariant'">
          <xsl:apply-templates select="rdg[@wit=$currentWit]" mode="invariant"><xsl:with-param name="currentWit" select="$currentWit" as="xs:string"  tunnel="yes"/></xsl:apply-templates>
      </xsl:when>
      <xsl:when test="count($rdgs) eq 4">
      <xsl:choose><xsl:when test="contains(string(pitt:compareWits($rdgs)), 'false')">  <xsl:message>Strings do not match! </xsl:message>
          <xsl:apply-templates select="rdg[@wit=$currentWit]" mode="variant">
          <xsl:with-param name="currentWit" select="$currentWit" as="xs:string" tunnel="yes"/>
      </xsl:apply-templates>
      </xsl:when>
          <xsl:when test="contains(string(pitt:compareWits($rdgs)), 'true')">
              <xsl:message>Strings Match! but we're missing a witness.</xsl:message>
              <xsl:apply-templates select="rdg[@wit=$currentWit]" mode="invariant-MissingWit">
                  <xsl:with-param name="currentWit" select="$currentWit" as="xs:string" tunnel="yes"/>
              </xsl:apply-templates>
      </xsl:when>
      </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates select="rdg[@wit=$currentWit]" mode="variant">
              <xsl:with-param name="currentWit" select="$currentWit" as="xs:string" tunnel="yes"/>
          </xsl:apply-templates>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>-->
    <xsl:template match="rdg" mode="invariant">
        <xsl:param name="currentWit" tunnel="yes"/>
        <xsl:apply-templates select=".[@wit=$currentWit]"/>
    </xsl:template>
    <xsl:template match="rdg" mode="variant">
        <xsl:param name="currentWit" tunnel="yes"/>
        <xsl:if test=".[@wit=$currentWit]"> <seg xml:id="{parent::app/@xml:id}-{substring-after($currentWit, '#')}_start"/>
            <xsl:apply-templates select=".[@wit=$currentWit]"/><seg xml:id="{parent::app/@xml:id}-{substring-after($currentWit, '#')}_end"/> </xsl:if>
    </xsl:template>
   <!-- <xsl:template match="rdg" mode="invariant-MissingWit">
        <xsl:param name="currentWit" tunnel="yes"/>
        <xsl:message>found a missing witness! but the others agree.</xsl:message>
        <xsl:if test=".[@wit=$currentWit]"><seg type="invariant-MissingWit" xml:id="{parent::app/@xml:id}-{substring-after($currentWit, '#')}_start"/><xsl:apply-templates select=".[@wit=$currentWit]"/><seg xml:id="{parent::app/@xml:id}-{substring-after($currentWit, '#')}_end"/></xsl:if>
    </xsl:template>
    <xsl:template match="app" mode="spinePtrs">
        <xsl:param name="rdgs" select="rdg" as="element()+" tunnel="yes"/>
        <xsl:param name="chunk" tunnel="yes"/>
        <xsl:choose><xsl:when test="@type"> <app type="{@type}" xml:id="{@xml:id}"><xsl:apply-templates mode="spinePtrs"/></app></xsl:when>
            <xsl:when test="contains(string(pitt:compareWits($rdgs)), 'true')">
                <rdgGrp type="invariant">
                   <xsl:apply-templates mode="spinePtrs"/> 
                </rdgGrp>
            </xsl:when>
            <xsl:otherwise>
                <app xml:id="{@xml:id}"><xsl:apply-templates select="rdg" mode="spinePtrs">
                    <xsl:with-param name="chunk" select="$chunk" tunnel="yes"></xsl:with-param>
                </xsl:apply-templates></app>
            </xsl:otherwise>
        </xsl:choose>
      </xsl:template>
    <xsl:template match="rdg" mode="spinePtrs">
        <xsl:param name="chunk" tunnel="yes"/>
        <rdg wit="{@wit}"><ref><ptr target="https://github.com/PghFrankenstein/Pittsburgh_Frankenstein/tree/Text_Processing/collateXPrep/bridge-P5/P5-{substring-after(@wit, '#')}_{$chunk}.xml#{parent::app/@xml:id}-{substring-after(@wit, '#')}"/>
            <pitt:line_text><xsl:value-of select="string-join(tokenize(., '&lt;[^/]+?/&gt;'))"/></pitt:line_text>
        <pitt:resolved_text>
            <!-\-2018-06-21 ebb: This particular destination doesn't exist quite yet, and will quite likely need to be modified. -\->
            <xsl:variable name="pointerFilePath"> <xsl:text>https://github.com/PghFrankenstein/Pittsburgh_Frankenstein/tree/Text_Processing/collateXPrep/bridge-P5/</xsl:text><xsl:value-of select="substring-after(@wit, '#')"/><xsl:text>_</xsl:text><xsl:value-of select="$chunk"/><xsl:text>.xml</xsl:text>
            </xsl:variable>
            <xsl:variable name="pointerHead">
                <xsl:text>P5-</xsl:text>
                <xsl:value-of select="substring-after(@wit, '#')"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="$chunk"/>
                <xsl:text>.xml#</xsl:text>
                <xsl:value-of select="parent::app/@xml:id"/><xsl:text>-</xsl:text>
                <xsl:value-of select="substring-after(@wit, '#')"/>
            </xsl:variable>
            <xsl:variable name="testResolve" as="xs:string">
               <xsl:value-of select="$pointerFilePath//$pointerHead"/>
                <!-\-<xsl:choose> <xsl:when test="doc($pointerFilePath)//$pointerHead">
                   <xsl:text>The link resolves.</xsl:text>
                </xsl:when>
               <xsl:otherwise>
                   <xsl:text>The link doesn't resolve.</xsl:text>
               </xsl:otherwise>
               </xsl:choose>-\->
            </xsl:variable>
            <!-\-<xsl:variable name="pointedDoc" select="doc($pointerFilePath)" as="document-node()"/>-\->
         <!-\-   <xsl:evaluate xpath="doc($pointerFilePath)//$pointerHead"/>
            </xsl:variable> -\->
            <xsl:value-of select="$testResolve"/>
        </pitt:resolved_text>
        </ref>
        
        </rdg>
    </xsl:template>-->
    
</xsl:stylesheet>