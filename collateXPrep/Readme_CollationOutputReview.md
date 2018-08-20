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

The `<app>` element (short for critical apparatus markup), holds five witnesses. *(You may notice and wonder why these are not represented in chronological order. The order here does not really matter for us building our Variorum edition, but it comes out this way because that is how we set the comparison order for this collation process the last two represent handwritten edits, we just positioned them last to be compared with the three print editions.)


Unfortunately, automated collation does not always produce optimal alignment of reading witnesses. Here is an example of a faulty alignment: 

COMING: EXAMPLE

MORE TO BE ADDED 




We can try changing our parameters and run collateX again (we have done that several times over the past year), but we think we are at a reasonably stable moment now, and some misalignments will have to be edited by hand. 
