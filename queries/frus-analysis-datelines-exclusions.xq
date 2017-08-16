(:~ 
: Script Overview: This .xq script counts 
: the number of datelines within a document
: but not in attachments and sorts by
: frequency.
: FRUS-VOLUMES//tei:div[attribute::type='document']//tei:dateline[not(ancestor::frus:attachment)] 
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-08
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace frus="http://history.state.gov/frus/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>
Number of `dateline` | Frequency | Overall Percentage
--- | --- | ---
{

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document'][not(matches(tei:head, '(Editorial|Editor’s)'))]
let $total := count($docs)

let $dlCounts :=
  for $doc in $docs
  let $id := data($doc/attribute::xml:id)
  let $dl := $doc//tei:dateline[not(ancestor::frus:attachment)]
  
  (: [not(ancestor::tei:quote)][not(ancestor::tei:cit)] :)
  let $dlCount := count($dl)
  return
    <doc id="{$id}">{$dlCount}</doc>
    
for $d in distinct-values(data($dlCounts))
  let $match := count($dlCounts[matches(.,$d)])
  let $mPercent := format-number(($match div $total),'##0.##%')
  order by xs:integer($match) descending
  return concat($d,' | ',$match,' | ',$mPercent,'&#10;')

}
</text>