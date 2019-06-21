declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace xi="http://www.w3.org/2001/XInclude";
let $sgaFiles := collection('sga_collChunkAssembly')
let $sourceDoc := $sgaFiles//sourceDoc
let $sdComments := $sourceDoc//comment()
for $i in $sdComments
let $file := $i/base-uri() ! tokenize(., '/')[last()]
where $file[starts-with(., 'fMS')]

return concat($file, ': ', $i, '&#10;')