xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "functx-1.0.xq";

let $coll := collection('frus-volumes')

let $tzd :=

  for $dateTime in data($coll//tei:date/(attribute::when|attribute::notBefore|attribute::notAfter|attribute::from|attribute::to)[matches(.,'[\+\-]\d{2}:\d{2}$')])

  let $timezone := functx:get-matches($dateTime,'[\+\-]\d{2}:\d{2}$')
  
  return <tzd>{$timezone}</tzd>
 
return count(distinct-values($tzd))