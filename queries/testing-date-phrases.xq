let $input := 'The first date is <hi>February 2d, 1865</hi>. The next date is march 1 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred and ninety-two. Another example is the fifth day of June, in the year of our Lord one thousand eight hundred and ninety-seven.  Another example is the fifth day of June, in the year of our Lord one thousand eight hundred twenty. This is a French date with whitespace: le 6 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010.'
let $analyze := analyze-string($input, '((?:(?:the|this)\s+)?((?:thirty|twenty)?(?:-|–)?(?:thirtieth|twentieth|nineteenth|eighteenth|seventeenth|sixteenth|fifteenth|fourteenth|thirteenth|twelfth|eleventh|tenth|ninth|eighth|seventh|sixth|fifth|fourth|third|second|first))\s+day\s+of\s+(January|February|March|April|May|June|July|August|September|October|November|December),?\s+in\s+the\s+year\s+of\s+(?:our|the)\s+lord\s+(((?:one|two)\s+thousand)\s+((?:nine|eight)?\s+hundred)\s+(and\s+)?((?:ninety|eighty|seventy|sixty|fifty|forty|thirty|twenty)?(?:-|–)?\s*(?:nineteen|eighteen|seventeen|sixteen|fifteen|fourteen|thirteen|twelve|eleven|ten|nine|eight|seven|six|five|four|three|two|one)?)))', 'i')

let $year-tens-ones := $analyze/fn:match[1]//fn:group[attribute::nr eq '8']

let $year-tens-digit :=
                            if (matches($year-tens-ones, 'ninety')) then
                                '9'
                            else
                                if (matches($year-tens-ones, 'eighty')) then
                                    '8'
                                else
                                    if (matches($year-tens-ones, 'seventy')) then
                                        '7'
                                    else
                                        if (matches($year-tens-ones, 'sixty')) then
                                            '6'
                                        else
                                            if (matches($year-tens-ones, 'fifty')) then
                                                '5'
                                            else
                                                if (matches($year-tens-ones, 'forty')) then
                                                    '4'
                                                else
                                                    if (matches($year-tens-ones, 'thirty')) then
                                                        '3'
                                                    else
                                                        if (matches($year-tens-ones, 'twenty')) then
                                                            '2'
                                                        else
                                                            if (matches($year-tens-ones, '(twelve|eleven|ten|teen$)')) then
                                                                '1'
                                                            else
                                                                '0'
                                                                
                                        let $year-ones-digit :=
                            if (matches($year-tens-ones, 'nine$|nineteen$')) then
                                '9'
                            else
                                if (matches($year-tens-ones, 'eight$|eighteen$')) then
                                    '8'
                                else
                                    if (matches($year-tens-ones, 'seven$|seventeen$')) then
                                        '7'
                                    else
                                        if (matches($year-tens-ones, 'six$|sixteen$')) then
                                            '6'
                                        else
                                            if (matches($year-tens-ones, 'five$|fifteen$')) then
                                                '5'
                                            else
                                                if (matches($year-tens-ones, 'four$|fourteen$')) then
                                                    '4'
                                                else
                                                    if (matches($year-tens-ones, 'three$|thirteen$')) then
                                                        '3'
                                                    else
                                                        if (matches($year-tens-ones, 'two$|twelve$')) then
                                                            '2'
                                                        else
                                                            if (matches($year-tens-ones, 'one$|eleven$')) then
                                                                '1'
                                                            else
                                                                '0'

                                                                
return $analyze/fn:match