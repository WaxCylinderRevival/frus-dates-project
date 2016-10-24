(:~ 
: Script Overview: This .xq script reports documents that
: have @when date values outside of parent volume coverage
: date ranges.
: The results are sorted by frequency (descending) and 
: then by date (ascending).
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
: @status: work-in-progress, fix: $outlierWhen where clause
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>
**`@when` data outside of date coverage range of parent _FRUS_ volume**

Outlier data in `@when` | Frequency | Issue | Coverage Dates of Parent Volumes | Date Entries | URIs
--- | --- | --- | --- | --- | ---
{
  
let $coll := collection('frus-volumes')

let $bibliography := collection('bibliography')

(: Find all outlier entries per volume :)

let $outlierVolumes :=

  for $vol in ($coll/tei:TEI)
  
    let $volId := $vol//tei:publicationStmt/tei:idno[attribute::type='frus']
    
    let $bibVol := $bibliography//volume[attribute::id[matches(., concat('^',data($volId),'$'))]]
    
    let $volCoverage := substring(data(($bibVol//coverage[not(attribute::type)])),1,4)
    
    let $volFrom := 
        if (empty($bibVol//coverage[attribute::type='from']))
         then $volCoverage
         else substring(data($bibVol//coverage[attribute::type='from']),1,4)
         
    let $volTo :=
        if (empty($bibVol//coverage[attribute::type='to']))
        then $volCoverage
        else substring(data($bibVol//coverage[attribute::type='to']),1,4)
  
let $outliers :=
  for $w in $vol//tei:div[attribute::type='document']//tei:opener/tei:dateline/tei:date[attribute::when]
   
    let $wDocId := data($w/ancestor::node()/tei:div[attribute::type='document'][functx:is-ancestor(.,$w)]/attribute::xml:id)
         
    let $when := $w/attribute::when/data()
    let $whenValue := substring($when,1,4)
  
    let $possError :=
        if (xs:integer($whenValue) lt xs:integer($volFrom) and (xs:integer($whenValue) lt 1776))
        then "EARLIER than coverage dates and outside of FRUS range"
        else
          if (xs:integer($whenValue) lt xs:integer($volFrom))
          then "EARLIER than coverage dates"
          else
            if (xs:integer($whenValue) gt xs:integer($volTo) and (xs:integer($whenValue) gt 1988))
            then "LATER than coverage dates and outside of FRUS date range"
            else
              if (xs:integer($whenValue) gt xs:integer($volTo))
              then "LATER than coverage dates"
              else ()
          
    where (xs:integer($whenValue) lt xs:integer($volFrom)) or (xs:integer($whenValue) gt xs:integer($volTo))
      
    order by $when ascending
  
    return 
      <outlier id="{$wDocId}">
          <whenDate>{data($when)}</whenDate>
          <whenEntry>{normalize-space(data($w))}</whenEntry>
          <possibleError>{$possError}</possibleError>
          <url>{concat('https://history.state.gov/historicaldocuments/',data($volId),'/',data($wDocId))}</url>
        </outlier>
  where (not(empty($outliers)))
  order by $volId ascending
  return
  <volume>
    <id>{data($volId)}</id>
    <coverageSingle>{data($bibVol//coverage[not(attribute::type)])}</coverageSingle>
    <coverageFrom>{data($bibVol//coverage[attribute::type='from'])}</coverageFrom>
    <coverageTo>{data($bibVol//coverage[attribute::type='to'])}</coverageTo>
    <outliers>
      {$outliers}
    </outliers>
  </volume> 

let $outlier := $outlierVolumes/outliers/outlier
for $distinct in $outlier/whenDate

let $freq := count($outlier/whenDate[matches(.,$distinct)])

let $volDates :=
  for $vol in $outlierVolumes[outliers/outlier/whenDate[matches(.,$distinct)]]
  return
       if ($vol/coverageSingle eq '')
       then normalize-space(concat('<li>',data($vol/coverageFrom),' to ',data($vol/coverageTo),'</li>'))
       else normalize-space(concat('<li>',data($vol/coverageSingle),'</li>'))

let $entries :=
  for $e in $outlier[whenDate[matches(.,$distinct)]]/whenEntry
  return concat('<li>',normalize-space($e),'</li>')
  
let $urls :=
  for $o in $outlier[whenDate[matches(.,$distinct)]]
  return concat('<li>',normalize-space($o/url),'</li>')  
  
order by $freq descending, $distinct ascending
  
return 
concat(data($distinct),' | ', $freq,' | `@when` outside of volume date range | <ul>',string-join($volDates),'</ul> | <ul>',string-join($entries),'</ul> | <ul>',string-join($urls),'</ul>&#10;')
}
</text>