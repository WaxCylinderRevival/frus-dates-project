xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

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

let $dateline := $docs//tei:dateline[1]

where 
  $dateline[tei:date[attribute::from-iso][attribute::to-iso]]

return concat('Change @from-iso and to-iso in ',$id,'&#10;- [ ] ', $url, '&#10;  - [ ] Adjust attributes in `',normalize-spac$date,'`')
}
</text>