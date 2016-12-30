<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
version="3.0">

   <!--2016-12-28 ebb: Prepared to process from a collection organized unambiguously by filename and output a single file. Filenames were prefaced by a number to process in sequential order.-->  
  <xsl:strip-space elements="*"/>
    <xsl:output method="text" encoding="UTF-8"/>

   <!--ebb: Uncomment one of the following lines to process the appropriate edition, either 1818 or 1831.--> 
  <!--<xsl:variable name="paEdition" select="collection('../frankenTexts_HTML/PA_Electronic_Ed/1818_ed')"/>-->
   
 <xsl:variable name="paEdition" select="collection('../frankenTexts_HTML/PA_Electronic_Ed/1831_ed')"/>
   
   <xsl:template match="/">
     <xsl:text>********************************************************************************
        # FRANKENSTEIN; OR, THE MODERN PROMETHEUS
        
        ## The Pittsburgh Bicentennial Edition
        
        ### INTRODUCTORY NOTE ON THE TEXT: 
        
This is a plain text edition of the </xsl:text><xsl:value-of select="($paEdition//head[1]/tokenize(title, ', ')[2])[1]"/> edition of _Frankenstein; or, the Modern Prometheus_ by Mary Shelley <xsl:text>prepared for the Frankenstein Bicentennial project, which commemorates the 200th anniversary of the first published edition of this novel in 1818.
     </xsl:text> 
      
      <xsl:text>Frankenstein; or, the Modern Prometheus: Pittsburgh Bicentennial Edition is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. <!--ebb: Check with project team. Do we want this to be a free culture license, meaning we permit commercial uses of this work? If so, change this to read:
     
Frankenstein; or, the Modern Prometheus: Pittsburgh Bicentennial Edition is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
      -->
      </xsl:text>
      <xsl:text>Date this text was produced: </xsl:text><xsl:value-of select="current-dateTime()"/><xsl:text>. 
      </xsl:text> 
      <xsl:text>This edition is part of the Pittsburgh research team's contribution to the Bicentennial Frankenstein Project, and is prepared by Elisa Beshero-Bondar of the University of Pittsburgh at Greensburg with assistance from Rikk Mulligan of Carnegie Mellon University. We are grateful for consultation from Wendell Piez, David J. Birnbaum, and Raffaele Viglianti, as well as Neil Fraistat and Dave Rettenmaier. This edition's stages of development are stored and documented in the Pittsburgh_Frankenstein GitHub repository: https://github.com/ebeshero/Pittsburgh_Frankenstein/ .

We have produced this plain text edition for two purposes:

1) To prepare for automated collation of the 1818, 1823, and 1831 editions of _Frankenstein_ using CollateX, in order to generate a TEI XML document that stores the variations of these texts.

2) To provide a reliable digital base text of each edition tractable for future projects.

      </xsl:text>
     
     <xsl:text>This plain text edition is one of two, representing the 1818 and 1831 editions of the novel. This pair of editions is based on the Pennsylvania Electronic Edition of _Frankenstein; or, the Modern Prometheus_ by Mary Shelley, edited by Stuart Curran and assisted by Jack Lynch, located at http://knarf.english.upenn.edu/ and hereafter referred to as PA EE. Elisa Beshero-Bondar and Rikk Mulligan *are correcting* these texts against photo facsimiles of the 1818 and 1831 texts. 
        * We will alter the previous sentence in this header when this phase of proof-checking is completed.
     </xsl:text>
      <xsl:text>Our plain text edition preserves the rendering of italics, square brackets, and centered text from the PA EE HTML texts. 

* In the PA EE there is no distinction between italics for titles and italics for emphasized words. Because the asterisk is used to signal footnotes in the text, we use the underscore (`_`) instead to mark off italicized text of any kind. 

* Square brackets (`[ ]`) are placed around text marked as small caps. (We have commented out the one instance in the 1831 PA EE HTML in which square brackets were used to hold a normalized variant of a word, to suppress that from the output.) 

* Centered text is marked between percent symobls: `% %`.

* Each unit of PA EE HTML texts marked with a structural element to indicate line break (`&lt;br&gt;`) or paragraph (`&lt;p&gt;`) is produced as a unit line in the plain text. Thus, an entire paragraph appears as a single line. Every unit line is followed by two newline characters. 
      </xsl:text>
      <xsl:text>Note for later processing: In the PA EE of this text, there are </xsl:text><xsl:value-of select="count(distinct-values($paEdition//body//a/@href))"/> encoded links, each pointing to an editorial annotation.
      <xsl:text>********************************************************************************</xsl:text>
      <xsl:apply-templates select="$paEdition//body"/>
   </xsl:template>
   
<xsl:template match="br">
   <xsl:text>
      
   </xsl:text>
</xsl:template>
   <xsl:template match="p">
      <xsl:apply-templates/><xsl:text>
         
      </xsl:text>
</xsl:template> 
  <!-- <xsl:template match="text()">
      <xsl:apply-templates select="normalize-space(.)"/>
     2016-12-28 ebb: normalize-space() causes problems: too much tightening up of the output so words are run together, also when applied at <p> template, child nodes aren't processed. 
  Using regex and Text-Wrangler on the output file to remove its excess lines.
   </xsl:template>-->
   
<xsl:template match="i">
   <xsl:text>_</xsl:text><xsl:apply-templates/><xsl:text>_</xsl:text>
</xsl:template> 

   <xsl:template match="small">
      <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
   </xsl:template> 
   
   <xsl:template match="center">
      <xsl:text>%</xsl:text><xsl:apply-templates/><xsl:text>%</xsl:text>
   </xsl:template>
       
</xsl:stylesheet>