<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
  
  <!--2017-10-08 ebb: This is the third of a "pipeline" series of 3 stylesheets designed to be run in sequence, with the goal of moving left_margin zone elements to sit in sequence next to their insertion points. We need a pipeline process because there are left_margin zone insertions indicated *inside* two left_margin zones, leading these to be improperly processed if we attempt the migration of these zones in one stylesheet process. (See comment of 2017-09-26 describing the problem.)
  In this third and LAST stylesheet, we delete the left margin zones sitting at the bottom of each "page" in the document, after they've been copied into place in the main text. 
  -->
  
  <xsl:template match="zone[@type='left_margin'][@corresp][parent::surface]"/>
  
  <!--2017-09-26 ebb: PROBLEM: This is eliminating 2 zone elements in c56. There are 172 left margin zones, and 170 in the output. -->
    <!--2017-09-25 ebb: Activating this would remove all the ?xml-model processing instruction lines at the head of each page of code in the sga file.
  <xsl:template match="processing-instruction('xml-model')"/>
     -->
    

</xsl:stylesheet>