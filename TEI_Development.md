# How We are Developing our TEI and Other Edition Output Formats

Principle to our project is the notion that multiple file formats are important for different purposes.
We use the following in our project:

## Separated Editions:
* "plain" text files: generated from various sources (whether from the PAEE for the 1818 and 1831 eds or cleaned-up OCR of the 1823 edition)
* TEI from the Shelley-Godwin Archive MS Notebooks: formatted as a diplomatic edition (faithful to the lineation of the notebooks and more descriptive than semantic). This will be altered in order to fold it into collation.
* Separate TEI XML editions of the print 1818, 1823, and 1831. These are hierarchically organized with deep containment (e.g. volume, letter, and chapter divs). These are named 1818_full.xml, 1823_full.xml, and 1831_full.xml


## Editions Prepared in Preparation for Collation
We created an alternative series of TEI files to faciliate collation, because automated collation works best on small, specifically aligned "chunks". This means we have one set of XML documents with a very "flat" hierarchy, where the div elements have been converted into milestone-style TEI elements. The collation start and end points are marked by self-closing `<anchor/>` elements. These files are the "fullFlat" series, as in 1818_fullFlat.xml (etc).

This XSLT generates the fullFlat series: [flattenHierarchiesIDtrans.xsl](https://github.com/ebeshero/Pittsburgh_Frankenstein/blob/Text_Processing/collateXPrep/flattenHierarchiesIDtrans.xsl)

In the new fullFlat XML files, we identified 33 chunks based on start and end points where all three texts shared passages in common. Mostly these chunks followed basic structural divisions in the texts with a few exceptions. NOTE: We excluded title pages from automatic collation because they are encoded distinctively and we can handle those variations by hand later. 

We then broke apart the three fullFlat files into 33 separate files per edition, which means 99 files.
These represent separate small XML files prepared for collation, and exist [here].(https://github.com/ebeshero/Pittsburgh_Frankenstein/tree/Text_Processing/collateXPrep/collationChunks) 

## Collated Editions:
Using a Python script, we "fed" the 99 "chunks" into collateX and output 33 collation files in two different formats:
* [text-table format](https://github.com/ebeshero/Pittsburgh_Frankenstein/tree/Text_Processing/collateXPrep/textTableOutput), which outputs a table that visually aligns the three texts.
* [pseudo-TEI output](https://github.com/ebeshero/Pittsburgh_Frankenstein/tree/Text_Processing/collateXPrep/teiOutput): 33 files that contain a more precise encoding of the segmented variants 

## Notes for next steps:
I. Collating the printed texts: Refinements?
* We'd like to see color encoded tables generated as HTML but currently this is only available as output within Jupyter Notebooks. 
* Perhaps consider normalizing variant spellings? Punctuation? (Be careful...)

II. Collating with the MS Notebook files






