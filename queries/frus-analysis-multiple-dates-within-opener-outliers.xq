(:~ 
: Script Overview: This .xq script returns encoded examples of outliers 
: with multiple dates within opener, based on input number in $q 
: FRUS-VOLUMES//tei:div[attribute::type='document']/tei:opener/tei:dateline/ 
: and sorts by frequency.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']

let $q := 2 (: Type desired number of dates in datelines (e.g. 2, 4) :)

for $doc in $docs
  let $vol := $doc/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']
  let $id := concat('https://history.state.gov/historicaldocuments/',data($vol),'/',data($doc/attribute::xml:id))
  let $date := $doc/tei:opener/tei:dateline/tei:date
  let $dateCount := count($date)
where (xs:integer($dateCount) eq $q)
return
  <doc uri="{$id}">{$doc}</doc>
