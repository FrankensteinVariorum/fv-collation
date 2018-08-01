<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:mith="http://mith.umd.edu/sc/ns1#"
    xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
    exclude-result-prefixes="xs th pitt mith" version="3.0">

    <!--2018-07-30 updated 2018-08-01 ebb: This file is now designed to generate the first incarnation of the standoff spine of the Frankenstein Variorum. The spine contains URI pointers to specific locations marked by <seg> elements in the edition files made in bridge-P5, and is based on information from the collation process stored in TEI in bridge P1.
        Run with saxon command line over bridge-P1 directory and output to standoff_Spine directory. Output to standoff_Spine directory. 
    2018-08-01 ebb: NOTE: there are no rdgGrp elements in bridge P1 to match this template. We need to consider generating rdgGrp elements to indicate where between 2 - 4 witnesses (but not all five) agree with one another. 
    -->
    <!--2018-07-30 rv: Fixed URLs to TEI files -->
    <!--2018-07-30 rv: Changing rdgGrps back into apps. This eventually should be addressed in previous steps. -->
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:variable name="P5_coll" as="document-node()+" select="collection('bridge-P5')"/>
    
    <xsl:template match="app[not(@type='invariant')]">
          <app>
          <xsl:copy-of select="@*"/>
          <xsl:variable name="appID" as="xs:string" select="@xml:id"/>
     <xsl:for-each select="rdg">
         <xsl:choose>
             <xsl:when test="@wit='#fMS'">
                 <xsl:sequence select="."/>
             </xsl:when>
             <xsl:otherwise>
                 <rdg wit="{@wit}">     <xsl:variable name="currWit" as="xs:string" select="substring-after(@wit, '#')"/>
                     <xsl:variable name="currEdition" as="element()*" select="$P5_coll//TEI[tokenize(base-uri(), '/')[last()] ! substring-before(., '_') ! substring-after(., 'P5-') eq $currWit]"/>
                     
                     <xsl:variable name="currEd-Seg" as="element()*" select="$currEdition//seg[substring-before(@xml:id, '-') = $appID]"/>
                     
                     <xsl:for-each select="$currEd-Seg">
                         <ptr target="https://raw.githubusercontent.com/PghFrankenstein/Pittsburgh_Frankenstein/Text_Processing/collateXPrep/bridge-P5/P5-{$currWit}_C10.xml#{current()/@xml:id}"/>
                         <pitt:line_text><xsl:value-of select="current()/normalize-space()"/></pitt:line_text>  
                         <pitt:resolved_text><xsl:value-of select="concat('#', current()/@xml:id)"/></pitt:resolved_text>
                     </xsl:for-each>
                 </rdg>
             </xsl:otherwise>
         </xsl:choose>
         
     </xsl:for-each>   </app>
      
        
    </xsl:template>
    
    <xsl:template match="rdgGrp"><!--2018-08-01 ebb: NOTE: there are no rdgGrp elements in bridge P1 to match this template. We need to consider generating rdgGrp elements. -->
        <app>            
            <xsl:sequence select="rdg"/>   
        </app>
    </xsl:template>
    
    <xsl:template match="app[@type='invariant']"/>
    <!--<xsl:template match="rdgGrp"/>-->
    <xsl:template match="ref"/>
    <xsl:template match="ptr"/>
    <xsl:template match="pitt:line_text"/>
    <xsl:template match="pitt:resolved_text"/>
</xsl:stylesheet>