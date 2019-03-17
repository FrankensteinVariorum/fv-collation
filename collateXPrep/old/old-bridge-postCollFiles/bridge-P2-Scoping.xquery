declare namespace tei="http://www.tei-c.org/ns/1.0";
let $P2-Ed-Coll := collection('bridge-P2')
let $SpineFiles := collection('standoff_Spine')
let $rdgGrp := $SpineFiles//tei:rdgGrp
return (count($rdgGrp), $rdgGrp)

