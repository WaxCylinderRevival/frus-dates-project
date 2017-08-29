xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace frus="http://history.state.gov/frus/ns/1.0";

import module namespace functx="http://www.functx.com" at "functx-1.0.xq";

let $coll := collection('frus-volumes')

let $date :=

  for $doc-dateTime-min in data($coll//tei:div/attribute::frus:doc-dateTime-min)
  
  let $dateString := substring-before($doc-dateTime-min, 'T')
  
  return $dateString
  
let $issue :=
  
    for $distinct in distinct-values($date)
    
    let $count := count($date[contains(.,$distinct)])
    order by $distinct
    
    return concat($distinct,' | ', $count)

return concat('Date | Number of Documents&#10; --- | ---&#10;', string-join($issue,'&#10;'))