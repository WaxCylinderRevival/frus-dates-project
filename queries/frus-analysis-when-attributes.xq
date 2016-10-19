(:~ 
: Script Overview: This .xq script evaluates the content of @when attributes
: to determine if valid dateTime, valid date, invalid, or no attribute
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline/tei:date/attribute::when
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

let $when := $docs//tei:dateline/tei:date/attribute::when
let $castAs :=
  for $w in $when
  return
    if ($w castable as xs:dateTime)
    then "valid dateTime"
    else
      if ($w castable as xs:date)
      then "valid date"
      else "invalid"

let $whenResults := 
  for $type in distinct-values($castAs)
  let $count := count($castAs[. eq $type])
  let $percent := format-number(($count div (count($docs//tei:dateline/tei:date)) * 100),'##0.#%')
  order by $count descending
  return concat($type,' | ',$count,' | ',$percent,'%&#10;')
  
let $noWhenResults :=
  let $noW := $docs//tei:dateline/tei:date[not(attribute::when)]
  let $noWCount := count($noW)
  let $noWPercent := format-number(($noWCount div (count($docs//tei:dateline/tei:date)) * 100),'##0.##%')
  return concat('no `@when` | ', $noWCount,' | ',$noWPercent)
  
return
<text>
Type | Frequency | Overall Percentage
--- | --- | ---
{$whenResults}
{$noWhenResults}
</text>