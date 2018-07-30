<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:mith="http://mith.umd.edu/sc/ns1#"
    xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
    exclude-result-prefixes="xs th pitt mith" version="3.0">
  <!-- 2018-07-29 ebb: For just now, this is only for C10 files  -->  
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="spine-C10" as="document-node()" select="doc('standoff_Spine/spine_C10.xml')"/> 
    <xsl:variable name="P5_C10_coll" as="document-node()+" select="collection('bridge-P5-C10')"/>
    
    <xsl:template match="app[not(@type='invariant')]">
          <app>
          <xsl:copy-of select="@*"/>
          <xsl:variable name="appID" as="xs:string" select="@xml:id"/>
     <xsl:for-each select="rdg">
    <rdg wit="{@wit}">     <xsl:variable name="currWit" as="xs:string" select="substring-after(@wit, '#')"/>
         <xsl:variable name="currEdition" as="element()" select="$P5_C10_coll//TEI[tokenize(base-uri(), '/')[last()] ! substring-before(., '_') ! substring-after(., 'P5-') eq $currWit]"/>
         
          <xsl:variable name="currEd-Seg" as="element()*" select="$currEdition//seg[substring-before(@xml:id, '-') = $appID]"/>
         
      <xsl:for-each select="$currEd-Seg">
          <ptr target="https://raw.githubusercontent.com/PghFrankenstein/Pittsburgh_Frankenstein/Text_Processing/collateXPrep/bridge-P5-C10/#{current()/@xml:id}"/>
        <!--  <pitt:line_text><xsl:value-of select="current()/normalize-space()"/></pitt:line_text>  
          <pitt:resolved_text><xsl:value-of select="concat('#', current()/@xml:id)"/></pitt:resolved_text>-->
      </xsl:for-each>
             </rdg>
     </xsl:for-each>   </app>
      
        
    </xsl:template>
    <xsl:template match="app[@type='invariant']"/>
    <xsl:template match="rdgGrp"/>
    <xsl:template match="ref"/>
    <xsl:template match="ptr"/>
    <xsl:template match="pitt:line_text"/>
    <xsl:template match="pitt:resolved_text"/>
</xsl:stylesheet>