# Preparing Shelley-Godwin Archive Frankenstein Notebook files for collation

This Readme describes the pre-processing and processing stages to prepare the Shelley-Godwin Notebook files for collation. It links to files needed and names the directories in this repo to be used for each stage. 

**About the files**: The S-GA notebook files are named and assembled to represent their position in the c56, c57, and c58 boxes holding the notebook pages at the Bodleian Library. These represent one not-quite-continuous witness from c56 to c57 with some additional witness material in the form of second and third copies of particular passages in c57 and c58. 
![How the Bodleian Library Frankenstein ms notebooks  align as collation units with the full novel as published](SGA-collAlignOverview.png)

## I. Pre-processing
The pre-processing stage involves making changes to the original S-GA files necessary to make it comparable with the other editions in the collation process. Changes include 1) resequencing margin annotations, 2) commenting out elements that pose obstacles for collation, and 3) adding "word boundary markup" to indicate when whole words are split around line boundaries.

### A. Resequencing
The original notebook files from S-GA are located in `sga_Notebooks/orig_notebooks`. When we began work with these files, we needed to **resequence** their content, because edits made in the margins of each page were positioned at the end of the page. A pipeline process represented in the three XSLT files: 

1. `sga_Notebooks/Id_Trans-sga-MarginZonesP1.xslt` 
2. `sga_Notebooks/Id_Trans-sga-MarginZonesP2.xslt` 
3. `sga_Notebooks/Id_Trans-sga-MarginZonesP3.xslt` 

moved the margin zones into sequential position for collation. 

### B. Commenting out "obstacle" elements
Following this process, another XSLT transformation, `sga_Notebooks/Id_Trans_commentMods` commented out many `<mod>` element tags in the SGA encoding (but not any of their text string descendants) in order to reduce the complexity of the files and make the output from collation more legible. 

The output of these pre-processing stages (A. and B.) are the files named **`sga_Notebooks/msCollPrep_c**.xml`**.

### C. Adding word-boundary markup
We now work with the files named `sga_Notebooks/msCollPrep_c**.xml` to apply `<w>` elements to demarcate when whole words are broken around the `<line>....</line>` structure of the S-GA notebook files. We produced a modified version of the original S-GA ODD file here: `sga_Notebooks/sga_schemata/shelley-godwin-Pgh.odd` from which we generated a modified Relax-NG schema to govern these files, to help guide our work and prevent us from introducing errors as we add new markup. (Please ensure that the schema lines are associated and functioning in this stage of pre-processing.)

We add word boundary markup using self-closing marker elements, thus: `<w ana="start"/>...<w ana="end"/></line><line>...</w>` 
Note that by policy, **we remove hyphens that only mark work breakage** because these are not semantically relevant to our collation of variants. 

For example, the original might be entered thus:
```
<line>...books of chi-</line>
<line>valry . . .</line>
```
Our new markup removes the hyphen and changes it to:
```
<line>...books of <w ana="start"/>chi</line>
<line>valry<w ana="end"/> . . .</line>
```
This last pre-processing stage was conducted mostly in the fall of 2017, and was done "by hand" in turns by Rikk Mulligan and Elisa Beshero-Bondar. It is most likely not complete and occasionally inconsistent (watch for those hyphens), and more word-boundary edits will need to be made as we discover the necessity. 

## II. Preparing for collation: 
### A. Where to begin? 

1. When we need to edit sga files word-boundary markup or make other corrections to the source texts for the Frankenstein notebooks, return to the last pre-processing stage above and apply edits to the files named: **`sga_Notebooks/msCollPrep_c**.xml`**. It is important we work with **these** files in the sga_Notebooks directory because they are schema-protected, which guards us from making errors in the markup. (If edits are made in a later stage of the process, this is an ad-hoc "brittle" solution because we won't have a clear record of their association with the source edition.)

2. When the `sga_Notebooks/msCollPrep_c**.xml` files are updated and we are ready to begin a new collation, we need to simplify them to make their encoding as parallel as possible to the collation input files from the other source editions. On each `mscCollPrep` file, manually cut off the teiHeader and schema lines and replace the TEI root element with `<xml>`. Save this non-TEI version of each file of as **`sga_Notebooks/msCollPrep_c**_PreCollate.xml`**. These include files for c56, c57, and c58, as well as additional fragment files from c57 and c58, but not every fragment of the notebook is part of Frankenstein. The following are the six files we need:

* `sga_Notebooks/msCollPrep_c56_PreCollate.xml`
* `sga_Notebooks/msCollPrep_c57_PreCollate.xml`
* `sga_Notebooks/msCollPrep_c57Frag_C20_PreCollate.xml`
* `sga_Notebooks/msCollPrep_c57Frag_C24_PreCollate.xml`
* `sga_Notebooks/msCollPrep_c58_PreCollate.xml`
* `sga_Notebooks/msCollPrep_c58Frag_C33_PreCollate.xml`

### B. Prepare the msColl_full files
 We now work with this XSLT file to process each of the six "PreCollate" files above:
`sga_Notebooks/Id_Trans_sgaCollatePrep.xsl`. This stylesheet does the following: 

* changes `<line>...</line>` elements into self-closed `<lb/>` elements
* marks `<del>` elements inside `<mod>` that contain two characters or less and gives them a special `<pitt:mdel>` element so that they may be screened from the collation process to reduce collation noise (so that their content isn't treated as a source of variance with other editions but nevertheless is still output because we need their content.) Meanwhile all other `<del>` elements are preserved for full comparison.
* marks all `<hi>...</hi>` elements as `<pitt:hi>...</pitt:hi>`: The other source editions in the Variorum contain flattened `<hi/>` start and end marker elements. However, `<hi>` is more complicated and often doubly nested (as `<hi rend="X"><hi rend="Y">`) in the S-GA markup, we don't want to bother with flattening and raising it, but we do want to preserve it for the collation output.
* removes some `<zone>` `<space>` and `<listTranspose>` and other elements unnecessary for the collation.

* Currently this is designed to run over each file one at a time to inspect the output.) 

**Files involved and instructions to run:** 

* Source: Each of the six "PreCollate" XML files in `sga_Notebooks`.
* XSLT: `sga_Notebooks/Id_Trans_sgaCollatePrep.xsl`
* Set the output destination up a directory level to `collateXPrep` and and then down into the `msColl_full` directory.The new files follow this naming convention:
**`msColl_full/msColl_c**.xml`**

### C. Plant location flags on the `<lb/>` elements
Now that we have converted the `<line>..</line>` elements into self-closed `<lb/>` elements, we now run an XSLT process that plants locational "signal flag" attributes on them. The output of this process is saved in the `msColl-fullFlat` directory and is named thus: `msColl-fullFlat/msColl_c**-fullFlat.xml  
*The location flags will help us following the collation process, when we need to construct pointers back to the original source S-GA files on their website. We will need to make sure these elements and their flags are screened from the collation (=not meant for comparison) but preserved intact for the output.*

**Files involved:** 
* Source directory: `msColl_full/msColl_c**.xml`. 
* XSLT: `Id_Trans_sgaMSLocators.xsl`. 
* Output directory: `msColl-fullFlat`

### D. Flattening
 The `msColl_full` encoding must now be "flattened". All of the XML elements that contain other elements or mixed content (text and other elements) are altered so that they become self-closing "marker" elements with attributes signalling where start and end tags used to be. *This ensures that all texts when collated share a comparable form of encoding: often the markup itself (the positioning of a paragraph break, for example) is significant in the collation output. We need to preserve that information in a flattened state because it is going to conflict with the new XML hierarchy output by the collation process.*
 
1. 


### E. Chunking
The six flattened files are now "chunked" according to 33 common alignment positions between all editions of the novel. Not every witness is present from the S-GA files. All witnesses must be present at all points for the computer-automated collation process to run. Where witness chunks are missing in S-GA, we have prepared empty "dummy" files required for the collation process. 

1. 



