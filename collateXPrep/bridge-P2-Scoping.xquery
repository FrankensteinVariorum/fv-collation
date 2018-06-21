declare namespace tei="http://www.tei-c.org/ns/1.0";
let $P2-Coll := collection('bridge-P2')
let $rdgGrp := $P2-Coll//tei:rdgGrp
return (count($rdgGrp), $rdgGrp)

