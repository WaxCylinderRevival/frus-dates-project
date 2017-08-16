(:~ 
: Script Overview: This .xq script creates a summary paragraph of
: total number of documents, editorial notes, and historical documents.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)

(: generalStats :)

let $eNoteCount := count($docs/tei:head[not(note)][matches(., '(Editorial Note|Editor’s Note)')])
let $eNotePercent := format-number(($eNoteCount div $total),'##0.##%')
let $hDocCount := $total - $eNoteCount
let $hDocPercent := format-number(($hDocCount div $total),'##0.##%')

let $date := current-date()
let $dateNatLang := concat(functx:month-name-en($date),' ', year-from-date($date))
let $generalStats := concat('As of ', $dateNatLang, ', the Foreign Relations of the United States (FRUS) series contains ', $total, ' documents. Of these FRUS documents, ', $hDocCount, ' (', $hDocPercent, ') may be classified as historical documents while ', $eNoteCount, ' (', $eNotePercent, ') are categorized as editorial notes.')

return $generalStats