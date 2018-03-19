let $pbIDs := //pb/@xml:id/string()
let $dvIDs := distinct-values($pbIDs)
for $i in $dvIDs 
let $match := //pb[@xml:id = $i]
where count($match) gt 1
return 
($i, "appears repeatedly here:", string-join($match/@n, ', '),  ". &#10;")
