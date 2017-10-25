(:~ 
: Script Overview: This .xq script gathers the number of date elements
: within a single dateline in an opener
: FRUS-VOLUMES//tei:div[attribute::type='document']/tei:opener/tei:dateline/tei:date
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

<text>
Number of `date` within `closer/dateline` | Frequency | Overall Percentage
--- | --- | ---
{

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document'][attribute::subtype='historical-document']
let $total := count($docs)

let $dateCounts :=
  for $doc in $docs
  let $id := data($doc/attribute::xml:id)
  let $date := $doc//tei:closer/tei:dateline/tei:date
  let $dateCount := count($date)
  return
    <doc id="{$id}">{$dateCount}</doc>

  for $d in distinct-values($dateCounts) 
  let $match := count($dateCounts[matches(.,$d)])
  let $mPercent := format-number(($match div $total),'##0.##%')
  order by $match descending
  return concat($d,' | ',$match,' | ',$mPercent, '&#10;')
}
</text>
