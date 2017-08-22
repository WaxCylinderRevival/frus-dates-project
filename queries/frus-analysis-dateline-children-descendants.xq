(:~ 
: Script Overview: This .xq script gathers all children or descendants of 
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline
: and sorts by frequency.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

let $coll := collection('frus-volumes')

let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $children :=
  for $childName in $docs/tei:opener/tei:dateline/*/name()
  return $childName
  
let $descendants :=
  for $descName in $docs/tei:opener/tei:dateline//*/name()
  return $descName
  
(: for children of dateline :)

let $cRows :=
  for $dName in distinct-values($docs/tei:opener/tei:dateline/*/name())
  let $freq :=  count($children[matches(.,$dName)])
  let $percent := format-number(($freq div $total),'##0.##%')
  order by $freq descending
  return concat($dName," | ",$freq," | ",$percent, '&#10;')
return
<text>Children of `dateline` | Frequency | Overall Percentage
--- | --- | ---
{$cRows}</text>

(: for descendants of dateline :)
(:
let $dRows :=
  for $dName in distinct-values($docs/tei:opener/tei:dateline//*/name())
  let $freq :=  count($descendants[matches(.,$dName)])
  let $percent := format-number(($freq div $total),'##0.##%')
  order by $freq descending
  return concat($dName," | ",$freq," | ",$percent, '&#10;')
return
<text>Descendants of `dateline` | Frequency | Overall Percentage
--- | --- | ---
{$dRows}</text>
:)
