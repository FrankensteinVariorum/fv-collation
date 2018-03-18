<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
  
  <!--2017-10-08 ebb: This is the first of a "pipeline" series of 3 stylesheets designed to be run in sequence, with the goal of moving left_margin zone elements to sit in sequence next to their insertion points. We need a pipeline process because there are left_margin zone insertions indicated *inside* two left_margin zones, leading these to be improperly processed if we attempt the migration of these zones in one stylesheet process. (See GitHub issue of 2017-09-26 describing the problem: https://github.com/ebeshero/Pittsburgh_Frankenstein/issues/29 ).
  FIRST, with this transformation, we only move the left_margin zones that are to be inserted into other left_margin zones.
  -->
   
  <xsl:template match="zone[@type='left_margin']//*[@xml:id = //zone[@type='left_margin']/substring-after(@corresp, '#')]">
    <xsl:variable name="leftMarginMatch" select="//zone[@type='left_margin'][substring-after(@corresp, '#') = current()/@xml:id]"/>
  <xsl:copy-of select="current()"/>
    <xsl:copy-of select="$leftMarginMatch"/>
</xsl:template>

<!--2017-10-08 ebb: I'm moving this to Pipeline stylesheet 2: 
    <xsl:template match="zone[not(@type='left_margin')]//*[@xml:id = //zone[@type='left_margin']/substring-after(@corresp, '#')]">
  <xsl:variable name="leftMarginMatch" select="//zone[@type='left_margin'][substring-after(@corresp, '#') = current()/@xml:id]"/>
      <xsl:copy-of select="current()"/>
<xsl:copy-of select="$leftMarginMatch"/>
  </xsl:template>  -->
    
  <!--<xsl:template match="zone[@type='left_margin'][@corresp][not(ancestor::zone[@type='left_margin'])]"/>-->
 
  
  <!--2017-09-26 ebb: PROBLEM: This is eliminating 2 zone elements in c56. There are 172 left margin zones, and 170 in the output. -->
    <!--2017-09-25 ebb: Activating this would remove all the ?xml-model processing instruction lines at the head of each page of code in the sga file.
  <xsl:template match="processing-instruction('xml-model')"/>
     -->
    

</xsl:stylesheet>