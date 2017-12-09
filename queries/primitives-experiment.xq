xquery version "3.1";

(: Turning "December 7, 1941" into <date>December 7, 1941</date> isn't too hard, with XPath 3.0's 
   fn:analyze-string() function, but if the date string occurs in mixed text, such as:
       <p>Pearl Harbor was attacked on <em>December</em> 7, 1941.</p>
   and you want to preserve the existing element structure to return:
       <p>Pearl Harbor was attacked on <date><em>December</em> 7, 1941</date>.</p>
   it's quite a bit more challenging.
   
   This query uses string processing to align the results of fn:string-analyze() with the input's
   original node structure.
   
   Caveats: The local:hack() function may result in non-well-formed XML. This isn't guaranteed to 
   work with all source XML. I think it should work in cases where the date components are wrapped in
   "inline" elements, but haven't tested this extensively.
   
   The regex and many functions used here are drawn from @WaxCylinderRevival's date-matching query: 
       https://gist.github.com/WaxCylinderRevival/b61b9843f118909bf6cf41c922632559 
:)

declare boundary-space preserve;

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

declare function local:enrich-matches($nodes, $enrich as function(*)) {
    for $node in $nodes
    return
        typeswitch ( $node )
            case element(fn:non-match) return $node/string()
            case element(fn:match) return $enrich($node)
            case element() return local:enrich-matches($node/node(), $enrich)
            default return
                $node
};

declare function local:analyze-text($text, $patterns) {
    if (exists($patterns)) then
        let $pattern := head($patterns)
        let $analysis := analyze-string($text, $pattern?regex)
        return
            if ($analysis/fn:match) then 
                local:enrich-matches($analysis, $pattern?enrich-match) 
            else 
                local:analyze-text($text, tail($patterns))
    else
        $text
};

declare function local:analyze($nodes, $text-patterns) {
    for $node in $nodes
    return
        typeswitch ( $node )
            case text() return 
                local:analyze-text($node, $text-patterns)
            case element() return 
                element { node-name($node) } { $node/@*, local:analyze($node/node(), $text-patterns) }
            default return
                $node
};

declare variable $local:regex-primitives :=
    (: regex primitives :)
    map {
        "months-en": "(January|February|March|April|May|June|July|August|September|October|November|December)",
        "months-fr" : "(janvier|février|fevrier|mart|avril|mai|juin|juillet|août|aout|septembre|octobre|novembre|décembre|decembre)",
        "months-sp" : "(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)",
        "day": "(\d{1,2})",
        "day-range" : "(\d{1,2})(?:st|d|nd|rd|th)?\s*[-–—]\s*(\d{1,2})(?:st|d|nd|rd|th)?",
        "day-spelled-out" : "(?:(\d{1,2})(?:st|d|nd|rd|th)?|((?:thirty|twenty)?(?:-|–|\s+)?(?:thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first)?))",
        "year" : "(\d{4})",
        "year-spelled-out" : "(one\s+thousand\s+(?:nine|eight)\s+hundred\s+(?:ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)?(?:-|–|\s+)?(?:nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)?)",
        "space" : "\s+",
        "comma-space" : ",?\s+",
        "preposition-en1" : "day\s+of\s+",
        "preposition-sp1" : "(?:de\s+)?",
        "preposition-sp2" : "(?:(?:de|del)\s+)?",
        "year-of-our-lord" : "in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+"
    }
;

declare function local:compile-pattern($components) {
    $components?* ! $local:regex-primitives(.)
    => string-join()
};

declare function local:get-text-node-at-offset($text-nodes, $offset) {
    if (count($text-nodes) gt 1) then
        let $node := $text-nodes => head()
        let $preceding := $node/preceding::text()
        let $start-pos := string-length($preceding => string-join())
        let $end-pos := $start-pos + string-length($node)
        return
            if ($start-pos le $offset and $end-pos ge $offset) then 
                map { "node": $node, "position": $offset - $start-pos }
            else 
                local:get-text-node-at-offset($text-nodes => tail(), $offset)
    else
        $text-nodes
};

declare function local:insert-milestones($nodes, $milestones) {
    for $node in $nodes
    return
        typeswitch ($node) 
            case element() return 
                let $milestone := $milestones[?node is ($node//text())[1] and ?position eq 1]
                return
                    (
                        if (exists($milestone) and $node/preceding-sibling::node()) then
                            element { $milestone?name } { () }
                        else 
                            ()
                        ,
                        element {node-name($node)} {$node/@*, local:insert-milestones($node/node(), $milestones) }
                    )
            case text() return
                let $milestone := $milestones[?node is $node]
                return
                    if (exists($milestone) and exists($node/preceding-sibling::node())) then
                        (
                            if ($milestone?position gt 1) then
                                substring($node, 1, $milestone?position - 1)
                            else
                                ()
                            ,
                            element { $milestone?name } { () }
                            ,
                            if ($milestone?position lt string-length($node)) then
                                substring($node, $milestone?position)
                            else
                                ()
                        )
                    else
                        $node
            default return $node
};

declare function local:process-dates($node, $dates, $pos) {
    if (exists($dates)) then 
        let $date := $dates => head()
        let $start := string-length($date/preceding::text() => string-join()) + 1
        let $length := string-length($date)
        let $end := $start + $length
        let $start-node := local:get-text-node-at-offset($node//text(), $start)
        let $end-node := local:get-text-node-at-offset($node//text(), $end)
        let $milestones := (map:put($start-node, "name", "date-start-" || $pos), map:put($end-node, "name", "date-end-" || $pos))
        let $insert-milestones := local:insert-milestones($node, $milestones)
        return
            local:process-dates($insert-milestones, $dates => tail(), $pos + 1)
    else
        $node
};

declare function local:hack($serialized, $dates, $pos) {
    if (exists($dates)) then
        let $date := $dates => head()
        let $processed :=
            $serialized
            => replace("<date-start-" || $pos || "/>", '<date when="' || $date/@when || '">') 
            => replace("<date-end-" || $pos || "/>", "</date>")
        return
            local:hack($processed, $dates => tail(), $pos + 1)
    else
        $serialized
};

let $patterns := 
    (
(:1:)(:  map {
            "name": "month-day-year",
            "regex": ["months-en", "space", "day", "comma-space", "year"] => local:compile-pattern(),
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
        "regex": ["months-en", "space", "day-range", "comma-space", "year"] => local:compile-pattern(),
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
            "regex": ["day", "space", "months-en", "comma-space", "year"] => local:compile-pattern(),
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
            "regex": ["day", "space", "months-fr", "comma-space", "year"] => local:compile-pattern(),
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
            "regex": ["day", "space", "preposition-sp1", "months-sp", "comma-space", "preposition-sp2", "year"] => local:compile-pattern(),
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
        }, :)
(:6:) map {
            "name" : "day-month-year-official",
            "regex": ["day-spelled-out", "preposition-en1", "months-en", "comma-space", "year-of-our-lord", "year-spelled-out"] => local:compile-pattern(),
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
    )
     
    
let $node := 

(:
    <div>
        <p>
            <em>Pearl Harbor</em> was attacked on <strong><em>December</em></strong> <strong>7</strong>, 1941. My birthday is <birthday>September 29, <year>1976</year></birthday>. I am taking vacation <vacation-dates>May 12–13, 2017</vacation-dates>.
        </p>
    </div>

:)
  
    <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred twenty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010. 
                            <p>This date has already been encoded: <date when="2005-05-31" ana="#undated-inferred-from-document-content">May 31, 2005</date>. The last date is 29 September, 1881.</p>
                            </head>


let $simple := local:analyze(element {node-name($node)} {$node/string()}, $patterns)
let $dates := $simple//date
let $processed := local:process-dates($node, $dates, 1)
let $serialized := serialize($processed)
let $hack := local:hack($serialized, $dates, 1)
let $final := $hack => parse-xml()
return
    $final