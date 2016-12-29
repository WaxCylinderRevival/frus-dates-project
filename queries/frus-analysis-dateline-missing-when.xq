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

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>
Issue | Frequency | Example(s) of Current FRUS Date Value
--- | --- | ---
{

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $q := $docs//tei:dateline[tei:date[not(attribute::when)]]

(: tei:date w/no attributes :)

let $noAttributes :=
  let $qNoA := $q/tei:date[not(attribute::*)]
  return 
  concat('No attributes (all) | ',count($qNoA),' | ',string-join((normalize-space($qNoA[1]),normalize-space($qNoA[last()])),'; '))
  
let $undated := 
  let $qU := $q/tei:date[not(attribute::*)][contains(.,'ndated')]
  return
  concat('No attributes, undated | ',count($qU),' | ',string-join((normalize-space($qU[1]),normalize-space($qU[last()])),'; '))
  
let $notUndated :=
  let $qNU := $q/tei:date[not(attribute::*)][not(contains(.,'ndated'))]
  return
  concat('No attributes, not undated | ',count($qNU),' | ',string-join((normalize-space($qNU[1]),normalize-space($qNU[last()])),'; '))
  
let $qFromTo := 
  let $qFT := $q/tei:date[attribute::from][attribute::to]
  return
  concat('`@from` and `@to` | ',count($qFT),' | ',string-join((normalize-space($qFT[1]), normalize-space($qFT[last()])),'; '))

let $qFromNoTo := 
  let $qF := $q/tei:date[attribute::from][not(attribute::to)]
  return
  concat('`@from` but no `@to` | ',count($qF),' | ',string-join((normalize-space($qF[1]), normalize-space($qF[last()])),'; '))
  
let $qToNoFrom := 
  let $qT := $q/tei:date[attribute::to][not(attribute::from)]
  return
  concat('`@to` but no `@from` | ',count($qT),' | ',string-join((normalize-space($qT[1]),normalize-space($qT[last()])),'; '))
  
  let $qNotBeforeNotAfter := 
  let $qNBNA := $q/tei:date[attribute::notBefore][attribute::notAfter]
  return
  concat('`@notBefore` and `@notAfter` | ',count($qNBNA),' | ',string-join((normalize-space($qNBNA[1]), normalize-space($qNBNA[last()])),'; '))

let $qNotBeforeNoNotAfter := 
  let $qNBNNA := $q/tei:date[attribute::from][not(attribute::to)]
  return
  concat('`@notBefore` but no `@notAfter` | ',count($qNBNNA),' | ',string-join((normalize-space($qNBNNA[1]),normalize-space($qNBNNA[last()])),'; '))
  
let $qNotAfterNoNotBefore := 
  let $qNANNB := $q/tei:date[attribute::to][not(attribute::from)]
  return
  concat('`@notAfter` but no `@notBefore` | ',count($qNANNB),' | ',string-join((normalize-space($qNANNB[1]),normalize-space($qNANNB[last()])),'; '))
  
let $qWhenISO := 
  let $qWI := $q/tei:date[attribute::when-iso]
  return
  concat('`when-iso` | ',count($qWI),' | ',string-join((normalize-space($qWI[1]),normalize-space($qWI[last()])),'; '))

let $qFTiso :=
  let $qFTI := $q/tei:date[attribute::from-iso][attribute::to-iso]
  return
  concat('`@from-iso` and `@to-iso` | ',count($qFTI),' | ',string-join((normalize-space($qFTI[1]),normalize-space($qFTI[last()])),'; '))

return

string-join(($noAttributes, $undated, $notUndated, $qFromTo, $qFromNoTo, $qNotBeforeNotAfter, $qNotBeforeNoNotAfter, $qNotAfterNoNotBefore, $qToNoFrom,  $qWhenISO, $qFTiso),'&#10;')
}
</text>