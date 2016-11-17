xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>

{

let $coll := collection('frus-volumes')

for $vol in $coll/tei:TEI

let $volID := data($vol/attribute::xml:id)

let $docs :=

  for $doc in ($coll//tei:div[attribute::type='document'])
  
  let $docID := data($doc/attribute::xml:id)
  
  let $id := concat(data($volID),'/',data($docID))
  
  let $url := concat('https://history.state.gov/historicaldocuments/',data($id))
  
  let $dateRangeOutliers :=
    for $date in $doc//tei:date[attribute::from][attribute::to]
    
    let $from := $date/attribute::from
    let $to := $date/attribute::to
    
    where 
      not(
        functx:substring-before-if-contains(xs:string($from),'T')
        eq 
        functx:substring-before-if-contains(xs:string($to),'T')
      )
      and
      ($from castable as xs:dateTime or $to castable as xs:dateTime)
    
    return
     concat('  - [ ] Adjust attributes in `dateline/date`&#10;    ',normalize-space(data($date)),'&#10;    from: ',$from,'&#10;    to: ',$to,'&#10;    - Revised encoding:&#10;```xml&#10;```&#10;')
    
  where 
    not(empty($dateRangeOutliers)) and
    not(empty($doc//tei:date[attribute::from]))
  and
    not(empty($doc//tei:date[attribute::to]))

  order by $docID
  
  return concat('- [ ] ', $url, '&#10;',$dateRangeOutliers)
  
where not(empty($docs)) 

order by $volID 
  
return 
concat('------------&#10;@from date string does not match @to date string in volume ',$volID,'&#10;',string-join($docs,'&#10;'))
}
</text>