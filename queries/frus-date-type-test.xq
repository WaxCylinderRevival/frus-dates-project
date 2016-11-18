xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

(:
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>

{
:)
  
let $coll := collection('frus-volumes')

for $doc in $coll//tei:div[attribute::type='document']

let $docID := data($doc/attribute::xml:id)
let $volID := data($doc/ancestor::tei:TEI/attribute::xml:id)
let $url := concat('https://history.state.gov/historicaldocuments/',$volID,'/',$docID)

let $dateOutlier :=

  for $dateAtt in data($doc//tei:date/attribute::when | from | to)
  
  where 
    not($dateAtt castable as xs:date)
    and
    not($dateAtt castable as xs:dateTime)
  
  return <dateOutlier>{data($dateAtt)}</dateOutlier>
  
where
  not(empty($dateOutlier))

return 

<issue>
  <docURL>{$url}</docURL>
  <possibleErrors>
  {$dateOutlier}
  </possibleErrors>
</issue>