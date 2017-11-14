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
  }
;

declare function local:get-dates($source) {
  
    let $month-day-year-regex := $local:regexes?month-regex                     || '\s+'            || $local:regexes?day-regex        || ',?\s+'                    || $local:regexes?year-regex
    let $month-day-range-year-regex := $local:regexes?month-regex               || '\s+'            || $local:regexes?day-range-regex  || ',?\s+'                    || $local:regexes?year-regex 
    let $day-month-year-regex := $local:regexes?day-regex                       || '\s+'            || $local:regexes?month-regex      || ',?\s+'                    || $local:regexes?year-regex
    let $day-month-year-regex-fr := $local:regexes?day-regex                    || '\s+'            || $local:regexes?month-regex-fr   || ',?\s+'                    || $local:regexes?year-regex
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

(:
declare function local:chug($words as xs:string*) {
  let $word := $words[1]
  return
    if (matches($word, "January|janvier|enero|February|février|fevrier|febrero|March|mart|marzo|April|avril|abril|May|mai|mayo|June|juin|junio|July|juillet|julio|August|août|aout|agosto|September|septembre|septiembre|setiembre|October|octobre|octubre|November|novembre|noviembre|December|décembre|decembre|diciembre","i"))
    then <month>{$word}</month>
    else $word
    ,
    if ($words[2])
      then local:chug(subsequence($words, 2))
        else () 
};

(: Identity transformation reconstructs the existing node as is. Sneeze, though, mani :)

declare function local:sneeze($input) {
  for $node in $input
  return
    typeswitch ( $node )
      case element() return
        element 
          { $node/node-name() }
          { local:sneeze($node/node()) }
      case text() return $node => tokenize() => local:chug()
      default return "dunno."
};
:)



declare function local:achoo($input) {
  for $node in $input
  return
    typeswitch ( $node )
      case element() return
        element 
          { $node/node-name() }
          { local:get-dates($node/node()) }
      case text() return $node => local:get-dates()
      default return "dunno."
};


let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred twenty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010.</head>
return
  local:achoo($input)                 