<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="line">
        <xsl:apply-templates/><lb xml:id="{tokenize(ancestor::surface[1]/@xml:id, '_')[last()]}_l{count(.|preceding::line)}"/>
        <!--2017-07-31 ebb: This is a Piez-ism for counting.-->
    </xsl:template>
    
    <xsl:template match="processing-instruction('xml-model')"/>
     
    

</xsl:stylesheet>