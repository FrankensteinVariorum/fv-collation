## Editorial Decisions:
by Rikk Mulligan and Elisa Beshero-Bondar

1) Join words that have been hyphenated as part of the justified line breaks.

2) Use underscore (_) to denote the use of Italics or a different font face.
* Issue: how do we note the different typeface of non-Italic? 
ebb: We are going to need to differentiate among uses of italics for titles vs. for emphasis, but that can wait until after we've collated the texts and we're up-converting to TEI. I think at that stage we can also 
evaluate when to use the TEI <hi rend="WhateverTypeFace">...</hi> and for how many different uses we need it. For right now, perhaps any change in typeface can simply be signalled with an underscore, 
*except* for smallcaps, for which see 3).

3) Smallcaps are marked as capital letters set within square brackets thus: M[RS]. [S[AVILLE].

4) We will add the TEI milestone marker for page breaks thus: `<pb xml:id="1823_v1_001" n="v1_001"/>`
Because numbering must work across three volumes and anticipate links to individual image files, the numbering scheme will use 5 digits: volume# + 0 + image #. 
Examples: 

`@n` values:
````
v1_viii
v1_001
v2_050
v3_150
````
USE LITERAL PAGE NUMBER in the printed volumes.

`@xml:id` values are:
````
1823_v1_001
````
The end number indicates the literal image object made from the imaging of the facsimile we are working with.

5) Formerly hyphenated words that cross page breaks will be joined on the previous page before the <pb> is added to the text file. Any immediate punctuation will be retained, most typically commas and periods.

6) All dashes are represented using the em dash character: —  

7) We will use the spelling as it appears rather than normalizing or modernizing the texts.

8) We will not be preserving the form work including the signatures, though we could add this into the TEI later.

9) Footnotes or endnotes in the printed editions will be moved, marked as `<note>` and placed next to the material they annotate rather than presented in their physical location on the page. 
