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

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

let $q := $docs//tei:dateline[tei:date[not(attribute::when)]]

(: tei:date w/no attributes :)

let $scenarios :=

  let $noAttributes := $q/tei:date[not(attribute::*)]
  
  let $undated := $q/tei:date[not(attribute::*)][contains(.,'ndated')]
  
  let $notUndated := $q/tei:date[not(attribute::*)][not(contains(.,'ndated'))]

  let $qFromTo := $q/tei:date[attribute::from][attribute::to]

  let $qFromNoTo := $q/tei:date[attribute::from][not(attribute::to)]
  
  let $qToNoFrom := $q/tei:date[attribute::to][not(attribute::from)]
  
  let $qWhenISO := $q/tei:date[attribute::when-iso]

  let $qFTiso := $q/tei:date[attribute::from-iso][attribute::to-iso]
  
  return
    <scenarios>
      <no-attributes>{$noAttributes}</no-attributes>
      <undated>{$undated}</undated>
      <notUndated>{$notUndated}</notUndated>
      <fromAndTo>{$qFromTo}</fromAndTo>
      <fromButNoTo>{$qFromNoTo}</fromButNoTo>
      <toButNoFrom>{$qToNoFrom}</toButNoFrom>
      <when-iso>{$qWhenISO}</when-iso>
      <from-isoAndTo-iso>{$qFTiso}</from-isoAndTo-iso>
    </scenarios>

let $i :=
 $scenarios/child::node() ! (name(.), count(./tei:date),normalize-space(./tei:date[1]),normalize-space(./tei:date[last()]))
return 
concat($i[1],' | ',$i[2],' | ',$i[3],'; ',$i[4],' | &#10;')
  
(:  
  concat('`@from-iso` and `@to-iso` | ',count($qFTI),' | ',normalize-space($qFTI[1]),'; ',normalize-space($qFTI[last()]),' | &#10;')

return

<text>
Issue | Frequency | Example of Current FRUS Encoding | Examples of Possibly Errant Encoding
--- | --- | --- | ---
{$noAttributes}
{$undated}
{$notUndated}
{$qFromTo}
{$qFromNoTo}
{$qToNoFrom}
{$qWhenISO}
{$qFTiso}
</text>
:)