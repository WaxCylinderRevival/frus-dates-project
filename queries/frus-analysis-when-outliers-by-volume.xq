(:~ 
: Script Overview: This .xq script generates text for 
: GitHub issues per FRUS volume containing @when date 
: values outside of parent volume coverage date ranges.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2016-10
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

<text>
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


for $issue in $outlierVolumes

  let $issuetitle := concat(count($issue/outliers/outlier),' possible error(s) in volume ',data($issue/id))
  let $issueIntro := 
      if (data($issue/coverageSingle) eq '')
      then concat(data($issue/coverageFrom), ' to ',data($issue/coverageTo))
      else data($issue/coverageSingle)
  let $errors :=
    for $error in $issue/outliers/outlier   
    return concat('* [ ] ', $error/url,'&#10;  - ', $error/possibleError, '&#10;  - `@when` value: ', data($error/whenDate), '&#10;  - Recorded date: ', data($error/whenEntry),'&#10;')
  
return concat('-----&#10;',data($issuetitle),'&#10;**Volume:** ', data($issue/id),'&#10;**Volume Dates:** ', $issueIntro,'&#10;&#10;', string-join($errors,'&#10;'),'&#10;-----&#10;')
}
</text>