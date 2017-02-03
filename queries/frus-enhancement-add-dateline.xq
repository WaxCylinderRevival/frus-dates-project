(:~ 
: Script Overview: This .xq script evaluates 
: FRUS volumes containing documents missing 
: <dateline> and creates <dateline> per 
: document by repeating the <placeName> and
: <date> from <head>.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-01
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')

for $v in ($coll/tei:TEI)

let $vID := $v//tei:publicationStmt/tei:idno[attribute::type='frus']

let $docIssues :=

  for $doc in $v//tei:div[attribute::type='document'][not(contains(tei:head,'Editorial'))]
  
  let $docID := data($doc/attribute::xml:id)
  let $volID := data($doc/ancestor::tei:TEI/attribute::xml:id)
  let $url := concat('https://history.state.gov/historicaldocuments/',$volID,'/',$docID)
  
  let $place := normalize-space(serialize(
    functx:remove-attributes-deep($doc//tei:head/tei:placeName,('xmlns','xmlns:frus','xmlns:xi'))
  ))
  let $date := normalize-space(serialize(
    functx:remove-attributes-deep($doc//tei:head/tei:date,('xmlns','xmlns:frus','xmlns:xi'))
  ))
  
  let $fr := (' xmlns="http://www.tei-c.org/ns/1.0"')
  let $to := ('')
  
  let $newDateline :=
    if (exists($doc//tei:head/tei:placeName))
    then
      <dateline>
        {functx:replace-multi($place,$fr,$to)}, {functx:replace-multi($date,$fr,$to)}
      </dateline>
    else
      if (exists($doc//tei:head/tei:date))
      then
        <dateline>
          {functx:replace-multi($date, $fr, $to)}
        </dateline>
        else ''
       
  where
    (exists($doc//tei:head/tei:date)) and
    (not(exists($doc//tei:dateline))) and
    (not(empty($newDateline)))
  
  return 
  concat('- [x] ',$url,'&#10;',string-join(
    ('  - [x] Add `dateline`:&#10;```xml&#10;<dateline>',$newDateline,'</dateline>&#10;```'),'&#10;'))


where 
  (not(empty($docIssues))) 
  and
  (matches($vID, 'frus1955-57v25'))

return concat('Add missing `dateline` in ', $vID,'&#10;',string-join($docIssues,'&#10;'),'&#10;----------&#10;')