xquery version "3.1";

declare function local:chug($words as xs:string*) {
  let $word := $words[1]
  return
    switch($word)
      case "January"
      case "September" return "month"
      default return "not-month"
    ,
    if ($words[2])
      then local:chug(subsequence($words, 2))
        else () 
};

let $w := "My birthday is on September 29." => tokenize()
return
  local:chug($w)

