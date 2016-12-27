## Preparing a New TEI Edition of _Frankenstein_
This Readme file documents decisions we've made in preparing a new TEI edition of Mary Shelley's _Frankenstein_.

In October 2016, Elisa Beshero-Bondar met with Raffaele Viglianti and Rikk Mulligan to discuss a strategy for updating the Frankenstein edition on Romantic Circles. 
Raff and Elisa subsequently met over Skype with Neil Fraistat and Dave Rettenmaier and affirmed the following:

 We'll prepare an edition for publication on MITH's Romantic Circles (RC) site to replace the current edition. _Frankenstein_ is far and away the most clicked-on text in the Romantic Circles archive and preparing a new edition here for the Bicentennial will give the new text a lot of visibility. 
 
 ### Source texts
 
Studying the markup of the RC edition reveals that its TEI is built on its first publication in the [Pennsylvania Electronic Edition (PAEE)](http://knarf.english.upenn.edu/). Some of the markup in RC's TEI is not well-formed and due to the nature of the extraction from HTML may be missing information (such as italics), so we decided we had best begin our refurbished edition working with the original and simpler code of the old HTML in the PAEE on which the current TEI is based. 
 
 An 1823 edition of Frankenstein whose production was supervised by William Godwin has not previously been fully studied in relation to the 1818 or 1831 editions, though a table of hand-collected variants was published with the PAEE. We have located a photo facsimile of the 1823 edition of Frankenstein, which we plan to process with OCR to produce a digital text to include with our  new edition.
 
 ### Proof checking
 Elisa and Rikk will work on proofing the 1818 and 1831 texts against photofacsimiles.
 
 Rikk will investigate using ABBYY finereader (and Rikk and Elisa may also investigate Tesseract) for producing a good OCR of the 1823 text, and then work on proofing it. 
 
 When the texts are proofed we'll be ready for automated collation. 
 
 ### Collation process as stage 1 of TEI prep

 Preparing a freshly collated document of the three editions of Frankenstein for the Bicentennial is a goal set during the October meetings with the full Pittsburgh Frankenstein group as well as in the separate meetings with MITH. While the PAEE prepared a hand-collation of the 1818 and 1831 editions by means of frames (now depecrated in HTML), the current RC edition separates the 1818 and 1831 editions and relies on Juxta Commons to process and locate alignments and variations (or "deltas") between the editions. We think this collation can be improved by processing plain text versions of all three editions with [CollateX](http://collatex.net/) to locate and mark those deltas. 
Also, this provides a good way for us to prepare a unified TEI document that stores information about variations across the three editions, using [the TEI's critical apparatus encoding](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TC.html).

The first phase of markup on the texts will involve our experiments with CollateX to locate and mark their points of deviation. (This will take some careful processing that we'll document here.) The input will be plain text formatted in JSON, and the output will be an XML file with a root element and `<app>` markup to hold information about points of variation. We may need to experiment with processing the text in pieces and unifying the resulting XML. 

 From this encoding we will "up-convert" to work in structural markup in TEI P5. From this we will be able to develop a new reading interface for the web for the three editions as well as study and visualize how the texts compare. 
 
 ### Next stages following collation 
 
 * We can build on the new architecture of our collated edition with Raff's help to point to passages in [the Shelley-Godwin notebooks](http://shelleygodwinarchive.org/contents/frankenstein/). Our edition would provide a "stand-off" mechanism to point to locations in the notebooks, which could then be accessed when called for in our new reading interface.
 
* We can map in annotations from the PAEE and from the Bicentennial project team's study of Frankenstein's contexts and allusions.

* Our edition work may serve as a basis for Wendell Piez to produce a new LMNL edition of Frankenstein and help to highlight the overlapping hierarchies of the edition. We may also investigate a graph database as a way of storing intersecting and overlapping layers of annotation and structure associated with this novel. 
 

 
 
 

 
 
