xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']

let $dateCounts :=
  for $doc in $docs
  let $id := data($doc/attribute::xml:id)
  let $date := $doc//tei:dateline/tei:date
  let $dateCount := count($date)
  return
    <doc id="{$id}">{$dateCount}</doc>

let $rows :=
  for $d in distinct-values($dateCounts) 
  let $total := count($docs)
  let $match := count($dateCounts[matches(.,$d)])
  let $mPercent := format-number((($match div $total) * 100),'##0.##')
  order by $match descending
  return concat($d,' | ',$match,' | ',$mPercent, '%&#10;')
  
return
<text>
Number of `date` | Frequency | Overall Percentage
--- | --- | ---
{$rows}
</text>