(:~ 
: Script Overview: This .xq script evaluates @when
: values that are yyyy-mm or yyyy only and suggests
: @notBefore and @notAfter values based on rules.
: Issues are grouped by volume and then document.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-01
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $leapYears := (1860, 1864, 1868, 1872, 1880, 1884, 1888, 1892, 1896, 1904, 1908, 1912, 1916, 1920, 1924, 1928, 1932, 1936, 1940, 1944, 1948, 1952, 1956, 1960, 1964, 1968, 1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012, 2016, 2020)
(: Note: 1900 was not a leap year :)

let $days31 := (1, 3, 5, 7, 8, 10, 12)
let $days30 := (4, 6, 9, 11)
let $days28or29 := (2)

let $coll := collection('frus-volumes')

for $v in ($coll/tei:TEI)

let $vID := $v//tei:publicationStmt/tei:idno[attribute::type='frus']

let $docIssues :=

  for $doc in $v//tei:div[attribute::type='document']
  
  let $docID := data($doc/attribute::xml:id)
  let $volID := data($doc/ancestor::tei:TEI/attribute::xml:id)
  let $url := concat('https://history.state.gov/historicaldocuments/',$volID,'/',$docID)
  
  let $impreciseWhens :=
    for $d in $doc//tei:dateline/tei:date
    let $w := normalize-space($d/attribute::when)
    let $year := xs:integer(data(substring($w,1,4)))
    let $month := xs:integer(data(substring($w,6,2)))

    let $notBefore :=
    
      if (matches($w,'^\d{4}$'))
      then concat($w,'-01-01T00:00:00')
      else 
        if (matches($w,'^\d{4}-\d{2}$'))
        then concat($w,'-01T00:00:00')
          else 'error'
        
    let $notAfter := 
      if (matches($w,'^\d{4}$'))
      then concat($w,'-12-31T23:59:59')
      else 
        if (matches($w,'^\d{4}-\d{2}$'))
        then
          if ($month = $days30)
          then concat($w,'-30T23:59:59')
          else          
            if (xs:integer(data(substring($w,6,2))) = $days31)
            then concat($w,'-31T23:59:59')
            else
              if ($year = $leapYears)
              then concat($w,'-29T23:59:59')
              else
                if (not($year = $leapYears))
                then concat($w,'-28T23:59:59')
                else 'wait'
  
        else 'error'

    where 
      ((matches($w,'^\d{4}$')) or (matches($w,'^\d{4}-\d{2}$'))) 
      and
      (empty($d/attribute::notBefore))
      and
      (empty($d/attribute::notAfter))
      and
      (empty($d/attribute::ana))
      return 
       <impreciseDate>
         <original>{$d}</original>
         <replacement>{functx:add-attributes($d, (xs:QName('notBefore'), xs:QName('notAfter'), xs:QName('ana')), ($notBefore ,$notAfter,'#date_imprecise-inferred-from-date-rules'))}</replacement>
       </impreciseDate>

  let $frOriginal := (' xmlns="http://www.tei-c.org/ns/1.0" ')
  let $toOriginal := (' ')
       
  let $frReplacement := ('([0-9])\.</date>','\s\s+', ' xmlns="http://www.tei-c.org/ns/1.0"','([a-z]) \[\?\](\d{4})','(January|February|March|April|May|June|July|August|September|October|November|December)(\d{4})')
  let $toReplacement := ('$1</date>.',' ', '','$1[?] $2','$1 $2')
       
  where not(empty($impreciseWhens))
  
  return 
  concat('- [x] ',$url,'&#10;',string-join(
    ('  - [x] Change `date` from &#10;```xml',functx:replace-multi(serialize(functx:remove-attributes-deep($impreciseWhens/original/child::*,('xmlns','frus:xmlns'))),$frOriginal, $toOriginal),'```&#10;to&#10;```xml',functx:replace-multi(serialize(functx:remove-attributes-deep($impreciseWhens/replacement/child::*,('xmlns','frus:xmlns'))),$frReplacement, $toReplacement),'```'),'&#10;'))

where not(empty($docIssues))

return concat('Enhance imprecise `when` values in ', $vID,'&#10;',string-join($docIssues,'&#10;'),'&#10;----------&#10;')