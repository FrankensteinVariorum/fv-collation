<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="app">
     <sch:report test="contains(descendant::rdg[@wit='fThomas'], '&lt;del')" role="info">Here is a place where the Thomas text contains a deleted passage. Is it completely encompassed in the app?</sch:report>
            <sch:assert test="count(descendant::rdg/@wit) = count(distinct-values(descendant::rdg/@wit))" role="error">A repeated rdg witness is present! There's an error here introduced by editing the collation.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="app[count(rdgGrp) eq 1][count(descendant::rdg) eq 1]">
            <sch:report test="count(preceding-sibling::app[1]/rdgGrp) eq 1 or count(following-sibling::app[1]/rdgGrp) eq 1 or last()" role="warning">Here is a "singleton" app that may be best merged in with the preceding or following "unison" app as part of a new rdgGrp. 
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:let name="delString" value="'&lt;del'"/>
    <sch:rule context="rdg[@wit='fThomas']" role="error">
        <sch:let name="textTokens" value="tokenize(text(), ' ')"/>
        <sch:let name="delMatch" value="for $t in $textTokens return $t[contains(., $delString)]"/>
        <sch:assert test="count($delMatch) mod 2 eq 0">Unfinished deletion in the Thomas witness. We count <sch:value-of select="count($delMatch)"/> deletion matches. Make sure the Thomas witness deletion is completely encompassed in the app.</sch:assert>
    </sch:rule>
    </sch:pattern>
</sch:schema>