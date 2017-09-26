<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- -->
  
  <xsl:template match="*[@xml:id = //zone[@type='left_margin']/substring-after(@corresp, '#')]">
      <xsl:copy-of select="current()"/><xsl:copy-of select="//zone[@type='left_margin'][substring-after(@corresp, '#') = current()/@xml:id]"/>
  </xsl:template>  
    
  <xsl:template match="zone[@type='left_margin'][@corresp]"/><!--2017-09-26 ebb: PROBLEM: This is eliminating 2 zone elements. There are 172 left margin zones, and 170 in the output. -->
    <!--2017-09-25 ebb: Activating this would remove all the ?xml-model processing instruction lines at the head of each page of code in the sga file.
  <xsl:template match="processing-instruction('xml-model')"/>
     -->
    

</xsl:stylesheet>