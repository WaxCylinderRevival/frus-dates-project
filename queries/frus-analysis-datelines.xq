xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

(: Needs Review, Cleanup :)

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']

let $dlCounts :=
  for $doc in $docs
  let $id := data($doc/attribute::xml:id)
  let $dl := $doc//tei:dateline
  let $dlCount := count($dl)
  return
    <doc id="{$id}">{$dlCount}</doc>

for $d in distinct-values(data($dlCounts))
let $total := count($dlCounts)
let $match := count($dlCounts[matches(.,$d)])
let $mPercent := format-number(($match div $total),'##0.##%')
order by xs:integer($match) descending
return concat($match,' documents (', $mPercent,') contain ', $d, ' datelines within `div[attribute::type=&quot;document&quot;]`.')