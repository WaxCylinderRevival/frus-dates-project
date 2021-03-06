xquery version "3.1";

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
  };
  
declare variable $local:patterns := 
  map {
  "month-day-year-regex" : $local:regexes?month-regex                     || '\s+'            || $local:regexes?day-regex        || ',?\s+'                    || $local:regexes?year-regex,
  "month-day-range-year-regex" : $local:regexes?month-regex               || '\s+'            || $local:regexes?day-range-regex  || ',?\s+'                    || $local:regexes?year-regex,
  "day-month-year-regex" : $local:regexes?day-regex                       || '\s+'            || $local:regexes?month-regex      || ',?\s+'                    || $local:regexes?year-regex,
  "day-month-year-regex-fr" : $local:regexes?day-regex                    || '\s+'            || $local:regexes?month-regex-fr   || ',?\s+'                    || $local:regexes?year-regex,
  "day-month-year-regex-sp" : $local:regexes?day-regex                    || '\s+(?:de\s+)?'  || $local:regexes?month-regex-sp   || ',?\s+(?:(?:de|del)\s+)?'  || $local:regexes?year-regex,
  "day-month-year-official-regex" : $local:regexes?day-spelled-out-regex  || '\s+day\s+of\s+' || $local:regexes?month-regex      || ',\s+in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+'  || $local:regexes?year-spelled-out-regex
  };
  
declare variable $local:definitions :=
  (
(:1:)  map {
        "name": "month-day-year",
        "regex": $local:patterns?month-day-year-regex,
        "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $year := $groups[@nr eq "3"]
          let $month := $groups[@nr eq "1"] => local:month-to-mm()
          let $day := $groups[@nr eq "2"] => format-number('00')
          let $when := ($year, $month, $day) => string-join("-")
          return
            element date {
              attribute when { $when },
              $match/string()
            }
          }
        },
(:2:) map {
        "name": "month-day-range-year",
        "regex": $local:patterns?month-day-range-year-regex,
        "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $yearFrom := $groups[@nr eq "4"]
          let $monthFrom := $groups[@nr eq "1"] => local:month-to-mm()
          let $dayFrom := $groups[@nr eq "2"] => format-number('00')
          let $from := ($yearFrom, $monthFrom, $dayFrom) => string-join("-")
          let $yearTo := $groups[@nr eq "4"]
          let $monthTo := $groups[@nr eq "1"] => local:month-to-mm()
          let $dayTo := $groups[@nr eq "3"] => format-number('00')
          let $to := ($yearTo, $monthTo, $dayTo) => string-join("-")
          return
            element date {
              attribute from { $from },
              attribute to { $to },
              $match/string()
            }
          }
        },
(:3:) map {
            "name" : "day-month-year",
            "regex" : $local:patterns?day-month-year-regex,
             "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $year := $groups[@nr eq "3"]
          let $month := $groups[@nr eq "2"] => local:month-to-mm()
          let $day := $groups[@nr eq "1"] => format-number('00')
          let $when := ($year, $month, $day) => string-join("-")
          return
            element date {
              attribute when { $when },
              $match/string()
            }
          }
        },
(:4:) map {
            "name" : "day-month-year-fr",
            "regex" : $local:patterns?day-month-year-regex-fr,
            "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $year := $groups[@nr eq "3"]
          let $month := $groups[@nr eq "2"] => local:month-to-mm()
          let $day := $groups[@nr eq "1"] => format-number('00')
          let $when := ($year, $month, $day) => string-join("-")
          return
            element date {
              attribute when { $when },
              $match/string()
            }
          }
        },
(:5:) map {
            "name" : "day-month-year-sp",
            "regex" : $local:patterns?day-month-year-regex-sp,
            "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $year := $groups[@nr eq "3"]
          let $month := $groups[@nr eq "2"] => local:month-to-mm()
          let $day := $groups[@nr eq "1"] => format-number('00')
          let $when := ($year, $month, $day) => string-join("-")
          return
            element date {
              attribute when { $when },
              $match/string()
            }
          }
        },
(:6:) map {
            "name" : "day-month-year-official",
            "regex" : $local:patterns?day-month-year-official-regex,
            "enrich-match": function($match as element(fn:match)) as element(date) {
          let $groups := $match/fn:group
          let $year := $groups[@nr eq "4"] => local:frusYear-to-yyyy()
          let $month := $groups[@nr eq "3"] => local:month-to-mm()
          let $day := 
            (
              if ($groups[@nr eq "2"] ne "") then $groups[@nr eq "2"] => local:ordinal-to-dd() else (),
             if ($groups[@nr eq "1"] ne "") then $groups[@nr eq "1"] => format-number('00') else ()
            )[1]
          let $when := ($year, $month, $day) => string-join("-")
          return
            element date {
              attribute when { $when },
              $match/string()
            }
          }
        }
      );
      
(: Begin date conversion :)
declare function local:month-to-mm($m) {
  
  switch (analyze-string(lower-case($m),'(january|janvier|enero|february|février|fevrier|febrero|march|mart|marzo|april|avril|abril|may|mai|mayo|june|juin|junio|july|juillet|julio|august|août|aout|agosto|september|septembre|septiembre|setiembre|october|octobre|octubre|november|novembre|noviembre|december|décembre|decembre|diciembre)',"i")/fn:match)
    case "january" 
      case "janvier"
      case "enero" return "01"    
    case "february"
      case "février" 
      case "fevrier"  
      case "febrero" return "02"   
    case "march"
      case "mart"
      case "marzo" return "03"
    case "april"
      case "avril"
      case "abril" return "04"
    case "may"   
      case "mai"
      case "mayo" return "05"
    case "june"
      case "juin"
      case "junio" return "06"
    case "july"
      case "juillet"
      case "julio" return "07"
    case "august"
      case "août"
      case "aout"
      case "agosto" return "08"
    case "september"
      case "septembre"
      case "septiembre"
      case "setiembre" return "09"
    case "october"
      case "octobre"
      case "octubre" return "10"
    case "november"
      case "novembre"
      case "noviembre" return "11"
    case "december"
      case "décembre"
      case "decembre"
      case "diciembre" return "12"
    default return "error"
           
};

declare function local:ordinal-to-dd($dth) {
  
  switch (analyze-string(lower-case($dth),'()?(thirty|twenty)?(-|–)?(thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first)',"i")/fn:match)
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
      
    let $yearA := switch(analyze-string(lower-case(substring-after($yearOfOurLord,'hundred')),'(ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty|nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten)',"i")/fn:match)
      case "ninety" return "90"
      case "eighty" return "80"
      case "seventy" return "70"
      case "sixty" return "60"
      case "fifty" return "50"
      case "forty" return "40"
      case "thirty" return "30"
      case "twenty" return "20"
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
      default return '0'
   
    let $yearB := switch(analyze-string(lower-case(substring-after($yearOfOurLord,'hundred')),'(nine$|eight$|seven$|six$|five$|four$|three$|two$|one$)',"i")/fn:match[1])   
  
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
    
    return concat('1', $century, ((xs:integer($yearA) + xs:integer($yearB)) => xs:integer() => format-number('00')))
    
};
(: End date conversion :)


declare function local:get-dates($text as xs:string, $regex-patterns) { 

  if (count($regex-patterns) ge 1) then 
    let $regex-pattern := $regex-patterns => head()
    let $analysis := analyze-string($text, $regex-pattern?regex, "i")
    return
      if ($analysis/fn:match) then
          for $element in $analysis/element()
          return 
            if ($element instance of element(fn:match)) then
            $regex-pattern?enrich-match($element)
          else (: if ($element instance of element(fn:match)) :)
            local:get-dates($element/string(), $regex-patterns => tail())
      else
        local:get-dates($text,  $regex-patterns => tail())
    else $text
   };

declare function local:date-recursion($input, $parameter) {
  for $node in $input
  return
    typeswitch ( $node )
      case element(date) return 
        if ($node/@*) then
          $node
          else
            element 
              { $node/node-name() }
              { $node/attribute::*, local:date-recursion($node/node(), $local:definitions) }
      case element() return
        element 
          { $node/node-name() }
          { $node/attribute::*, local:date-recursion($node/node(), $local:definitions) }
      case text() return $node => local:get-dates($local:definitions)
      default return "error"
};

let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred twenty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010. 
                            <p>This date has already been encoded: <date when="2005-05-31" ana="#undated-inferred-from-document-content">May 31, 2005</date>. The last date is 29 September, 1881.</p>
                            </head>

return
 local:date-recursion($input, $local:definitions)