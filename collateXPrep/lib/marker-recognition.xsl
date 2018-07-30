<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:array="http://www.w3.org/2005/xpath-functions/array"
		xmlns:map="http://www.w3.org/2005/xpath-functions/map"
		xmlns:th="http://www.blackmesatech.com/2017/nss/trojan-horse"
		exclude-result-prefixes="#all"
		version="3.0"
		>

  <!--* marker-recognition.xsl:  functions for recognizing markers.
      *-->

  <!--* Revisions:
      * 2018-07-20 : CMSMcQ : cosmetic changes
      * 2018-07-16 : CMSMcQ : accept 'anaplus' as th-style value 
      * 2018-07-10 : CMSMcQ : make file. 
      *-->
  
  <!--* What kind of Trojan-Horse elements are we merging? *-->
  <!--* Expected values are 'th' for @th:sID and @th:eID,
      * 'ana' for @ana=start|end
      * 'anaplus' for @ana=start|end|*_Start|*_End
      * 'xmlid' for @xml:id matching (_start|_end)$ 
      *-->
  <xsl:param name="th-style" select=" 'th' " static="yes"/>
    
  <!--****************************************************************
      * 1.  th:is-start-marker() 
      ****************************************************************-->
  <!--* th:is-start-marker($e as element()):  true iff $e is a start
      * marker we want to process.
      *-->
  <xsl:function name="th:is-start-marker" as="xs:boolean" streamability="inspection">
    <xsl:param name="e" as="element()"/>
    
    <xsl:value-of use-when="$th-style = 'th' "
	select="exists($e/@th:sID)"/>
    <xsl:value-of use-when="$th-style = 'ana' "
	select="$e/@ana='start' "/>
    <xsl:value-of use-when="$th-style = 'anaplus' "
	select="matches($e/@ana, '^start$|_Start$') "/>
    <xsl:value-of use-when="$th-style = 'xmlid' "
	select="ends-with($e/@xml:id,'_start')"/>
    
  </xsl:function>

  <!--****************************************************************
      * 2.  th:is-end-marker() 
      ****************************************************************-->  
  <!--* th:is-end-marker($e as element()):  true iff $e is an end
      * end-marker we want to process.
      *-->
  <xsl:function name="th:is-end-marker" as="xs:boolean"
    streamability="inspection">
    <xsl:param name="e" as="element()"/>
    
    <xsl:value-of use-when="$th-style = 'th' "
	select="exists($e/@th:eID)"/>
    <xsl:value-of use-when="$th-style = 'ana' "
	select="$e/@ana='end' "/>
    <xsl:value-of use-when="$th-style = 'anaplus' "
	select="matches($e/@ana, '^end$|_End$') "/>
    <xsl:value-of use-when="$th-style = 'xmlid' "
		  select="ends-with($e/@xml:id,'_end')"/>
    
  </xsl:function>
    
  <!--****************************************************************
      * 3.  th:is-marker() 
      ****************************************************************-->
  <!--* th:is-marker($e as element()):  true iff $e is a 
      * marker we want to process.
      *-->
  <xsl:function name="th:is-marker" as="xs:boolean" streamability="inspection">
    <xsl:param name="e" as="element()"/>
    
    <xsl:value-of use-when="$th-style = 'th' "
	select="exists($e/@th:sID union $e/@th:eID)"/>
    <xsl:value-of use-when="$th-style = 'ana' "
	select="$e/@ana=('start', 'end')"/>
    <xsl:value-of use-when="$th-style = 'anaplus' "
	select="matches($e/@ana, '^start$|^end$|_Start$|_End$') "/>
    <xsl:value-of use-when="$th-style = 'xmlid' "
	select="matches($e/@xml:id,'(_start|_end)$')"/>
    
  </xsl:function>
    
  <!--****************************************************************
      * 4.  th:coindex() 
      ****************************************************************-->
  <!--* th:coindex($e as element()):  returns value used to co-index
      * $e (if it's a marker) with its pair.
      *-->
  <xsl:function name="th:coindex" as="xs:string" streamability="inspection">
    <xsl:param name="e" as="element()?"/>
    
    <xsl:value-of use-when="$th-style = 'th' "
	select="($e/@th:sID, $e/@th:eID)[1]"/>
    <xsl:value-of use-when="$th-style = ('ana', 'anaplus') "
	select="($e/@loc)"/>
    <xsl:value-of use-when="$th-style = 'xmlid' "
		  select="if (exists($e))
			  then replace($e/@xml:id,'(_start|_end)$','')
			  else ()"/>
    
  </xsl:function>
		
</xsl:stylesheet>
