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
Issue | Frequency | Example of Current FRUS Encoding | Examples of Possibly Errant Encoding
--- | --- | --- | ---
{

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $q := $docs//tei:dateline[tei:date[not(attribute::when)]]

(: tei:date w/no attributes :)

let $noAttributes :=
  let $qNoA := $q/tei:date[not(attribute::*)]
  return 
  concat('No attributes (all) | ',count($qNoA),' | ',normalize-space($qNoA[1]),'; ',normalize-space($qNoA[last()]),' | &#10;')
  
let $undated := 
  let $qU := $q/tei:date[not(attribute::*)][contains(.,'ndated')]
  return
  concat('* No attributes, undated | ',count($qU),' | ',normalize-space($qU[1]),'; ',normalize-space($qU[last()]),' | &#10;')
  
let $notUndated :=
  let $qNU := $q/tei:date[not(attribute::*)][not(contains(.,'ndated'))]
  return
  concat('* No attributes, not undated | ',count($qNU),' | ',normalize-space($qNU[1]),'; ',normalize-space($qNU[last()]),' | &#10;')
  
let $qFromTo := 
  let $qFT := $q/tei:date[attribute::from][attribute::to]
  return
  concat('`@from` and `@to` | ',count($qFT),' | ',normalize-space($qFT[1]),'; ',normalize-space($qFT[last()]),' | &#10;')

let $qFromNoTo := 
  let $qF := $q/tei:date[attribute::from][not(attribute::to)]
  return
  concat('`@from` but no `@to` | ',count($qF),' | ',normalize-space($qF[1]),'; ',normalize-space($qF[last()]),' | &#10;')
  
let $qToNoFrom := 
  let $qT := $q/tei:date[attribute::to][not(attribute::from)]
  return
  concat('`@to` but no `@from` | ',count($qT),' | ',normalize-space($qT[1]),'; ',normalize-space($qT[last()]),' | &#10;')
  
let $qWhenISO := 
  let $qWI := $q/tei:date[attribute::when-iso]
  return
  concat('`when-iso` | ',count($qWI),' | ',normalize-space($qWI[1]),'; ',normalize-space($qWI[last()]),' | &#10;')

let $qFTiso :=
  let $qFTI := $q/tei:date[attribute::from-iso][attribute::to-iso]
  return
  concat('`@from-iso` and `@to-iso` | ',count($qFTI),' | ',normalize-space($qFTI[1]),'; ',normalize-space($qFTI[last()]),' | &#10;')

return

{$noAttributes}
{$undated}
{$notUndated}
{$qFromTo}
{$qFromNoTo}
{$qToNoFrom}
{$qWhenISO}
{$qFTiso}
}
</text>