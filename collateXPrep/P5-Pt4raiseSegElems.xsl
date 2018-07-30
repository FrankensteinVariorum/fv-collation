<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="no"/>
    <!--2018-07-29 ebb: REDO THIS so it follows as a third stage after you've inserted end-markers for the fragmented <seg> elements. 
        This stylesheet works to raise "trojan
	elements" using a left-to-right sibling traversal method as developed by Michael Sperberg-McQueen. I am adapting it to raise seg markers to elements that break across hierarchies: This stylesheet will break these seg elements into two parts marked with attributes as part="I" and part="F".  -->

    <xsl:variable name="novel-coll"
        as="document-node()+"
        select="collection('bridge-P5B-C10')"/>    
    
    
    <!--* In all modes, do a shallow copy, suppress namespace nodes,
	* and recur in default (unnamed) mode. *-->
 <xsl:template match="@* | node()" mode="#all">
      <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
<xsl:mode on-no-match="shallow-copy"/>

  
   
   <xsl:template match="/">
       <xsl:for-each select="$novel-coll//TEI">
           <xsl:variable name="filename">              <xsl:value-of select="tokenize(base-uri(), '/')[last()]"/>
           </xsl:variable>
           <xsl:variable name="chunk"
			 as="xs:string"
			 select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/> 
           <xsl:result-document method="xml"
				indent="yes"
				href="bridge-P5/{$filename}">
               <TEI>
		   <xsl:copy-of select="descendant::teiHeader" copy-namespaces="no"/>
		   <text>
		       <body>
			   <xsl:apply-templates select="descendant::div[@type='collation']"/>
		       </body>
		   </text>
               </TEI>
           </xsl:result-document>
       </xsl:for-each>
       
   </xsl:template>
     
    <xsl:template match="div[@type='collation']">
       <div type="collation"> 
           <xsl:apply-templates select="child::node()[1]" mode="shallow-to-deep"/>
       </div>
    </xsl:template>  
    <xsl:template match="seg[@th:sID]" mode="shallow-to-deep">
        <!--   <xsl:variable name="ns" select="namespace-uri()"/>-->
        <!--<xsl:variable name="ln" as="xs:string" select="local-name()"/> ebb: Note that local-name() is used for retrieving the part of the name that isn't namespaced. That doesn't apply to the Frankenstein data. -->      
        <xsl:variable name="ln" as="xs:string" select="name()"/>
        <xsl:variable name="sID" as="xs:string" select="@th:sID"/>
        
        <!--* 1: handle this element *-->
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@* except @th:sID"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="@th:sID"/>
            </xsl:attribute>
            <xsl:apply-templates select="following-sibling::node()[1]" mode="shallow-to-deep">
            </xsl:apply-templates>
        </xsl:copy>       
        <!--* 2: continue after this element *-->
        <xsl:apply-templates select="following-sibling::seg
            [@th:eID= $sID 
            and name()=$ln]
            /following-sibling::node()[1]"
            mode="shallow-to-deep">
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="text()
        | comment() 
        | processing-instruction 
        | *[not(@th:sID) and not(@th:eID)]"
        mode="shallow-to-deep">
        <xsl:copy-of select="." copy-namespaces="no"/>
        <xsl:apply-templates 
            select="following-sibling::node()[1]"
            mode="shallow-to-deep"/>
    </xsl:template>
    <xsl:template match="seg[@th:eID]" mode="shallow-to-deep">
        <!--* No action necessary *-->
        <!--* We do NOT recur to our right.
        * We leave it to our parent to do that.
        *-->           
    </xsl:template>  
   
        </xsl:stylesheet>
