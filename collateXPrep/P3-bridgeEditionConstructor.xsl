<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="P2-BridgeColl" as="document-node()+" select="collection('bridge-P2-noMS')"/>
    <xsl:variable name="testerDoc" as="document-node()" select="doc('bridge-P2-noMS/f1818_C10.xml')"/>
<!--In Bridge Construction Phase 3, we are up-converting the text-converted tags in the edition files into self-closed elements. -->    
   
    
   <xsl:template match="ab">
       <!--2018-06-22: ebb: We can't use <ab> for top-level structures once we start regenerating <p> elements, since <ab> isn't allowed to contain <p>. -->
       <div type="collation" xml:id="{@xml:id}"><xsl:apply-templates/></div>
   </xsl:template>
   
    <xsl:template match="ab/text()">
        <xsl:analyze-string select="." regex="&lt;[^/]+?&gt;"><!--a start tag of an unflattened element (left as a whole element prior to collation).-->
            <xsl:matching-substring>
                <xsl:variable name="tagContents" select="substring-after(., '&lt;') ! substring-before(., '&gt;')"/>
                <xsl:element name="{tokenize($tagContents, ' ')[1]}">
                    <xsl:attribute name="ana">
                        <xsl:text>startTag</xsl:text>
                    </xsl:attribute>
                    <xsl:for-each select="tokenize($tagContents, ' ')[position() gt 1][contains(., '=')]">
                        <xsl:attribute name="{substring-before(current(), '=')}">
                            <xsl:value-of select="substring-after(current(), '=&#34;') ! substring-before(., '&#34;') "/>
                        </xsl:attribute>
                    </xsl:for-each>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="&lt;/.+?&gt;"><!--an end tag of an unflattened element-->
                    <xsl:matching-substring>
                        <xsl:variable name="tagContents" select="substring-after(., '&lt;/') ! substring-before(., '&gt;')"/>
                        <xsl:element name="{tokenize($tagContents, ' ')[1]}">
                            <xsl:attribute name="ana">
                                <xsl:text>endTag</xsl:text>
                            </xsl:attribute>
                            
                        </xsl:element>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="&lt;[^/]+?__[StartEnd]+?\W/&gt;">
   <!--matches strings representing flattened element tags labelled with "__Start" and "__End" -->                         <xsl:matching-substring>
                                <xsl:variable name="flattenedTagContents" select="substring-before(., '__') ! substring-after(., '&lt;')"/>
                                <xsl:variable name="elementName" select="tokenize($flattenedTagContents, ' ')[1]"/>
                                <xsl:message>Flattened Tag Contents:  <xsl:value-of select="$flattenedTagContents"/></xsl:message>
                                
                                <xsl:element name="{$elementName}">
                                    <xsl:for-each select="tokenize($flattenedTagContents, ' ')[position() gt 1][contains(., '=')]">
                                        <xsl:attribute name="{substring-before(current(), '=')}">
                                            <xsl:value-of select="substring-after(current(), '=&#34;')"/>    
                                        </xsl:attribute>
                                    </xsl:for-each> 
                                    <xsl:attribute name="ana">
                                        <xsl:value-of select="substring-after(., '__') ! substring-before(., '&#34;')"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
           <xsl:analyze-string select="." regex="&lt;.+?/&gt;">
               <!--matches text strings representing self-closed elements (the milestone elements and such like). -->
               <xsl:matching-substring>
                   <xsl:variable name="flattenedTagContents" select="substring-after(., '&lt;') ! substring-before(., '/&gt;')"/>
                   <xsl:variable name="elementName" select="tokenize($flattenedTagContents, ' ')[1]"/>
                   <xsl:element name="{$elementName}">
          <xsl:for-each select="tokenize($flattenedTagContents, ' ')[position() gt 1]">
              <xsl:attribute name="{substring-before(current(), '=')}">
                  <xsl:value-of select="substring-after(current(), '=&#34;') ! substring-before(current(), '&#34;')"/>
              </xsl:attribute>
          </xsl:for-each>               
                   </xsl:element>        
               </xsl:matching-substring>
               <xsl:non-matching-substring>
                  <xsl:value-of select="."/>
               </xsl:non-matching-substring>
           </xsl:analyze-string>                                </xsl:non-matching-substring> 
        </xsl:analyze-string>
       </xsl:non-matching-substring>
      </xsl:analyze-string>
     </xsl:non-matching-substring>
    </xsl:analyze-string>
   </xsl:template>
           
   
  

</xsl:stylesheet>
