xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace frus="http://history.state.gov/frus/ns/1.0";


let $coll := collection('frus-volumes')
let $div := $coll//tei:div
let $divCount := count($div)
let $dateCount := count($div[attribute::frus:doc-dateTime-min])
let $percent := format-number(($dateCount div $divCount), '0.##%')
return concat('As of ',
  current-date(),
  ', ',
  $dateCount, 
  ' of ',
  $divCount, 
  ' (', 
  $percent,
  ') ',
  ' FRUS `tei:div` have `@frus:doc-dateTime-min` '
  )