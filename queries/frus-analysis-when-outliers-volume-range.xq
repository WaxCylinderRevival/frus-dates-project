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

Outlier data in `@when` | Frequency | Issue | Date Entries | Volume Coverage Dates | URIs
--- | --- | --- | --- | --- | ---
{

let $coll := collection('frus-volumes')
let $docs := $coll//tei:div[attribute::type='document']
let $total := count($docs)
let $vols := $coll//tei:publicationStmt/tei:idno[attribute::type='frus']

let $bibliography := collection('bibliography')

(: Find all outlier entries :)
let $outliers :=  
  <outliers>
  {
    for $w in $docs/tei:opener/tei:dateline/tei:date[attribute::when]
    (: [position() = 1000 to 2000] testing subset  :)
 
    let $wDoc := data($w/ancestor::node()/tei:div[attribute::type='document'][functx:is-ancestor(.,$w)]/attribute::xml:id)
    let $wVol := $w/ancestor::node()//tei:publicationStmt/tei:idno[attribute::type='frus']    
    let $when := $w/attribute::when/data()
    let $whenValue := substring($when,1,4)
    let $bibVol := $bibliography//volume[attribute::id[matches(.,
    concat('^',data($wVol),'$'))]]
    let $volCoverage := substring(data(($bibVol//coverage[not(attribute::type)])),1,4)
    let $volFrom := 
      if (empty($bibVol//coverage[attribute::type='from']))
       then $volCoverage
       else substring(data($bibVol//coverage[attribute::type='from']),1,4)
    let $volTo :=
      if (empty($bibVol//coverage[attribute::type='to']))
      then $volCoverage
      else substring(data($bibVol//coverage[attribute::type='to']),1,4)
    
    where (xs:integer($whenValue) < xs:integer($volFrom)) or (xs:integer($whenValue) > xs:integer($volTo))
    
    order by $when
    
    return 

      <outlier>
        <whenDate>{data($when)}</whenDate>
        <whenEntry>{data($w)}</whenEntry>
        <parentDocument>{$wDoc}</parentDocument>
        <parentVolume>
          <id>{data($wVol)}</id>
          <coverageSingle>{data($volCoverage)}</coverageSingle>
          <coverageFrom>{$bibVol//coverage[attribute::type='from']}</coverageFrom>
          <coverageTo>{$bibVol//coverage[attribute::type='to']}</coverageTo>
        </parentVolume>
        <url>{concat('https://history.state.gov/historicaldocuments/',data($wVol),'/',data($wDoc))}</url>
      </outlier>
    }
  </outliers>

    
(: Find distinct @when dates across all outlier entries and return row data :)          

let $rows :=

  for $distinctOutlier in distinct-values($outliers/outlier/whenDate)
  
    let $freq := count($outliers/outlier/whenDate[matches(.,$distinctOutlier)]) 
    
    let $matches := $outliers/outlier[whenDate[matches(.,$distinctOutlier)]]
    
    let $matchingEntries :=
      for $entryMatch in $matches/whenEntry
      return concat('<li>',normalize-space(data($entryMatch)),'</li>')
      
    let $matchingCoverage :=
      for $coverageMatch in $matches/parentVolume
      return 
        if (empty($coverageMatch/coverageSingle))
        then normalize-space(concat('<li>',data($coverageMatch/coverageFrom),' to ',data($coverageMatch/coverageTo),'</li>'))
        else normalize-space(concat('<li>',data($coverageMatch/coverageSingle),'</li>')) 
      
    let $matchingURIs :=
      for $uriMatch in $matches/url
      return concat('<li>',data($uriMatch),'</li>')
  
  order by $freq descending, $distinctOutlier ascending
  
  return concat(normalize-space(data($distinctOutlier)), ' | ', $freq, ' | `@when` outside of volume date range | <ul>',string-join($matchingEntries),'</ul> | <ul>',string-join($matchingCoverage),'</ul> | <ul>',string-join($matchingURIs),'</ul>&#10;')

  return $rows
} 
</text>