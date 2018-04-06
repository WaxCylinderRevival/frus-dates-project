xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')
let $subtype := $coll//tei:div/attribute::subtype
for $s in distinct-values($subtype)
let $count := count($subtype[. = $s])
order by $s
return concat($s,' | ', $count)