(:~ 
: Script Overview: This .xq script gathers all date attributes present in 
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline/tei:date 
: and sorts by frequency.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $date := $docs//tei:dateline/tei:date

let $attributes :=
  for $attribute in $date/attribute::*
  let $aName:= name($attribute)
  return $aName
  
let $rows :=
  for $a in distinct-values($attributes)
  let $freq := count($attributes[matches(.,$a)])
  let $percent := format-number(($freq div $total),'##0.##%')
  order by $freq descending
  return concat('`',$a,'` | ',$freq,' | ',$percent,'&#10;')
  
return
<text>
Attribute Name | Frequency | Overall Percentage
--- | --- | ---
{$rows}
</text>