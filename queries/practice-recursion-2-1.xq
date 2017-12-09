xquery version "3.1";

declare function local:chug($words as xs:string*) {
  let $word := $words[1]
  let $switch := switch($word) 
    case "January" 
      case "january" 
      case "janvier"
      case "Enero"
      case "enero" return "01"    
    case "February"
      case "february"
      case "février" 
      case "fevrier"
      case "Febrero"  
      case "febrero" return concat(matches(data($word), '\d{4}'),'-02')   
    case "March"
      case "march"
      case "mart"
      case "Marzo"
      case "marzo" return "03"
    case "April"
      case "april"
      case "avril"
      case "Abril"
      case "abril" return "04"
    case "May"
      case "may"   
      case "mai"
      case "Mayo"
      case "mayo" return "05"
    case "June"
      case "june"
      case "juin"
      case "Junio"
      case "junio" return "06"
    case "July"
      case "july"
      case "juillet"
      case "Julio"
      case "julio" return "07"
    case "August"
      case "august"
      case "août"
      case "aout"
      case "Agosto"
      case "agosto" return "08"
    case "September"
      case "september"
      case "septembre"
      case "septiembre"
      case "Setiembre"
      case "setiembre" return "09"
    case "October"
      case "october"
      case "octobre"
      case "Octubre"
      case "octubre" return "10"
    case "November"
      case "november"
      case "novembre"
      case "Noviembre"
      case "noviembre" return "11"
    case "December"
      case "december"
      case "décembre"
      case "decembre"
      case "Diciembre"
      case "diciembre" return "12"
    default return "error"
  return
    if (matches($word, "January|janvier|enero|February|février|fevrier|febrero|March|mart|marzo|April|avril|abril|May|mai|mayo|June|juin|junio|July|juillet|julio|August|août|aout|agosto|September|septembre|septiembre|setiembre|October|octobre|octubre|November|novembre|noviembre|December|décembre|decembre|diciembre","i"))
    then <month when="{$switch}">{$word}</month>
    else $word
    ,
    if ($words[2])
      then local:chug(subsequence($words, 2))
        else () 
};

declare function local:sneeze($input) {
  for $node in $input
  return
    typeswitch ( $node )
      case element() return
        element 
          { $node/node-name() }
          { $node/attribute::*, local:sneeze($node/node()) }
      case text() return $node => tokenize() => local:chug()
      default return "dunno."
};

let $input := <head>The first date is <hi>February 2d, 1865</hi>. The next date is march 10 2010.  The <strong>third</strong> date is <hi rend="italic">31st July</hi> 2015.<note>This is a note with a date: September 1-3rd, 1929.</note> An example of an official date is the 2d day of May, in the year of the lord one thousand nine hundred twenty. Another example is the twenty-fifth day of June, in the year of our Lord one thousand eight hundred sixty-five. This is a French date with whitespace: le 13 août
                            1902. This is a Spanish date: 6 de Agosto de 1902. This is another: 8 de septiembre del 2010.</head>
return
  local:sneeze($input)                 