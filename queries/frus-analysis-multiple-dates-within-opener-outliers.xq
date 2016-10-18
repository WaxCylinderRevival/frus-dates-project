xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

(: Needs Review, Cleanup :)

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']


  for $doc in $docs
  let $vol := $doc/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']
  let $id := concat('https://history.state.gov/historicaldocuments/',data($vol),'/',data($doc/attribute::xml:id))
  let $date := $doc/tei:opener/tei:dateline/tei:date
  let $dateCount := count($date)
  where (xs:integer($dateCount) eq 2)
    return
    <doc url="{$id}">{$doc}</doc>
