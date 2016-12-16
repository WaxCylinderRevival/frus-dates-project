(:~ 
: Script Overview: This .xq script find all attributes of  
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline[tei:date[not(attribute::when)]]
: and returns frequency and two examples.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $coll := collection('frus-volumes')

for $vol in $coll/tei:TEI

let $volID := data($vol/attribute::xml:id)

let $docs :=

    for $doc in ($vol//tei:div[attribute::type='document'])

    let $docID := data($doc/attribute::xml:id)
  
    let $id := concat(data($volID),'/',data($docID))
  
    let $url := concat('https://history.state.gov/historicaldocuments/',data($id))
    
    let $dateAttributeErrors :=
      
      for $date in $doc//tei:date
    
      where 
      $date[not(attribute::*)] and not($date[contains(.,'ndated')])
      
      return concat('Date entry: ',normalize-space(data($date)),'&#10;  - [x] Add `@when` to `date`&#10;    - Revised encoding:&#10;```xml&#10;&#10;```')
      
  where not(empty($dateAttributeErrors))

  return concat('- [x] ',$url,'&#10;',string-join($dateAttributeErrors,'&#10;'))

where not(empty($docs))

return concat('Correct `date` without attributes in volume ',$volID,'&#10;',string-join($docs,'&#10;'),'&#10;-----------&#10;')