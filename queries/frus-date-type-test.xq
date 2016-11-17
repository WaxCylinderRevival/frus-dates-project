xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

(:
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>

{
:)
  
let $coll := collection('frus-volumes')
for $dateAtt in data($coll//tei:date/attribute::when | from | to)

where 
  not($dateAtt castable as xs:date)
  and
  not($dateAtt castable as xs:dateTime)

return data($dateAtt)
