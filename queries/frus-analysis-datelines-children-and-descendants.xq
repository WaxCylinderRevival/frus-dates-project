xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

(: Needs Review, Cleanup :)

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $dl := $docs//tei:dateline

let $children :=
  for $dlChild in $dl/*
  let $dlChildName := name($dlChild)
  return $dlChildName

let $row :=    
  for $c in distinct-values($children)
  let $freq := count($children[matches(.,$c)])
  let $percent := format-number(((xs:integer($freq) div count($docs)) * 100),'##0.##')
  order by $freq descending
  return concat('`',$c,'` | ',$freq,' | ',$percent,'%&#xa;')

(:

let $descendants :=
  for $dlDesc in $dl/*
  let $dlDesc := name($dlDesc)
  return $dlDescName
  
let $row :=  
  for $d in distinct-values($descendants)
  let $freq := count($descendants[matches(.,$d)])
  order by $freq descending
  return concat('`',$d,'` | ',$freq,'&#xa;')

:)

return
<markdownTable>
Type | Frequency | Overal Percentage
--- | --- | ---
{$row}
</markdownTable>