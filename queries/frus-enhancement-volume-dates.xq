xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace frus="http://history.state.gov/frus/ns/1.0";
declare namespace dc="http://www.dublincore.org/documents/dcmi-namespace/";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $q := "frus1865p4"
let $coll := collection('frus-volumes')
(: [tei:TEI/attribute::xml:id=$q] :)

for $vol in $coll/tei:TEI

  let $volID := data($vol/attribute::xml:id)
  let $docs := $vol//tei:div[attribute::type='document']

  let $doc-min := $docs//attribute::frus:doc-dateTime-min
  let $doc-max := $docs//attribute::frus:doc-dateTime-max

  let $volume-dates-min :=
     for $d-min in $doc-min
     return xs:dateTime(data($d-min))

  let $volume-dates-max :=
     for $d-max in $doc-max
     return xs:dateTime(data($d-max))
     
  let $coverage :=
    <xenoData>
      <dc:coverage notBefore="{min($volume-dates-min)}" notAfter="{max($volume-dates-max)}"/>
    </xenoData>

  return concat('- [x] http://history.state.gov/historicaldocuments/',$volID,'&#10;  - [x] Add namespace declaration:&#10;```xml&#10;xmlns:dc="http://www.dublincore.org/documents/dcmi-namespace/"&#10;```&#10;  - [x] Add `coverage` dates to `teiHeader` &#10;```xml&#10;',serialize($coverage),'&#10;```&#10;')