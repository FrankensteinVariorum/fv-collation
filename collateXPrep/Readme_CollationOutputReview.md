# Variorum “Spine” Collation Review and Annotation Process

## Background information: 
The foundation of our Variorum edition is the XML-formatted output of automated collation from CollateX. The XML output shows how each of the Frankenstein editions we are comparing aligns and deviates from the others, and presents one way of “reading the Variorum under the hood." This output presents the entire novel of Frankenstein as a kind of braid of each represented edition, as it lines up units that are comparably the same or different in special XML elements. Here is an example of such an element:

```
 <app xml:id="C10_app48">
               <rdg wit="#f1818">catastrophe, </rdg>
               <rdg wit="#f1823">catastrophe, </rdg>
               <rdg wit="#f1831">catastrophe, </rdg>
               <rdg wit="#fMS">catastrophe; </rdg>
               <rdg wit="#fThomas">catastrophe, </rdg>
   </app>

```

The `<app>` element (short for critical apparatus markup), holds five `<rdg>` elements (short for reading witnesses, or the source editions for our collation). *(You may notice and wonder why these are not represented in chronological order. The order here does not really matter for us building our Variorum edition, but it comes out this way because that is how we set the comparison order for this collation process the last two represent handwritten edits, we just positioned them last to be compared with the three print editions.)

Sometimes an `<app>` element does not contain all the reading witnesses. An `<app>` can contain as few as just one reading witness. This happens when one witness contains material that is lacking in the others, as for example here:

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
In the example above, only the Manuscript  notebook witness contains the word “window”, and otherwise all the witnesses agree and are of `@type="invariant"` before and after this moment of variance. This is all collated properly and as we expect.

Unfortunately, automated collation does not always produce optimal alignment of reading witnesses. Here is an example of a faulty alignment: 

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
               <note type="error" resp="aw">Lump/ merge app96-98</note>
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

As we read the flow of the text through the app elements, notice that there are traces of the original elements in the source editions. In this case they represent line-breaks and page-breaks in the source editions, but do not indicate meaningful differences in the readings. Reading around these escaped tags, notice that C10_app96 and C10_app97 really share the same text. These app elements can be combined into one.






We can try changing our parameters and run collateX again (we have done that several times over the past year), but we think we are at a reasonably stable moment now, and some misalignments will have to be edited by hand. 
