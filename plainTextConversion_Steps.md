## Stages in Porting from HTML of the Pennsylvania Electronic Edition to Plain Text 
This work completed by Elisa Beshero-Bondar.

This file documents stages of processing the HTML files of the Pennsylvania Electronic Edition (PA EE) in preparation for automated collation with CollateX, as well as for supplying a diplomatic plain text edition of the 1818 and 1831 texts of _Frankenstein_ that preserves most of the PA EE’s markup. 

### Decisions for preserving and eliminating markup in plain text versions:

* Using regex find-and-replace strategies, we have prepared altered versions of the PA EE HTML files to reproduce simpler forms which are consistent with current XHTML 5 standards in 2016. 

* In the PA EE some elements (like `<p>` and `<br>`) were not given close tags, while others were, making the code difficult to process with XSLT. Close tags were applied and the files were simplified to carry only the title page, prefacing material, and text of the novel. 

* The elements holding navigational information in the PA EE were excluded. This is because the PA EE texts were prepared as 238 and 250 separate HTML files (for the 1818 and 1831 editions) in order to manually align them in small “chunks” as a means to compare them visually in HTML frames. Since our edition is uniting these hundreds of chunks into a single document, we will prepare new navigational elements at a later stage after we have prepared our new TEI edition and are ready to produce a new reading view.

* Renaming files and directories: The PA EE files were stored in three separate directories for each edition, associated with volumes 1, 2, and 3 of the 1818 edition, and the 1831 files were given names to assist with pairing them with associated chunks of the 1818 edition inside HTML frames. Since we need to process the files all together to output a single text of the 1818 and of the 1831 novel, we flattened the hierarchy: We removed the volume directories and held each edition’s set of 238 and 250 files respectively in its own directory. The files were renamed carefully to number their sequence in assembling the text, and to simplify their association with the text’s structural layers: the opening material, the Walton letters that frame the text at its beginning and end, and the internal chapters. 

* We are beginning our refurbishing process by preparing plain texts for collation, which presents a first stage in conversion to XML and TEI. For this purpose, we must simply represent the nineteenth-century editions, so we are not at this stage porting the links coded in the PA EE. For easing the collation and up-conversion process later, we are preserving information from the presentation markup of the PA EE texts: its rendering of italics, square brackets, and centered text. 

* In the PA EE there is no distinction between italics for titles and italics for emphasized words. Because the asterisk is used to signal footnotes in the text, we use the underscore (`_`) instead to mark off italicized text of any kind. 

* Square brackets (`[ ]`) are placed around text marked as small caps. (We have commented out the one instance in the 1831 PA EE HTML in which square brackets were used to hold a normalized variant of a word, to suppress that from the output.) 

* Centered text is marked between curly braces: `{ }` Note: some center tagging, such as in header tags, was lost in the conversion process and should be restored as we proof the texts.

* Each unit of PA EE HTML texts marked with a structural element to indicate line break (`<br>`) or paragraph (`<p>`) is produced as a unit line in the plain text. Thus, an entire paragraph appears as a single line. Every unit line is followed by two newline characters. 

* Documentation is generated at the head of the text files inside commented text marked with hashes (`# `), to indicate the derivation of the documents from the PA EE and to document the rendering decisions above. 

### Stages for processing the altered PA EE HTML to produce plain text editions:

* Run the XSLT file [PlainText_Prep.xsl ](https://raw.githubusercontent.com/ebeshero/Pittsburgh_Frankenstein/master/XSLT/PlainText_Prep.xsl) over each directory (in oXygen, do this by uncommenting the appropriate variable pointing to either the 1818 or 1831 directory, commenting out the other, and running it over any “dummy” XML file since oXygen requires an XML file be associated with the transformation). Save the output in the top level of the Plain Text directory.

* Open the output in Text Wrangler and in oXygen, and work on the following:

* In Text Wrangler, remove line breaks (option in the Text menu). This ensures that any text preceded by just one newline character is pulled into the preceding line, which unites the content of each paragraph inside a single line. 

* In oXygen, with regex find and replace, eliminate instances of more than two newline characters `\n`, but ensure that two newlines appear between each line.

* Add `\n\n` after VOLUME, LETTER, PREFACE, and CHAPTER headings and the Introduction heading in the 1831 edition. Search for `(PREFACE|VOLUME|LETTER|CHAPTER)\s+[IVXLC]+\.*` .  Also check and restore newlines in letter headings.

* In Text Wrangler, “educate” the quotes (option in the Text menu): This produces curly apostrophes and quotes from the straight quotes of the PA EE. 

* Regularize white spaces using Find & Replace in oXygen, using the `\h` regex to indicate white space inside a line. Replace any instances of `\h\h` with ` `. 

* Convert double hyphens (`--`) to em dashes (`—`). 





