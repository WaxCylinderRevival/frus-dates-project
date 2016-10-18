xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $q := collection('frus-volumes')//tei:dateline[tei:date[not(attribute::when)]]

(: tei:date w/no attributes :)

let $qNoA := $q/tei:date[not(attribute::*)]
let $undated := $qNoA[contains(.,'ndated')]
let $NotUndated := $qNoA[not(contains(.,'ndated'))]

let $qFromTo := $q/tei:date[attribute::from][attribute::to]

let $qFromNoTo := $q/tei:date[attribute::from][not(attribute::to)]

let $qToNoFrom := $q/tei:date[attribute::to][not(attribute::from)]

let $qWhenISO := $q/tei:date[attribute::from-iso]

let $r := $qWhenISO

return

<results>
  <count>{count($r)}</count>
  <examples>{$r}</examples>
</results> 