let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> Text from repo: this twenty-fifth day of February in the year of our Lord one thousand nine hundred and nineteen, and of the Independence of
                                        the United States the one hundred and forty third. An example of an official date is the 2d day of May, in the year of the lord two thousand nine hundred sixty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: el 6 de Agosto de 1902. This is another: 8 de septiembre del 2010. May 1st—5th, 2015 is another date range (in the same month). </head>
                            
                            (: [-–—] :)
let $analyze := analyze-string($input, '((?:(?:the|this)\s+)?((?:thirty|twenty)?(?:-|–)?(?:thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first))\s+day\s+of\s+(January|February|March|April|May|June|July|August|September|October|November|December),?\s+in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+((?:one|two)\s+thousand\s+(?:nine|eight)?\s+hundred\s+(?:and\s+)?(?:ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)?(?:-|–)?\s*(?:nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)?))', 'i')

(:

((?:(?:the|this)\s+)?((?:thirty|twenty)?(?:-|–)?(?:thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first))\s+day\s+of\s+(January|February|March|April|May|June|July|August|September|October|November|December),?\s+in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+((?:one|two)\s+thousand\s+(?:nine|eight)?\s+hundred\s+(?:ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)?(?:-|–)?\s*(?:nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)?))

:)


let $date-match-1 := $analyze/fn:match[1]
                    
let $date-phrase := normalize-space($date-match-1//fn:group[attribute::nr eq '2']/string())

let $date-tens := 
                    if (matches($date-phrase, 'thirty')) 
                        then '3' 
                        else 
                        if (matches($date-phrase, 'twenty')) 
                        then '2' 
                        else 
                        if (matches($date-phrase, 'twelfth | eleventh | tenth | teenth')) 
                        then '1' 
                        else '0'
                    
let $date-ones :=
                        if (matches($date-phrase, 'ninth$ | nineteenth$')) 
                        then '9' 
                        else 
                        if (matches($date-phrase, 'eighth$ | eighteenth')) 
                        then '8' 
                        else 
                        if (matches($date-phrase, 'seventh$ | seventeenth$')) 
                        then '7'
                        else  
                        if (matches($date-phrase, 'sixth$ | sixteenth$')) 
                        then '6' 
                        else 
                        if (matches($date-phrase, '(fifth$|fifteenth$)')) 
                        then '5' 
                        else 
                        if (matches($date-phrase, 'fourth$ | fourteenth$')) 
                        then '4' 
                        else 
                        if (matches($date-phrase, 'third$ | thirteenth$')) 
                        then '3' 
                        else 
                        if (matches($date-phrase, 'second$')) 
                        then '2' 
                        else 
                        if (matches($date-phrase, 'first$ | eleventh$')) 
                        then '1' 
                        else '0'
                        
return $date-match-1