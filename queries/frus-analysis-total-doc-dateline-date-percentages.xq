xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace frus="http://history.state.gov/frus/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')

let $doc := $coll//tei:div[attribute::type='document'][not(matches(tei:head,'(Editorial|Editor’s)'))][not(ancestor::frus:attachment)]

let $dateline := $doc[descendant::tei:dateline]
let $datelinePercent := format-number(count($dateline) div count($doc), '##0.##%')

let $dateInDateline := $dateline[descendant::tei:date]
let $dateInDatelinePercent := format-number(count($dateInDateline) div count($doc), '##0.##%')

let $currentDate := concat(functx:month-name-en(current-date()),' ',day-from-date(current-date()), ', ', year-from-date(current-date()))

return concat('As of ', $currentDate,':&#10;Total Historical Documents: ', count($doc),'&#10;Total Historical Documents with `dateline`: ',count($dateline),' (', $datelinePercent ,')&#10;Total Historical Documents with `dateline//date`: ', count($dateInDateline),' (', $dateInDatelinePercent,')')