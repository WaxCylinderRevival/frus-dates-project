xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>

{
  
let $coll := collection('frus-volumes')
let $vol := $coll/tei:TEI

for $docs in $vol//tei:div[attribute::type='document']

let $docID := data($docs/attribute::xml:id)

let $volID := data($docs/ancestor::tei:TEI/attribute::xml:id)

let $id := concat(data($volID),'/',data($docID))

let $url := concat('https://history.state.gov/historicaldocuments/',data($id))

let $outliers :=

  for $date in $docs//tei:dateline/tei:date[attribute::from]
  
  let $from := functx:substring-before-if-contains(xs:string($date), 'T')
  
  let $to := functx:substring-before-if-contains(xs:string($date), 'T')
  
  where
    not($from eq $to)
           
  order by $volID, (substring-after($id,'d'))
  
  return concat('  - [ ] Adjust attributes in `dateline/date`&#10;    ',normalize-space($date),'&#10;    - Revised encoding:&#10;```xml&#10;```&#10;from: ',$from,', to: ',$to,'&#10;')
  
return $outliers  

(:
where $docs//tei:dateline/tei:date/attribute::from

return concat('------------&#10;@from date does not match @to date in volume ',$volID,'&#10;- [ ] ', $url, '&#10;',$outliers)
:)
}
</text>