xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']

(: generalStats :)

let $docCount := count($docs) (: 192930 :)
let $eNoteCount := count($docs/tei:head[not(note)][contains(., 'Editorial Note')]) (: 7765 :)
let $eNotePercent := format-number((($eNoteCount div $docCount) * 100),'###0.##') (: 4.02 :)
let $hDocCount := $docCount - $eNoteCount (: 185165 :)
let $hDocPercent := format-number((($hDocCount div $docCount) * 100),'##0.##') (: 95.98 :)
let $date := current-date()
let $dateNatLang := concat(functx:month-name-en($date),' ', year-from-date($date))
let $generalStats := concat('As of ', $dateNatLang, ', the Foreign Relations of the United States (FRUS) series contains ', $docCount, ' documents. Of these FRUS documents, ', $hDocCount, ' (', $hDocPercent, '%) may be classified as historical documents while ', $eNoteCount, ' (', $eNotePercent, '%) are categorized as editorial notes.')

return $generalStats