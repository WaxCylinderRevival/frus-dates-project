xquery version "3.1";

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