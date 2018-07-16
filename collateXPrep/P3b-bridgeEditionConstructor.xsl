<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"  xmlns:pitt="https://github.com/ebeshero/Pittsburgh_Frankenstein"
    xmlns="http://www.tei-c.org/ns/1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

<xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="bridge-P3a" as="document-node()+" select="collection('bridge-P3a/')"/>
<!--Adding @loc attributes to ease expansion of flattened elements in Bridge Phase 4. Also standardizes @ana values to 'start' and 'end'. Takes bridge-P3a files as input and outputs them to bridge-P3-b. -->   
   <xsl:template match="/">
       <xsl:for-each select="$bridge-P3a//TEI">
           <xsl:variable name="currentP3File" as="element()" select="current()"/>
           <xsl:variable name="filename">
              <xsl:value-of select="tokenize(base-uri(), '/')[last()]"/>
           </xsl:variable>
         <xsl:variable name="chunk" as="xs:string" select="substring-after(substring-before(tokenize(base-uri(), '/')[last()], '.'), '_')"/>          
-           <xsl:result-document method="xml" indent="yes" href="bridge-P3b/{$filename}">
        <TEI><xsl:copy-of select="descendant::teiHeader"/>
       
            <xsl:apply-templates select="descendant::text"><xsl:with-param name="filename" select="$filename" as="xs:string"/></xsl:apply-templates>
        
        </TEI>
         </xsl:result-document>
       </xsl:for-each>
   </xsl:template>
 <xsl:template match="*[@ana='Start' and @loc]">
     <xsl:element name="{name()}">
         <xsl:attribute name="ana">
             <xsl:text>start</xsl:text>
         </xsl:attribute>
         <xsl:for-each select="@*[not(name() = 'ana')]">
             <xsl:attribute name="{name()}">
                 <xsl:value-of select="."/>
             </xsl:attribute>
         </xsl:for-each>
         <xsl:apply-templates/>
     </xsl:element>
 </xsl:template>
    <xsl:template match="*[@ana='End' and @loc]">
        <xsl:element name="{name()}">
            <xsl:attribute name="ana">
                <xsl:text>end</xsl:text>
            </xsl:attribute>
            <xsl:for-each select="@*[not(name() = 'ana')]">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   <xsl:template match="*[matches(@ana, '[Ss]tart') and not(@loc)]">
       <xsl:param name="filename"/>
      <xsl:variable name="elementName" select="current()/name()" as="xs:string"/>
          <xsl:element name="{$elementName}">
              <xsl:attribute name="loc">
                  <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elementName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elementName][matches(@ana, '[Ss]tart')][ancestor::div]) + 1"/>
              </xsl:attribute>
              <xsl:attribute name="ana">
                  <xsl:text>start</xsl:text>
              </xsl:attribute>
              <xsl:for-each select="current()/@*[not(name() = 'ana')]">
                  
                  <xsl:attribute name="{current()/name()}">
                      <xsl:value-of select="current()"/> 
                  </xsl:attribute>
              </xsl:for-each>
              <xsl:apply-templates/>
          </xsl:element>
   </xsl:template>
    <xsl:template match="*[matches(@ana, '[Ee]nd') and not(@loc)]">
        <xsl:param name="filename"/>
        <xsl:variable name="elementName" select="current()/name()" as="xs:string"/>
        <xsl:element name="{$elementName}">
            <xsl:attribute name="loc">
                <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elementName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elementName][matches(@ana, '[Ee]nd')][ancestor::div]) + 1"/>
            </xsl:attribute>
                <xsl:attribute name="ana">
                    <xsl:text>end</xsl:text>
                </xsl:attribute>
            <xsl:for-each select="current()/@*[not(name() = 'ana')]">
                <xsl:attribute name="{current()/name()}">
                    <xsl:value-of select="current()"/> 
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div//*[not(self::seg) and not(self::milestone)][not(@ana)]">
        <xsl:param name="filename"/>
        <xsl:variable name="elemName" select="name()"/>
        <xsl:message>This template is matching and $elemName = <xsl:value-of select="$elemName"/></xsl:message>
        <xsl:choose>
            <xsl:when test="(count(following-sibling::*[name() = $elemName]) + 1) mod 2 eq 0">
                <xsl:element name="{$elemName}">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:attribute name="ana">
                        <xsl:text>start</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="loc">
                        <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elemName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elemName][matches(@ana, '[Ss]tart')][ancestor::div]) + 1"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$elemName}">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:attribute name="ana">
                        <xsl:text>end</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="loc">
                        <xsl:value-of select="tokenize($filename, '-')[last()] ! substring-before(., '.')"/><xsl:text>-</xsl:text><xsl:value-of select="$elemName"/><xsl:text>_</xsl:text><xsl:value-of select="count(preceding::*[name() = $elemName][matches(@ana, '[Ss]tart')][ancestor::div]) + 1"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
  
</xsl:stylesheet>


