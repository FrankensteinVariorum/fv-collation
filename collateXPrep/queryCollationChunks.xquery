(: 2019-06-07 ebb: An XQuery to help scope the collationChunks directory. :)
let $frankencoll := collection('collationChunks/?select=*.xml')
let $anchors := $frankencoll//anchor[@type='collate']/@xml:id/string()
let $anchorsCount := count($anchors) div 5
let $noAnchor := $frankencoll//xml[not(descendant::anchor[@type='collate'])]/base-uri() ! tokenize(., '/')[last()]
let $thomasDel := $frankencoll[contains(base-uri(), 'Thomas')]//xml[descendant::del]/base-uri() ! tokenize(., '/')[last()]
let $msDel := $frankencoll[contains(base-uri(), 'msColl')]//xml[descendant::del]/base-uri() ! tokenize(., '/')[last()]
return $msDel