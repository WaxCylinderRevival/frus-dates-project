(:~ 
: Script Overview: This .xq script reports documents that
: have @when date values outside of current FRUS date range
: (1776 to 1988).
: The results are sorted by frequency (descending) and 
: then by date (ascending).
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

<text>
**`@when` data outside of current _FRUS_ range (1776 to 1988)**

Outlier data in `when` | Frequency | Issue | Example Entry | Example URI
--- | --- | --- | --- | ---
{
let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $outlierWhen :=
  for $when in $docs/tei:opener/tei:dateline/tei:date/attribute::when/data()
  let $whenValue := substring($when,1,4)
  where (xs:integer($whenValue) < 1776) or (xs:integer($whenValue) > 1988)
  return
    $when

for $distinctOutlier in distinct-values($outlierWhen)
  let $freq := count($outlierWhen[matches(.,$distinctOutlier)])
  let $dOValue := substring($distinctOutlier,1,4)
  let $test := 
    if (xs:integer($dOValue) < 1776)
    then '`@when` earlier than 1776'
    else 
      if (xs:integer($dOValue) > 1988)
      then '`@when` later than 1988'
        else '`@when` inside corpus range'
        
let $exampleURIs :=
  for $exampleDoc in $docs[tei:opener/tei:dateline/tei:date/attribute::when[matches(data(.), $distinctOutlier)]]
  let $vol := $exampleDoc/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']
  let $id := concat('https://history.state.gov/historicaldocuments/',data($vol),'/',data($exampleDoc/attribute::xml:id))
  return concat('<li>',$id,'</li>') cast as xs:string

let $exampleEntry :=
    for $e in $docs/tei:opener/tei:dateline/tei:date[attribute::when[matches(data(.), $distinctOutlier)]]
    return normalize-space(data($e))

order by $freq  descending, $distinctOutlier ascending
return 
  concat($distinctOutlier, ' | ', $freq,' | ', $test, ' | ', $exampleEntry[1], ' | <ul>', string-join($exampleURIs), '</ul>&#10;')
}
</text>