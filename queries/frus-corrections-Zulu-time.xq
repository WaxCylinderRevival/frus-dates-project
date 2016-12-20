xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>

{

  
let $coll := collection('frus-volumes')

for $vol in $coll/tei:TEI[descendant::tei:date[matches(., '\s+\d{4}Z')]]

let $volID := data($vol/attribute::xml:id)

let $docs :=

  for $doc in $vol//tei:div[attribute::type='document']
  
  let $docID := data($doc/attribute::xml:id)
  
  let $id := concat(data($volID),'/',data($docID))
  
  let $url := concat('https://history.state.gov/historicaldocuments/',data($id))
  
  let $dateline := $doc//tei:dateline
  
  let $dateZulu := 
  
    for $Zulu in $dateline/tei:date[matches(., '\s+\d{4}Z')]
    
    let $ZuluText := normalize-space(data($Zulu))
    
    let $ZuluWhen := data($Zulu/attribute::when)

     where not(contains(xs:string($ZuluWhen),'+00:00'))

    
    return concat('  Dateline entry: ', $ZuluText, '&#10;  - [x] Correct `@when` from `', $ZuluWhen, '` to: `', functx:substring-before-if-contains(xs:string($ZuluWhen),'Z'), '+00:00`&#10;    - Revised encoding:&#10;```xml&#10;&#10;```')
  
  where not(empty($dateZulu))
  
  order by xs:numeric(substring-after($docID,'d'))
  
  return concat('- [x] ', $url, '&#10;', string-join($dateZulu, '&#10;'))

where not(empty($docs)) 

order by $volID 
  
return 
concat('&#10;------------&#10;Correct date/@when for Zulu time in ',$volID,' &#10;`date` with Zulu time in volume ',$volID,'&#10;',string-join($docs,'&#10;'))
}
</text>