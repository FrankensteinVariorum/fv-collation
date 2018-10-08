<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="app">
            <sch:report test="contains(descendant::rdg[@wit='fThomas'], '&lt;del')" role="warning">Here is a place where the Thomas text contains a deleted passage. Check to see if it is completely encompassed in the app.</sch:report>
            <sch:assert test="count(descendant::rdg/@wit) = count(distinct-values(descendant::rdg/@wit))" role="error">A repeated rdg witness is present! There's an error here introduced by editing the collation.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="app[count(rdgGrp) eq 1][count(descendant::rdg) eq 1][not(starts-with(descendant::rdg, '&lt;lb'))]">
            <sch:report test="count(preceding-sibling::app[1]/rdgGrp) eq 1 or count(following-sibling::app[1]/rdgGrp) eq 1" role="warning">Here is a "singleton" app that may be best merged in with the preceding or following "unison" app as part of a new rdgGrp. 
            </sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>