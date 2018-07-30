<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
  exclude-result-prefixes="xs th"
  version="3.0">
  <!--2018-07-30 ebb: Run this with Saxon at command line to raise paired seg markers. Rewrite so we don't need the file dependency on marker types. -->
  <!--* right-sibling/raise.xsl:  translate a document with start-
      * and end-markers into conventional XML
      *-->

  <!--* Revision history:
      * 2018-07-20 : CMSMcQ : add instrument parameter
      * 2018-07-16 : CMSMcQ : accept anaplus value for th-style,
      *    recover better from duplicate IDs      
      * 2018-07-11 : CMSMcQ : copy-namespaces=no, correct end-marker test 
      * 2018-07-10 : CMSMcQ : make this file by stripping down 
      *     uyghur.ittc.ku.edu/lib/shallow-to-deep.xsl.
      *     Use library functions for marker recognition.
      *-->
  
  <!--*
    * 
    * Input:  XML document.
    * 
    * Parameters:  
    *
    *   debug:  'yes' or 'no'
    * 
    *   th-style: keyword 'th', 'ana', or 'xmlid':
    *         'th' uses @th:sID and @th:eID 
    *         'ana' uses @ana=start and @ana=end
    *         'xmlid' uses @xml:id with values ending _start, _end
    *
    * 
    * Output:  XML document with virtual elements raised (made
    * into content elements).
    *-->

  
  <!--****************************************************************
      * 0 Setup (parameters, global variables, ...)
      ****************************************************************-->
  <xsl:import href="lib/marker-recognition.xsl"/>

  <!--* What kind of Trojan-Horse elements are we merging? *-->
  <!--* Expected values are 'th' for @th:sID and @th:eID,
      * 'ana' for @ana=start|end
      * 'xmlid' for @xml:id matching (_start|_end)$
      *-->
  <xsl:param name="th-style" select=" 'th' " static="yes"/>

  <!--* debug:  issue debugging messages?  yes or no  *-->
  <xsl:param name="debug" as="xs:string" select=" 'no' " static="yes"/>

  <!--* instrument:  issue instrumentation messages? yes or no *-->
  <!--* Instrumentation messages include things like monitoring
      * size of various node sets; we turn off for timing, on for
      * diagnostics and sometimes for debugging. *-->
  <xsl:param name="instrument" as="xs:string" select=" 'no' " static="yes"/>

  <xsl:output indent="no"/>

  
  <!--****************************************************************
      * 1 Identity transform (default behavior outside the
      * container)
      ****************************************************************-->

  <xsl:mode on-no-match="shallow-copy"/>

 <xsl:template name="shallow-copy">
   <xsl:copy copy-namespaces="no">
     <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
 </xsl:template>

 <!--* special rule for root *-->
 <xsl:template match="/*" priority="100" mode="abandoned">
   <xsl:element name="{name()}" namespace="{namespace-uri()}">
     <xsl:copy-of select="namespace::*
			  [not(. = 'http://www.blackmesatech.com/2017/nss/trojan-horse')
			  or not($th-style='th')]"/>
     <xsl:copy-of select="@*"/>
     <!--* ah.  The standard error.
	 <xsl:apply-templates select="node()" mode="raising"/>
	 *-->
     <xsl:apply-templates select="node()[1]" mode="raising"/>
     </xsl:element>
 </xsl:template>
 
  
  <!--****************************************************************
      * 2 Shifting to shallow-to-deep mode / Container element
      *-->
  <!--* When we hit the container element, shift to shallow-to-deep
      * mode.  We know it's the container element, because it has
      * at least one marker element as a child.
      *-->
  
  <xsl:template match="*[*[th:is-marker(.)]]">
    <xsl:if test="$debug = 'yes' ">
      <xsl:message>Shifting to shallow-to-deep on <xsl:value-of
      select="name()"/></xsl:message>
    </xsl:if>    
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="raising" select="child::node()[1]"/>
    </xsl:copy>    
  </xsl:template>


  <!--****************************************************************
      * 3 Start-marker:  make an element and carry on
      *-->

  <xsl:template match="*[th:is-start-marker(.)]" mode="raising">
    
    <!--* 1: handle this element *-->
    
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@* except @th:*" use-when=" $th-style='th' "/>
      <xsl:attribute name="xml:id" select="@th:sID" use-when=" $th-style=('th') "/>
      <xsl:copy-of select="@* except (@ana, @loc)" use-when=" $th-style=('ana', 'anaplus') "/>
      <xsl:attribute name="xml:id" select="@loc" use-when=" $th-style=('ana', 'anaplus') "/>
      
      <xsl:apply-templates select="following-sibling::node()[1]"
			   mode="raising">
      </xsl:apply-templates>
    </xsl:copy>
    
    <!--* 2: continue after this element *-->
    <xsl:apply-templates select="th:matching-end-marker(.)
				 /following-sibling::node()[1]"
			 mode="raising">
    </xsl:apply-templates>
  </xsl:template>


  <!--****************************************************************
      * 4 End-markers
      *-->

  <xsl:template match="*[th:is-end-marker(.)]" mode="raising">
    
    <!--* no action necessary *-->
    <!--* we do NOT recur to our right.  We leave it to our parent to do 
	that. *-->
    
  </xsl:template>

  
  <!--****************************************************************
      * 5 Other elements, in shallow-to-deep mode 
      *-->
  
  <!--* If these contain Trojan Horse descendants, they need to
      * be processed recursively; otherwise just copy
      * Oddly this is almost identical to what deep-to-shallow does
      *-->  
  <xsl:template match="*[not(th:is-marker(.))]"
		mode="raising">
    <xsl:if test="$debug = 'yes' ">
      <xsl:message>Non-marker in shallow-to-deep: <xsl:value-of select="name()"/> </xsl:message>
    </xsl:if>
    <xsl:apply-templates select="."/>
    <!--* and recur to right sibling *-->
    <xsl:apply-templates select="following-sibling::node()[1]"
			 mode="raising"/>
  </xsl:template>
  
  <!--****************************************************************
      * 6 Other node types, in shallow-to-deep mode 
      *-->
  <xsl:template match="comment() | processing-instruction()"
		mode="raising">
    <xsl:copy/>
    <xsl:apply-templates select="following-sibling::node()[1]"
			 mode="raising"/>
  </xsl:template>
  
  <xsl:template match="text()"
		mode="raising">
    <xsl:copy/>
    <xsl:apply-templates select="following-sibling::node()[1]"
			 mode="raising"/>
  </xsl:template>

  <!--****************************************************************
      * 7 Functions
      *-->
  <xsl:function name="th:matching-end-marker" as="element()">
    <xsl:param name="this" as="element()"/>
    <xsl:variable name="ns" select="namespace-uri($this)"/>
    <xsl:variable name="gi" select="local-name($this)"/>
    <xsl:variable name="ID" select="$this/@th:sID" use-when="$th-style='th'"/>
    <xsl:variable name="ID" select="$this/@loc" use-when="$th-style=('ana', 'anaplus')"/>

    
    <xsl:if test="$debug = 'yes' ">
	<xsl:message>matching-end-marker() called for <xsl:value-of
	select="concat($gi, ' element with ID=', $ID)"/>,
	viz: <xsl:copy-of select="$this"/></xsl:message>
	<xsl:message>Results: 
	<xsl:sequence select="$this/following-sibling::*
			      [@loc = $ID
			      and th:is-end-marker(.)
			      and namespace-uri()=$ns
			      and local-name()=$gi]"
		      use-when="$th-style=('ana', 'anaplus')"/></xsl:message>
    </xsl:if>
    
    <xsl:sequence select="$this/following-sibling::*[
			         @th:eID = $ID 
				 and namespace-uri()=$ns
				 and local-name()=$gi][1]"
		  use-when="$th-style='th'"/>
    <xsl:sequence select="$this/following-sibling::*
			  [@loc = $ID
			  and th:is-end-marker(.)
			  and namespace-uri()=$ns
			  and local-name()=$gi][1]"
		  use-when="$th-style=('ana', 'anaplus')"/>

  </xsl:function>
  
</xsl:stylesheet>
