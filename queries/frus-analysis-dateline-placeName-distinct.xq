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

let $placeEntry := data($coll//tei:div[attribute::type='document']//tei:dateline/tei:placeName)

for $p in distinct-values($placeEntry)
let $pNormal := normalize-space($p)
order by $pNormal ascending
return $pNormal

