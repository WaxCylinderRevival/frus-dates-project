(:~ 
: Script Overview: This .xq script gathers all unique placeNames in 
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline/tei:placeName 
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

let $coll := collection('frus-volumes')

let $placeEntry := data($coll//tei:div[attribute::type='document']/tei:opener/tei:dateline/tei:placeName)

for $p in (distinct-values($placeEntry))[position()=1 to 3]
  let $pNormal := normalize-space($p)
  let $matches :=
    for $doc in $coll//tei:div[attribute::type='document']
    let $docID := data($doc/attribute::xml:id)
    where matches($doc/tei:opener/tei:dateline/tei:placeName[position()=1],$p)
    return <document>{$docID}</document>
  order by $pNormal ascending
  order by $pNormal
  return 
  <match>
    <placeName>{$pNormal}</placeName>
    {$matches}
  </match>


(:
  let $matches := 
    for $m in $coll//tei:div[attribute::type='document'][matches(normalize-space(tei:opener/tei:dateline/tei:placeName),$pNormal)]
    let $docID := data($m/attribute::xml:id)
    return <document>{$docID}</document>
  let $matches := 
    for $m in $coll//tei:div[attribute::type='document'][matches(normalize-space(tei:opener/tei:dateline/tei:placeName),$pNormal)]
    let $docID := data($m/attribute::xml:id)
    return <document>{$docID}</document>    
:)