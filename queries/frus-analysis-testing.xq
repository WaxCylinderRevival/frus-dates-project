xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>
**`@when` data outside of date coverage range of parent _FRUS_ volume**

Outlier data in `when` | Frequency | Issue | Example Entry | Example URIs
--- | --- | --- | --- | ---
{
let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)
let $vols := $coll//tei:publicationStmt/tei:idno[attribute::type='frus']

let $bibliography := collection('bibliography')

let $outlierWhen :=
  for $w in $docs/tei:opener/tei:dateline/tei:date[attribute::when]
  let $when := $w/attribute::when/data()
  let $whenValue := substring($when,1,4)
  let $whenVol := $w/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']
  let $bibVol := $bibliography//volume[attribute::id[matches(.,$whenVol)]]
  let $volCoverage := substring(data($bibVol//coverage[not(attribute::type)]),1,4)
  let $volFrom := 
    if (empty($bibVol//coverage[attribute::type='from']))
     then $volCoverage
     else substring(data($bibVol//coverage[attribute::type='from']),1,4)
  let $volTo :=
    if (empty($bibVol//coverage[attribute::type='to']))
    then $volCoverage
    else substring(data($bibVol//coverage[attribute::type='to']),1,4)
(: TO-FIX: where clause based on volume coverage dates not currently working 

  where (xs:integer($whenValue) < xs:integer($volTo)) or (xs:integer($whenValue) > xs:integer($volFrom))
  
  :)
  where (xs:integer($whenValue) < 1914) or (xs:integer($whenValue) > 1984)
  order by $when
  return
    $when

for $distinctOutlier in distinct-values($outlierWhen)
let $freq := count($outlierWhen[matches(.,$distinctOutlier)])

let $exampleURIs :=
  for $matchingDoc in $docs[tei:opener/tei:dateline/tei:date/attribute::when[matches(data(.), $distinctOutlier)]]
  let $matchingVol := $matchingDoc/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']
  let $url := concat('https://history.state.gov/historicaldocuments/',data($matchingVol),'/',data($matchingDoc/attribute::xml:id))
  return concat('<li>', $url, '</li>')

let $exampleEntry :=
    for $e in $docs/tei:opener/tei:dateline/tei:date[attribute::when[matches(data(.), $distinctOutlier)]]
    return normalize-space(data($e))

return 
concat($distinctOutlier, ' | ', $freq,' | `@when` outside of volume date range | ', $exampleEntry[1], ' | <ul>', string-join($exampleURIs), '</ul>&#10;')
}
</text>