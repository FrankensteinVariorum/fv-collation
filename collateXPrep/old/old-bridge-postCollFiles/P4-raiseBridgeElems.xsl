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
    <!--2018-07-07 ebb: This stylesheet works to raise "trojan
	elements" from the inside out, this time over a collection
	of Frankenstein files output from collation. It also adapts
	djb's function to process an element node rather than a
	document node in memory to perform its recursive
	processing. -->
    <!--2018-07-23 ebb: I've updated this stylesheet to work with the th:raise function as expressed in raise_deep.xsl. -->
    <xsl:variable name="novel-coll"
        as="document-node()+"
        select="collection('bridge-P3')"/>    
    <!--* Experimental:  try adding a key *-->
  <!--2018-07-23 ebb: This isn't working, and I'm not sure why not. This stylesheet has the recursion function run over a container element, rather than an  entire document node, and I think that must be the problem. Commenting it out for now.   <xsl:key name="start-markers" match="$C10-coll//*[@th:sID]" use="@th:sID"/>
    <xsl:key name="end-markers" match="$C10-coll//*[@th:eID]" use="@th:eID"/>-->
    
    <!--* In all modes, do a shallow copy, suppress namespace nodes,
	* and recur in default (unnamed) mode. *-->
    <xsl:template match="@* | node()" mode="#all">
      <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--* th:raise(.):  raise all innermost elements within the container element this time passed as parameter *-->
   <xsl:function name="th:raise">
       <xsl:param name="input" as="element()"/>
       <xsl:message>raise() called with <xsl:value-of select="count($input//*)"/>-element document (<xsl:value-of select="count($input//*[@th:sID])"/> Trojan pairs)</xsl:message>
       <xsl:choose>
           <xsl:when test="exists($input//*[@th:sID eq following-sibling::*[@th:eID][1]/@th:eID])">
               <xsl:variable name="result" as="element()">
                   <div type="collation">
                       <xsl:apply-templates select="$input" mode="loop"/>                            
                   </div>
               </xsl:variable>
               <xsl:sequence select="th:raise($result)"/>
           </xsl:when>
           <xsl:otherwise>
               <!--* We have no more work to do, return the input unchanged. *-->
               <xsl:message>raise() returning.</xsl:message>
               <xsl:sequence select="$input"/>
           </xsl:otherwise>
       </xsl:choose>
   </xsl:function>
   
   <xsl:template match="/">
       <xsl:for-each select="$novel-coll//TEI">
           <xsl:variable name="filename">              <xsl:text>P4-</xsl:text><xsl:value-of select="tokenize(base-uri(), '/')[last()] ! substring-after(., 'P3-')"/>
           </xsl:variable>
           <xsl:variable name="chunk"
			 as="xs:string"
			 select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/> 
           <xsl:result-document method="xml"
				indent="yes"
				href="bridge-P4/{$filename}">
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
               <xsl:copy-of select="descendant::publicationStmt" copy-namespaces="no"/>
               <xsl:copy-of select="descendant::sourceDesc" copy-namespaces="no"/>
	   </fileDesc>
       </teiHeader>
   </xsl:template>
   
   <xsl:template match="titleStmt/title">
       <title>
           <xsl:text>Bridge Phase 4:</xsl:text><xsl:value-of select="tokenize(., ':')[last()]"/>
       </title>
   </xsl:template>
    <!--* On the input container element node, call th:raise() *-->
   <xsl:template match="div[@type='collation']">
       <xsl:sequence select="th:raise(.)"/>
   </xsl:template>
    <!--* Loop mode (applies to container element only). *-->
    <!--* Loop mode for container element:  just apply templates in default unnamed mode. *-->  
   <xsl:template match="div[@type='collation']" mode="loop">
       <xsl:apply-templates/>
   </xsl:template>
   
    <xsl:template match="*[@th:sID eq
        following-sibling::*[@th:eID][1]/@th:eID]">
       <xsl:variable name="currNode" select="current()" as="element()"/>
       <xsl:variable name="currMarker" select="@th:sID" as="xs:string"/>
       <xsl:element name="{name()}">
           <xsl:copy-of select="@* except @th:sID"/>
           <xsl:attribute name="xml:id">
               <xsl:value-of select="@th:sID"/>
           </xsl:attribute>
           <xsl:variable name="end-marker" as="element()" select="following-sibling::*[@th:eID = current()/@th:sID]"/>
           <xsl:copy-of select="following-sibling::node()[. &lt;&lt; $end-marker]"/>
       </xsl:element>
   </xsl:template>

   <!--suppressing nodes that are being reconstructed, including the old end marker. -->
    <xsl:template
        match="node()[preceding-sibling::*[@th:sID][1]/@th:sID eq following-sibling::*[@th:eID][1]/@th:eID]"/>
   
    <xsl:template match="*[@th:eID eq preceding-sibling::*[@th:sID][1]/@th:sID]"/>
        </xsl:stylesheet>
