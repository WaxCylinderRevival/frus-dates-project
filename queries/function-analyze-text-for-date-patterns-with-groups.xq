(: declare namespace dp='https://history.state.gov/ns/xquery/date-processing' :)

declare variable $local:regexes :=
  map {
  "month-regex" : "(January|February|March|April|May|June|July|August|September|October|November|December)",
  "month-regex-fr" : "(janvier|février|fevrier|mart|avril|mai|juin|juillet|août|aout|septembre|octobre|novembre|décembre|decembre)",
  "month-regex-sp" : "(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)",
  "day-regex" : "(\d{1,2})(?:st|d|nd|rd|th)?",
  "day-range-regex" : "(\d{1,2})(?:st|d|nd|rd|th)?\s*[-–—]\s*(\d{1,2})(?:st|d|nd|rd|th)?",
  "year-regex" : "(\d{4})",
  "day-spelled-out-regex" : "(?:(\d{1,2})(?:st|d|nd|rd|th)?|((?:thirty|twenty)?(?:-|–|\s+)?(?:thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first)?))",
  "year-spelled-out-regex" : "(one\s+thousand\s+(?:nine|eight)\s+hundred\s+(?:ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)?(?:-|–|\s+)?(?:nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)?)"
  }
;

declare function local:get-dates($source) {
  
    let $day-month-year-regex := $local:regexes?day-regex                       || '\s+'            || $local:regexes?month-regex      || ',?\s+'                    || $local:regexes?year-regex
    let $month-day-year-regex := $local:regexes?month-regex                     || '\s+'            || $local:regexes?day-regex        || ',?\s+'                    || $local:regexes?year-regex
    let $month-day-range-year-regex := $local:regexes?month-regex               || '\s+'            || $local:regexes?day-range-regex  || ',?\s+'                    || $local:regexes?year-regex 
    let $day-month-year-regex-fr := $local:regexes?day-regex        || '\s+'            || $local:regexes?month-regex-fr   || ',?\s+'                    || $local:regexes?year-regex
    let $day-month-year-regex-sp := $local:regexes?day-regex                    || '\s+(?:de\s+)?'  || $local:regexes?month-regex-sp   || ',?\s+(?:(?:de|del)\s+)?'  || $local:regexes?year-regex
    let $day-month-year-official-regex := $local:regexes?day-spelled-out-regex  || '\s+day\s+of\s+' || $local:regexes?month-regex      || ',\s+in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+'  || $local:regexes?year-spelled-out-regex
    
    return
        (            
            (:1:) analyze-string(normalize-space($source), $month-day-year-regex, "i"),
            (:2:) analyze-string(normalize-space($source), $month-day-range-year-regex, "i"),
            (:3:) analyze-string(normalize-space($source), $day-month-year-regex, "i"),
            (:4:) analyze-string(normalize-space($source), $day-month-year-regex-fr, "i"),
            (:5:) analyze-string(normalize-space($source), $day-month-year-regex-sp, "i"),
            (:6:) analyze-string(normalize-space($source), $day-month-year-official-regex, 'i')
        )
};

declare function local:month-to-mm($m) {
  
  switch (analyze-string(lower-case($m),'(january|janvier|enero|february|février|fevrier|febrero|march|mart|marzo|april|avril|abril|may|mai|mayo|june|juin|junio|july|juillet|julio|august|août|aout|agosto|september|septembre|septiembre|setiembre|october|octobre|octubre|november|novembre|noviembre|december|décembre|decembre|diciembre)',"i")/fn:match)
    case "January" 
      case "january" 
      case "janvier"
      case "enero" return "01"    
    case "February"
      case "february"
      case "février" 
      case "fevrier"  
      case "febrero" return "02"   
    case "March"
      case "march"
      case "mart"
      case "marzo" return "03"
    case "April"
      case "april"
      case "avril"
      case "abril" return "04"
    case "May"
      case "may"   
      case "mai"
      case "mayo" return "05"
    case "June"
      case "june"
      case "juin"
      case "junio" return "06"
    case "July"
      case "july"
      case "juillet"
      case "julio" return "07"
    case "August"
      case "august"
      case "août"
      case "aout"
      case "agosto" return "08"
    case "September"
      case "september"
      case "septembre"
      case "septiembre"
      case "setiembre" return "09"
    case "October"
      case "october"
      case "octobre"
      case "octubre" return "10"
    case "November"
      case "november"
      case "novembre"
      case "noviembre" return "11"
    case "December"
      case "december"
      case "décembre"
      case "decembre"
      case "diciembre" return "12"
    default return "error"
           
};

declare function local:ordinal-to-dd($dth) {
  
  switch (analyze-string($dth,'()?(thirty|twenty)?(-|–)?(thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first)',"i")/fn:match)
    case "thirty-first" return "31"
    case "thirtieth" return "30"
    case "twenty-ninth" return "29"
    case "twenty-eighth" return "28"
    case "twenty-seventh" return "27"
    case "twenty-sixth" return "26"
    case "twenty-fifth" return "25"
    case "twenty-fourth" return "24"
    case "twenty-third" return "23"
    case "twenty-second" return "22"
    case "twenty-first" return "21"
    case "twentieth" return "20"
    case "nineteenth" return "19"
    case "eighteenth" return "18"
    case "seventeenth" return "17"
    case "sixteenth" return "16"
    case "fifteenth" return "15"
    case "fourteenth" return "14"
    case "thirteenth" return "13"
    case "twelfth" return "12"
    case "eleventh" return "11"
    case "tenth" return "10"
    case "ninth" return "9"
    case "eighth" return "8"
    case "seventh" return "7"
    case "sixth" return "6"
    case "fifth" return "5"
    case "fourth" return "4"
    case "third" return "3"
    case "second" return "2"
    case "first" return "1"
    default return "error"
  };
  
  declare function local:frusYear-to-yyyy($yearOfOurLord) {
  let $century := switch (analyze-string(lower-case($yearOfOurLord),'(nine|eight) hundred',"i")/fn:match)
    case "nine hundred" return "9"
    case "eight hundred" return "8"
    default return "error"
    
  let $yearA := switch(analyze-string(lower-case($yearOfOurLord),'(ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)',"i")/fn:match)
    case "ninety" return "9"
    case "eighty" return "8"
    case "seventy" return "7"
    case "sixty" return "6"
    case "fifty" return "5"
    case "forty" return "4"
    case "thirty" return "3"
    case "twenty" return "2"
    default return ''
 
  let $yearB := switch(analyze-string(lower-case($yearOfOurLord),'(nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)',"i")/fn:match[1])   
    case "nineteen" return "19"
    case "eighteen" return "18"
    case "seventeen" return "17"
    case "sixteen" return "16"
    case "fifteen" return "15"
    case "fourteen" return "14"
    case "thirteen" return "13"
    case "twelve" return "12"
    case "eleven" return "11"
    case "ten" return "10"
    case "nine" return "9"
    case "eight" return "8"
    case "seven" return "7"
    case "six" return "6"
    case "five" return "5"
    case "four" return "4"
    case "three" return "3"
    case "two" return "2"
    case "one" return "1"
    default return "0"
  return concat('1',$century,$yearA,$yearB)
};


let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred twenty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010.</head>

let $matches-MM-dd-yyyy :=
  for $MM-dd-yyyy in local:get-dates($input)[1]/fn:match
  return <date when="{$MM-dd-yyyy/fn:group[attribute::nr='3']}-{$MM-dd-yyyy/fn:group[attribute::nr='1'] => local:month-to-mm()}-{$MM-dd-yyyy/fn:group[attribute::nr='2'] => format-number('00')}">{data($MM-dd-yyyy)}</date>

let $matches-MM-ddrange-yyyy :=    
  for $MM-ddrange-yyyy in local:get-dates($input)[2]/fn:match
  return <date from="{$MM-ddrange-yyyy/fn:group[attribute::nr='4']}-{$MM-ddrange-yyyy/fn:group[attribute::nr='1'] => local:month-to-mm()}-{$MM-ddrange-yyyy/fn:group[attribute::nr='2'] => format-number('00')}" to="{$MM-ddrange-yyyy/fn:group[attribute::nr='4']}-{$MM-ddrange-yyyy/fn:group[attribute::nr='1'] => local:month-to-mm()}-{$MM-ddrange-yyyy/fn:group[attribute::nr='3'] => format-number('00')}">{data($MM-ddrange-yyyy)}</date>
        
let $matches-dd-MM-yyyy :=
  for $dd-MM-yyyy in local:get-dates($input)[3]/fn:match
  return <date when="{$dd-MM-yyyy/fn:group[attribute::nr='3']}-{$dd-MM-yyyy/fn:group[attribute::nr='2'] => local:month-to-mm()}-{$dd-MM-yyyy/fn:group[attribute::nr='1'] => format-number('00')}">{data($dd-MM-yyyy)}</date>
    
let $matches-dd-MM-yyyy-fr :=
  for $dd-MM-yyyy-fr in local:get-dates($input)[4]/fn:match
  return <date when="{$dd-MM-yyyy-fr/fn:group[attribute::nr='3']}-{$dd-MM-yyyy-fr/fn:group[attribute::nr='2'] => local:month-to-mm()}-{$dd-MM-yyyy-fr/fn:group[attribute::nr='1'] => format-number('00')}">{data($dd-MM-yyyy-fr)}</date>
    
let $matches-dd-MM-yyyy-sp :=
  for $dd-MM-yyyy-sp in local:get-dates($input)[5]/fn:match
  return <date when="{$dd-MM-yyyy-sp/fn:group[attribute::nr='3']}-{$dd-MM-yyyy-sp/fn:group[attribute::nr='2'] => local:month-to-mm()}-{$dd-MM-yyyy-sp/fn:group[attribute::nr='1'] => format-number('00')}">{data($dd-MM-yyyy-sp)}</date>
    
let $matches-DD-MM-YYYY :=
  for $DD-MM-YYYY in local:get-dates($input)[6]/fn:match
    
  let $dd :=
    if (exists($DD-MM-YYYY/fn:group[attribute::nr='1']))
    then ($DD-MM-YYYY/fn:group[attribute::nr='1'] => format-number('00'))
    else
      if (exists($DD-MM-YYYY/fn:group[attribute::nr='2']))
      then $DD-MM-YYYY/fn:group[attribute::nr='2']  => local:ordinal-to-dd()
      else "error"
        
  return <date when="{$DD-MM-YYYY/fn:group[attribute::nr='4'] => local:frusYear-to-yyyy()}-{$DD-MM-YYYY/fn:group[attribute::nr='3'] => local:month-to-mm()}-{$dd}">{data($DD-MM-YYYY)}</date>
  
return $matches-DD-MM-YYYY
