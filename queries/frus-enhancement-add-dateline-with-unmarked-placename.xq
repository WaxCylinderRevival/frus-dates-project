(:~ 
: Script Overview: This .xq script evaluates 
: FRUS volumes containing documents missing 
: <dateline> and creates <dateline> per 
: document by either 1) repeating the <placeName> and
: <date> from <head> or 2) searching the head for the 
: first date match, first and second times, and place 
: names matching an editable city list.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-01
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

let $coll := collection('frus-volumes')

for $v in ($coll/tei:TEI)

let $vID := $v//tei:publicationStmt/tei:idno[attribute::type='frus']

let $docIssues :=

  for $doc in $v//tei:div[attribute::type='document'][not(contains(tei:head,'Editorial'))]
  
  let $docID := data($doc/attribute::xml:id)
  let $volID := data($doc/ancestor::tei:TEI/attribute::xml:id)
  let $url := concat('https://history.state.gov/historicaldocuments/',$volID,'/',$docID)

  let $head := functx:remove-elements-not-contents($doc//tei:head, 'hi')

  let $dResult :=
  
    let $d := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space(serialize(data($head))),'(January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}, \d{4}'))),'\s\s+'))[1]
        
    let $year := substring-after($d, ', ')
    let $month :=
          switch (substring-before($d,' '))
           case "January" return "01"
           case "February" return "02"
           case "March" return "03"
           case "April" return "04"
           case "May" return "05"
           case "June" return "06"
           case "July" return "07"
           case "August" return "08"
           case "September" return "09"
           case "October" return "10"
           case "November" return "11"
           case "December" return "12"
           default return "error"         
    let $day := data(substring-after(substring-before($d, ','),' '))
        
    let $dISO := concat($year,'-',$month,'-',functx:pad-integer-to-length($day,2))
    
    let $phraseBeforeDate := 

    (: 
    normalize-space(serialize(functx:substring-after-last(normalize-space(substring-before(serialize(data()),concat(', ', data($d)))),', ')))
    :)
    
    functx:substring-after-last(substring-before(normalize-space(serialize(data($head))),concat(', ', data($d))),', ')
    
    let $phraseAfterDate := substring-after(normalize-space(serialize(data($head))), concat(data($d),', '))
    
    let $timeFrom := 
    
    if (matches(data($phraseBeforeDate),'(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
    then 
(
  tokenize(
    functx:trim(
      serialize(
        functx:get-matches(
          data($phraseBeforeDate),
          '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'
        )
      )
  )
    ,'\s\s+')
)[1]
    else 
      if (matches(data($phraseAfterDate),'(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
      then
      (
  tokenize(
    functx:trim(
      serialize(
        functx:get-matches(
          data($phraseAfterDate),
          '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'
        )
      )
  )
    ,'\s\s+')
)[1]
      
      else null

    let $timeFromISO :=
    
      if (matches($timeFrom, 'noon'))
      then '12:00:00'
      else
        if (matches($timeFrom, 'midnight'))
        then '00:00:00'
        else
          if (contains($timeFrom, 'a.m.'))
          then
            replace(
              replace(
                replace($timeFrom,' [ap]\.m\.',':00'),
              '^(\d{1}):','0$1:'),
            '^(\d{2}):00$','$1:00:00')
            else
              if (contains($timeFrom, 'p.m.'))
              then
              
              let $replacePM :=
              replace($timeFrom,' [ap]\.m\.',':00')
              let $add12 := xs:integer(substring-before($replacePM,':')) + 12
                
              let $finish := replace(
                replace($replacePM, '^\d{1,2}:', concat(xs:string($add12), ':')),
                '^(\d{2}):00$','$1:00:00')
            return $finish
                 else ''
 
    let $timeTo := 
    
    if (matches($phraseBeforeDate, '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
    then
      (
        tokenize(
          functx:trim(
            serialize(
              functx:get-matches(
                data($phraseBeforeDate),
                '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'
              )
            )
        )
          ,'\s\s+')
      )[2]
      else
        if (matches($phraseAfterDate, '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
        then
         (
        tokenize(
          functx:trim(
            serialize(
              functx:get-matches(
                data($phraseAfterDate),
                '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'
              )
            )
        )
          ,'\s\s+')
      )[2]
        else null

    let $timeToISO :=
         
      if (matches($timeTo, 'noon'))
      then '12:00:00'
      else
        if (matches($timeTo, 'midnight'))
        then '00:00:00'
        else
          if (contains($timeTo, 'a.m.'))
          then
            replace(
              replace(
                replace($timeTo,' [ap]\.m\.',':00'),
              '^(\d{1}):','0$1:'),
            '^(\d{2}):00$','$1:00:00')
            else
              if (contains($timeTo, 'p.m.'))
              then
              
              let $replacePMto :=
              replace($timeTo,' [ap]\.m\.',':00')
              let $add12to := xs:integer(substring-before($replacePMto,':')) + 12
                
              let $finishTo := replace(
                replace($replacePMto, '^\d{1,2}:', concat(xs:string($add12to), ':')),
                '^(\d{2}):00$','$1:00:00')
            return $finishTo
                 else ''        
    return 
    
    if (exists($timeTo))
    then 
    <date from="{concat(data($dISO),'T',data($timeFromISO))}" to="{concat(data($dISO),'T',data($timeToISO))}" ana="#date_undated-inferred-from-document-head">{$d}, {$timeFrom} to {$timeTo}</date>
    else
      if (exists($timeFrom))
      then 
      <date when="{concat(data($dISO),'T',data($timeFromISO))}" ana="#date_undated-inferred-from-document-head">{$d}, {$timeFrom}</date>
      else
        if (exists($d))
        then <date when="{data($dISO)}" ana="#date_undated-inferred-from-document-head">{$d}</date>
        else <date>undated</date>
   
  let $date := 
    if (exists($head/tei:date))
    then
      normalize-space(serialize(
    functx:remove-attributes-deep(functx:remove-elements-not-contents($doc//tei:date,'hi'),('xmlns','xmlns:frus','xmlns:xi'))))  
      else
      serialize($dResult)

  let $placeEntry := data($coll//tei:div[attribute::type='document']//tei:dateline/tei:placeName)
  
  let $placeList :=
    for $p in distinct-values($placeEntry)
    let $pNormal := normalize-space($p)
    order by $pNormal ascending
    return <place>{$pNormal}</place>
    
  let $phraseBefore :=       
        functx:substring-after-last(
          normalize-space(
            substring-before(
              serialize(data($head)), ', '
              (:
              concat(', ', data($date))
              :)
            )
          ),
         ', ')    

  let $pMatch := 

    let $cities := '(Abu Dhabi|Abuja|Accra|Addis Ababa|Algiers|Amman|Andorra la Vella|Ankara|Antananarivo|Apia|Ashgabat|Asmara|Astana|Asuncion|Athens|Baku|Bandar Seri Begawan|Baghdad|Bamako|Bangkok|Bangui|Banjul|Basseterre|Beijing|Beirut|Belgrade|Belmopan|Belfast|Berlin|Bern|Bishkek|Bissau|Bogota|Brasilia|Bratislava|Brazzaville|Bridgetown|Brussels|Budapest|Bucharest|Buenos Aires|Bujumbura|Cairo|Canberra|Caracas|Cardiff|Castries|Cayenne|Chisinau|Kishinev|Colombo|Conakry|Copenhagen|Dakar|Damascus|Dhaka|Dar es Salaam|Dili|Djibouti|Doha|Dublin|Dushanbe|Edinburgh|Freetown|Gaborone|Georgetown|Guatemala City|Hanoi|Harare|Havana|Helsinki|Honiara|Islamabad|Jakarta|Juba|Kabul|Kathmandu|Kampala|Khartoum|Kiev|Kigali|Kingston|Kingstown|Kinshasa|Kuala Lumpur|Kuwait City|La Paz|Libreville|Lilongwe|Lima|Lisbon|Ljubljana|Lome|London|London|Luanda|Lusaka|Luxembourg|Madrid|Majuro|Malabo|Male|Managua|Manama|Manila|Maputo|Maseru|Mbabana|Melekeok|Mexico City|Minsk|Mogadishu|Monaco|Monrovia|Montevideo|Moroni|Moscow|Muscat|Nairobi|Nassau|N&#39;Djamena|New Delhi|Niamey|Nicosia|Nouakchott|Nuku&#39;alofa|Ouagadougou|Oslo|Ottawa|Palikir|Panama City|Paramaribo|Paris|Phnom Penh|Podgorica|Port au Prince|Port Louis|Port Moresby|Port of Spain|Port Vila|Porto Novo|Prague|Praia|Pretoria|Pristina|Pyongyang|Quito|Rabat|Rangoon|Yangon|Reykjavik|Riga|Riyadh|Rome|Roseau|Saint George&#39;s|Saint John&#39;s|San Jose|San Marino|San Salvador|Sanaa|Santiago|Santo Domingo|Sao Tome|Sarajevo|Seoul|Singapore|Skopje|Sofia|Stockholm|Suva|Taipei|Tallinn|Tarawa Atoll|Tashkent|Tbilisi|Tegucigalpa|Tehran|Tel Aviv|Amsterdam|Thimphu|Tirana|Tirane|Tokyo|Tripoli|Tunis|Ulaanbaatar|Vaduz|Vaiaku village|Valletta|Vatican City|Victoria|Vienna|Vientiane|Vilnius|Warsaw|Washington|Washington, D.C.|Wellington|Windhoek|Yamoussoukro|Yaounde|Yerevan|Zagreb)'
    
    return
      if (matches($phraseBefore, $cities))
      then <placeName>{functx:trim(normalize-space(serialize(functx:get-matches($phraseBefore, $cities))))}</placeName>
      else '' 

  let $fr := (' xmlns="http://www.tei-c.org/ns/1.0"')
  let $to := ('')

  let $place := 
    if (exists($head/tei:placeName))
    then 
      functx:replace-multi(normalize-space(serialize(
    functx:remove-attributes-deep($head/tei:placeName,('xmlns','xmlns:frus','xmlns:xi')))),$fr,$to)
    else ''


let $newDateline :=
    
      if (exists($place) and not($place eq ''))
      then
        <dateline>
          {$place}, {functx:replace-multi($date,$fr,$to)}
        </dateline>
      else
        if (exists($pMatch) and not($pMatch eq ''))
        then
          <dateline>
            {serialize($pMatch)}, {functx:replace-multi($date,$fr,$to)}
          </dateline>
        else
         <dateline>
              {functx:replace-multi($date, $fr, $to)}
         </dateline>

let $unmarkedDateline := 
  for $u in $doc//tei:p[tei:date]
  let $s := serialize(functx:remove-attributes-deep($u,('xmlns','xmlns:frus','xmlns:xi')))
  let $sFr := ('<p([ >])', '</p>', ' xmlns="http://www.tei-c.org/ns/1.0"')
  let $sTo := ('<dateline$1', '</dateline>', '')
  return functx:replace-multi($s, $sFr, $sTo)

       
  where
    (: (exists($head/tei:date)) and:)
    
    (not(exists($doc//tei:dateline))) and
    ((not(empty($newDateline))) or not(empty($unmarkedDateline)))
  
  return 
  
    if (not(empty($unmarkedDateline)))
    then concat('- [x] ',$url,'&#10;',string-join(
  ('  - [x] Edit existing `p` to `dateline` (Move to `closer` as necessary):&#10;```xml&#10;',$unmarkedDateline,'&#10;```'),'&#10;'))
    else
      if (not(empty($newDateline)))
      then concat('- [x] ',$url,'&#10;',string-join(
      ('  - [x] Add `dateline`:&#10;```xml&#10;<dateline>',$newDateline,'</dateline>&#10;```'),'&#10;'))
      else 'error'

where 
  (not(empty($docIssues))) 
  (:
  and
  (matches($vID, 'frus1914-20v01'))
  :)

return concat('Add missing `dateline` in ', $vID,'&#10;',string-join($docIssues,'&#10;'), '&#10;----------&#10;')

(:
return string-join($docIssues,'&#10;')
:)
(:,'&#10;----------&#10;') :)