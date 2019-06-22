let $collChunks := collection('collationChunks/?select=*.xml') => sort(substring-before(substring-after(tokenize(base-uri(), '/')[last()], '_C'), '.xml'))
(:for $c in $collChunks
let $hi := $c//hi/@sID/string():)
let $head := $collChunks//head[@sID]
(:for $h in $head
let $text := $h/following-sibling::text()[following::head[@eID eq $h/@sID]]:)
(:return concat(string-join($text, ' '), '&#10;'):)
let $milestone := $collChunks//milestone[not(@unit='tei:p')][not(@* = ('tei:lg', 'tei:l', 'tei:note', 'tei:seg', 'tei:head', 'end'))]
let $mileheads := ($milestone)
for $m in $mileheads
let $u := $m/@unit/string()
let $n := $m/@n/string()
let $Atts := string-join($m/@*[not(name() eq 'type')], ', ')
let $text := string-join($m/following::text()[not(matches(., '^\s+$'))][position() lt 5][following-sibling::*[1] eq $m/following-sibling::*[1]] ! normalize-space(), ' ')
let $unitNumText := concat($u, ' ', $n, ' ', substring($text, 1, 60), '&#10;')
let $string-length := $m/preceding::text()[not(matches(., '^\s+$'))][preceding::anchor[@type='collate']]/string-length() => sum()
return concat($u, ' ', $n, ' ', $string-length, ': ', substring($text, 1, 60), '&#10;')
(:replace(substring($text, 1, 30), '([ “]?[A-Z])\s*([A-Z])', '$1$2'):)