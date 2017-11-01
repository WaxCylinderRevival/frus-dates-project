(: declare namespace dp='https://history.state.gov/ns/xquery/date-processing' :)

declare function local:find-date-strings
  ( $textWithDates as element()? ) as element()* {
    
  let $textString :=
      $textWithDates/node()[not(self::note)] => string-join(' ') => normalize-space() => analyze-string('((\d{1,2}(d|nd|rd|st|th)*\s+(January|February|March|April|May|June|July|August|September|October|November|December),*\s+\d{4})|((January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}(d|nd|rd|st|th)*,*\s+\d{4}))','i')
      
  for $match in data($textString/fn:match)
  (:
declare function local:input-no-notes
 ( $textWithDates as element()? ) as xs:string* {
   let $textString :=
      $textWithDates/node()[not(self::note)] => string-join(' ') => normalize-space()
      return $textString
 }
 ;

declare function local:find-date-strings
  ( $textInput as element()? ) as element()* {  
      
  for $match in data(local:input-no-notes($textInput)/fn:match)
  :)
  let $when :=
  
      let $year := analyze-string($match, '\d{4}$')/fn:match
    
      let $month :=
          switch (analyze-string($match,'(January|February|March|April|May|June|July|August|September|October|November|December)')/fn:match)
           case "January" return "01"
           case "january" return "01"
           case "February" return "02"
           case "february" return "02"
           case "March" return "03"
           case "march" return "03"
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
           
     let $day := analyze-string($match, '\d{1,2}')/fn:match[1] 
     
     let $day2Digit := $day => format-number('00')
         
    return concat($year,'-',$month,'-',$day2Digit)
      
  return <date when="{$when}">{$match}</date>

};

let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 1 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred nineteen. Another example is the fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 6 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010.</head>

let $dates := local:find-date-strings($input)

return <results>{$dates}</results>