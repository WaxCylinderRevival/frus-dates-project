(: declare namespace dp='https://history.state.gov/ns/xquery/date-processing' :)

declare variable $local:regexes :=
  map {
    "month-re" : "(?:January|February|March|April|May|June|July|August|September|October|November|December)",
   "day-re" : "(\d{1,2})(?:st|d|nd|rd|th)?",
   "day-range-re" : "(\d{1,2})(?:st|d|nd|rd|th)?\s+[-–—]\s+(\d{1,2})(?:st|d|nd|rd|th)?",
   "year-re" : "(\d{4})"
  }
;

declare function local:input-no-notes
 ( $textWithDates as element()? ) as xs:string* {
   let $textString :=
      $textWithDates/node()[not(self::note)] => string-join(' ') => normalize-space()
      return $textString
 }
 ;

declare function local:find-date-strings
  ( $textInput as xs:string? ) as element()* {  
      
  for $match in data(local:input-no-notes($textInput)/fn:match)
  
  let $when :=
  
      let $year := analyze-string($match, '\d{4}$')/fn:match
    
      let $month :=
          switch (analyze-string($match,'(January|February|March|April|May|June|July|August|September|October|November|December)')/fn:match)
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
           
     let $day := analyze-string($match, '\d{1,2}')/fn:match[1] 
     
     let $day2Digit := $day => format-number('00')
         
    return concat($year,'-',$month,'-',$day2Digit)
      
  return <date when="{$when}">{$match}</date>

};

let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is March 1, 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015. The fourth example is a date range: October 4-5th, 1939.<note>This is a note with a date: September 1, 1929.</note></head>

let $dates := local:find-date-strings($input)

return <results>{$dates}</results>