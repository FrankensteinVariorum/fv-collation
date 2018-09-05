# Variorum “Spine” Collation Review and Annotation Process

## What is the Spine? 
The foundation of our Variorum edition is the XML-formatted output of automated collation from CollateX, so we have affectionately named it the “spine” analogous to the spine of a Creature or to the spine of a book in holding an entity together. The XML output shows how each of the *Frankenstein* editions we are comparing aligns and deviates from the others, and presents one way of “reading the Variorum under the hood." This output presents the entire novel of Frankenstein as a kind of braid of each represented edition, as it lines up units that are comparably the same or different in special XML elements. Here is an example of such an element:

```
 <app xml:id="C10_app48">
               <rdg wit="#f1818">catastrophe, </rdg>
               <rdg wit="#f1823">catastrophe, </rdg>
               <rdg wit="#f1831">catastrophe, </rdg>
               <rdg wit="#fMS">catastrophe; </rdg>
               <rdg wit="#fThomas">catastrophe, </rdg>
   </app>

```

The `<app>` element (short for critical apparatus markup), holds five `<rdg>` elements (short for reading witnesses, or the source editions for our collation). (We might think of this as something like a vertebrum unit in a spinal column, to continue our Creature metaphor.) The *attributes* on these elements serve to identify and distinguish them: The `<app>` contains an `@xml:id` that indicates it is part of collation unit 10 and is the 48th app element in the file. *(You may notice and wonder why these are not represented in chronological order. The order here does not really matter for us building our Variorum edition, but it comes out this way because that is how we set the comparison order for this collation process the last two represent handwritten edits, we just positioned them last to be compared with the three print editions.)

Sometimes an `<app>` element does not contain all the reading witnesses. An `<app>` can contain as little as just one reading witness. This happens when one witness contains material that is lacking in the others, as for example here:

```
 <app type="invariant" xml:id="C10_app29">
               <rdg wit="#f1818">dismally against the </rdg>
               <rdg wit="#f1823">dismally against the </rdg>
               <rdg wit="#f1831">dismally against the </rdg>
               <rdg wit="#fMS">dismally against the </rdg>
               <rdg wit="#fThomas">dismally against the </rdg>
            </app>
            <app xml:id="C10_app30">
               <rdg wit="#fMS">window </rdg>
            </app>
            <app type="invariant" xml:id="C10_app31">
               <rdg wit="#f1818">panes, and my candle was nearly burnt out, </rdg>
               <rdg wit="#f1823">panes, and my candle was nearly burnt out, </rdg>
               <rdg wit="#f1831">panes, and my candle was nearly burnt out, </rdg>
               <rdg wit="#fMS">panes, &amp;&lt;lb n="c56-0045__main__11"/&gt; my candle was nearly burnt out, </rdg>
               <rdg wit="#fThomas">panes, and my candle was nearly burnt out, </rdg>
            </app>

```
In the example above, only the Manuscript notebook witness contains the word “window”, and otherwise all the witnesses agree and are of `@type="invariant"` before and after this moment of variance. This is all collated properly and as we expect.

## Misalignments to mark
Unfortunately, automated collation does not always produce optimal alignment of reading witnesses. Here is one example of a faulty alignment: 

```
<app type="invariant" xml:id="C10_app95">
               <rdg wit="#f1818">not so changeable as the feelings of human nature. I had worked hard for </rdg>
               <rdg wit="#f1823">not so changeable as the feelings of human nature. I had worked hard for </rdg>
               <rdg wit="#f1831">not so changeable as the feelings of human nature. I had worked hard for </rdg>
               <rdg wit="#fMS">not so changeable as the feelings of hu&lt;lb n="c56-0046__main__5"/&gt;man nature. I had worked hard for </rdg>
               <rdg wit="#fThomas">not so changeable as the feelings of human nature. I had worked hard for </rdg>
            </app>
            <app xml:id="C10_app96">
               <rdg wit="#f1818">&lt;pb n="099" xml:id="F1818_v1_111"/&gt;nearly </rdg>
               <rdg wit="#f1823">&lt;pb n="99" xml:id="F1823_v1_118"/&gt;nearly </rdg>
               <rdg wit="#fMS">&lt;lb n="c56-0046__main__6"/&gt; </rdg>
               <rdg wit="#fThomas">&lt;pb n="099" xml:id="F1818_v1_111"/&gt;nearly </rdg>
            </app>
            <app xml:id="C10_app97">
               <rdg wit="#f1831">nearly </rdg>
               <rdg wit="#fMS">nearly </rdg>
            </app>
            <app type="invariant" xml:id="C10_app98">
               <rdg wit="#f1818">two </rdg>
               <rdg wit="#f1823">two </rdg>
               <rdg wit="#f1831">two </rdg>
               <rdg wit="#fMS">two </rdg>
               <rdg wit="#fThomas">two </rdg>
            </app>
            <app xml:id="C10_app99">
               <rdg wit="#f1818">years, </rdg>
               <rdg wit="#f1823">years, </rdg>
               <rdg wit="#f1831">years, </rdg>
               <rdg wit="#fMS">years </rdg>
               <rdg wit="#fThomas">years, </rdg>
            </app>
```

As we read the flow of the text through the `<app>` elements, notice that there are traces of the original elements in the source editions. In this case they represent line-breaks and page-breaks in the source editions, but do not indicate meaningful differences in the readings. Reading around these escaped tags, notice that C10_app96 and C10_app97 really share the same text. These `<app>` elements can be combined into one, and in our review process, we need to call out such problem spots and signal what needs to happen. We will do that with a `<note>` element at the end of the first `<app>` that needs to be merged:

```
            <app xml:id="C10_app96">
               <rdg wit="#f1818">&lt;pb n="099" xml:id="F1818_v1_111"/&gt;nearly </rdg>
               <rdg wit="#f1823">&lt;pb n="99" xml:id="F1823_v1_118"/&gt;nearly </rdg>
               <rdg wit="#fMS">&lt;lb n="c56-0046__main__6"/&gt; </rdg>
               <rdg wit="#fThomas">&lt;pb n="099" xml:id="F1818_v1_111"/&gt;nearly </rdg>
               <note type="error" resp="aw">Merge C10_app96 through C10_app98.</note>
            </app>
            <app xml:id="C10_app97">
               <rdg wit="#f1831">nearly </rdg>
               <rdg wit="#fMS">nearly </rdg>
            </app>
            <app type="invariant" xml:id="C10_app98">
               <rdg wit="#f1818">two </rdg>
               <rdg wit="#f1823">two </rdg>
               <rdg wit="#f1831">two </rdg>
               <rdg wit="#fMS">two </rdg>
               <rdg wit="#fThomas">two </rdg>
            </app>
            <app xml:id="C10_app99">
               <rdg wit="#f1818">years, </rdg>
               <rdg wit="#f1823">years, </rdg>
               <rdg wit="#f1831">years, </rdg>
               <rdg wit="#fMS">years </rdg>
               <rdg wit="#fThomas">years, </rdg>
            </app>
```

### Notes on our correction process: 
Making corrections to the “spine” is tricky work and we (Elisa, Jon, Jack, and Avery) decided this should involve multiple sets of eyes and multiple passes to get right. We will make a first pass through the files adding `<note>` elements indicating errors and suggesting what to fix in our own words. Afterwards, we will carefully implement the corrections by correcting the contents of the `<rdg>` elements and eliminating `<app>` elements as needed.

We can try changing our parameters and run collateX again (we have done that several times over the past year), but we think we are at a reasonably stable moment now, and it may be easiest simply to identify misalignments this way, since we need to proofread our output anyway. 


## Note elements: multiple applications (beyond marking misalignments)
We can add `<note>` elements for other reasons, too. Notes can be used

* to mark misalignments in the collation output (as discussed above)
* to raise a question about the source text (could there be an error?)
* to prepare informational or descriptive annotations when something interesting occurs in the collation.

To help us distinguish these different kinds of annotations and to indicate which of us is responsible for making a `<note>`, we will use the following attribute syntax:

```
<note resp="aw" type="error">...alignment error explanation here...</note>

<note resp="jq" type="annot">... informative or descriptive annotation of something interesting about the variation here...</note>

<note resp="ebb" type="check">...raise a question about something that doesn’t look right in the text itself and indicate we should check the source...</note>

```
In these three examples, the `@resp` attribute indicates which of the three of us (Avery, Jack, or Elisa) is responsible for the note. The `@type` attribute indicates the three types of annotations we are making. To avoid inconsistency and confusion, please use only the values represented above for these attributes. 

## Where are we working?

As we get started, please work with the 33 bridge-P1 files saved in our Google Drive as a sort of scratch workspace, following the production schedule described [here](https://github.com/PghFrankenstein/Pittsburgh_Frankenstein/issues/59).

Go ahead and upload your files to the same space. **File Renaming Protocol**: Please save your revised file with an underscore followed by your initials at the end of the filename just before the file extension, like this: 

```
bridge-P1_C02_aw.xml
```

And post the files back to Google Drive. We will port this back into GitHub when we are ready. 
