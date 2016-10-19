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

let $scenarios :=
  <scenarios>
    <no-attributes label="No Attributes (all)">{$q/tei:date[not(attribute::*)]}</no-attributes>
    <undated label="* No Attributes, undated">{ $q/tei:date[not(attribute::*)][contains(.,'ndated')]}</undated>
    <notUndated label="* No Attributes, not undated">{$q/tei:date[not(attribute::*)][not(contains(.,'ndated'))]}</notUndated>
    <fromAndTo label="`@from` and `@to`">{$q/tei:date[attribute::from][attribute::to]}</fromAndTo>
    <fromButNoTo label="`@from` but no `@to`">{$q/tei:date[attribute::from][not(attribute::to)]
}</fromButNoTo>
    <toButNoFrom label="`@to` but no `@from`">{$q/tei:date[attribute::to][not(attribute::from)]}</toButNoFrom>
    <when-iso label="`@when-iso`">{$q/tei:date[attribute::when-iso]}</when-iso>
    <from-isoAndTo-iso label="`@from-iso` and `@to-iso`">{$q/tei:date[attribute::from-iso][attribute::to-iso]}</from-isoAndTo-iso>
  </scenarios>

for $scenario in $scenarios/child::node()
  let $s :=
 $scenario ! (string(./attribute::label), count(./tei:date),normalize-space(./tei:date[1]),normalize-space(./tei:date[last()]))
 let $sRow := concat($s[1],' | ',$s[2],' | ',$s[3],'; ',$s[4],' | &#10;')
  return 
   $sRow
}
</text>
