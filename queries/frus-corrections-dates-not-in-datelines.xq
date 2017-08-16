(:~ 
: Script Overview: This .xq script finds encoded 
: dates that are not children of datelines and 
: returns issues by volume.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-07
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace frus="http://history.state.gov/ns/1.0";

let $coll := collection('frus-volumes')

for $vol in $coll/tei:TEI

let $volID := data($vol/attribute::xml:id)

let $docs :=

    for $doc in ($vol//tei:div[attribute::type='document'])

    let $docID := data($doc/attribute::xml:id)
  
    let $id := concat(data($volID),'/',data($docID))
  
    let $url := concat('https://history.state.gov/historicaldocuments/',data($id))
    
    let $dateNotInDateline :=
      
      for $date in $doc//tei:date
    
      where 
      $date[not(ancestor::tei:dateline)] 
      and $date[not(ancestor::frus:attachment)] 
      and $date[not(ancestor::tei:quote)]
      and $date[not(ancestor::tei:cit)] 
      
      return concat('Date entry: ',normalize-space(data($date)),'&#10;  - [x] Correct `date` not in `dateline`&#10;    - Revised encoding:&#10;```xml&#10;&#10;```')
      
  where not(empty($dateNotInDateline))

  return concat('- [x] ',$url,'&#10;',string-join($dateNotInDateline,'&#10;'))

where not(empty($docs))

return concat('Correct `date` not in `dateline` volume ',$volID,'&#10;',string-join($docs,'&#10;'),'&#10;-----------&#10;')