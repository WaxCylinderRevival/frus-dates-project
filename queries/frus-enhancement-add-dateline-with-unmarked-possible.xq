(:~ 
: Script Overview: This .xq script evaluates 
: FRUS volumes containing documents missing 
: <dateline> and creates <dateline> per 
: document by either 1) repeating the <placeName> and
: <date> from <head> or 2) searching the head for the 
: first date match, first and second times, and place 
: names matching an editable city list.
: Results in markdown-friendly text.
: All mistakes my own.
:
: @author: Amanda T. Ross
: @since: 2017-04
:)

xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx="http://www.functx.com" at "functx-1.0.xq";

let $q := 'frus1943CairoTehran'

let $coll := collection('frus-volumes')[matches(//tei:TEI/attribute::xml:id,$q)]

for $v in ($coll/tei:TEI)

let $vID := $v//tei:publicationStmt/tei:idno[attribute::type='frus']

let $cities := '(Aarhus|Aberdeen|Abidjan|Abo|Abu Dhabi|Abuja|Acajutla|Acapulco|Accra|Adana|Addis Ababa|Adelaide|Aden|Adrianople|Aegean Sea Islands|Agua Prieta|Aguadilla|Aguas Calientes|Aguatulco|Aintab|Aix La Chapelle|Akyab|Alamos|Albany|Albert Town|Aleppo|Alexandretta|Alexandria|Algeciras|Algiers|Algoma|Alicante|Almaty|Almeria|Almirante|Altata|Altona|Alvouro Obregon|Amherstburg|Amiens|Amman|Amoor River|Amoy|Ampala|Amsterdam|Ancona|Andorra|Andorra la Vella|Angers|Ankara|Antananarivo|Antilla|Antioch|Antofagasta|Antung|Antwerp|Apia|Aquin|Aracaju|Archangel|Arecibo|Arendal|Arequipa|Arica|Arnprior|Aruba|Ashgabat|Asmara|Aspinwall|Assioot|Assouan|Astana|Asuncion|Athens|Athlone|Auckland|Augsburg|Aux Cayes|Aveiro|Avlona|Ayamonte|Babelsberg|Baden-Baden|Baghdad|Bahia|Bahia Blanca|Bahia de Caraqeuz|Baida|Baku|Ballina|Ballymena|Bamako|Bamberg|Bandar Seri Begawan|Banes|Bangalore|Bangkok|Bangui|Banja Luca|Banjul|Baracoa|Barcelona|Bari|Barmen|Barnsley|Barranquilla|Barrie|Basel|Basrah|Bassein|Basseterre|Bassorah|Batavian Republic|Batopilas|Batum|Bay of Islands|Bayonne|Beaumaris|Beijing|Beirut|Belem|Belfast|Belgrade|Belize City|Belleville|Bello Horizonte|Belmopan|Benghazi|Beni Saf|Benisouef|Bergen|Berlin|Bern|Biarritz|Bien Hoa|Bilboa|Birmingham|Bishkek|Bissau|Bizerta|Black River|Bloemfontein|Bluefields|Bocas del Toro|Bogota|Boguillas|Bologna|Boma|Bonacca|Bone-Bona|Bonn|Boodroom|Bordeaux|Boulogne|Bradford|Brake|Brantford|Brasilia|Bratislava|Brazoria|Brazzaville|Bremen|Bremerhaven|Breslau|Brest|Bridgetown|Brindisi|Brisbane|Bristol|Brockville|Brousa|Brunn|Brussels|Bucharest|Budapest|Buenaventura|Buenos Aires|Bujumbura|Bukavu|Burslem|Burtscheid|Busan|Cadiz|Cagliari|Caibarien|Caimanera|Cairo|Calais|Caldera|Calgary|Cali|Callao|Camaguey|Camargo|Camp David|Campbellton|Campeachy|Can Tho|Cananea|Canberra|Candia|Cannes|Canton|Cape Gracias a Dios|Cape Haitien|Cape Palmas|Cape Town|Capri|Caracas|Cardenas|Cardiff|Carini|Caripito|Carleton|Carlisle|Carlsruhe|Carrara|Carril|Cartagena|Carthagena|Carupano|Casablanca|Cassel|Castellamare|Castries|Catania|Caudry|Cayenne|Ceara|Cebu|Cephalonia Island|Cerro de Pasco|Cette|Ceuta|Champerico|Chanaral|Changchun|Changsha|Charleroi|Chatham|Chaux-de-fonds|Chefoo|Chengdu|Chennai|Cherbourg|Chiang Mai|Chiclayo|Chicoutimi|Chihuahua|Chimbote|Chinanfu|Chinkiang|Chisinau|Chittagong|Christchurch|Christiansand|Chungking|Chunking|Chuquicamata|Cienfuegos|Ciudad Bolivar|Ciudad Del Carmen|Ciudad Juarez|Ciudad Obregon|Ciudad Porfirio Diaz|Ciudad Trujillo|Civita Vecchia|Clarenceville|Clifton|Clinton|Cluj-Napoca|Coatzacoalcos|Cobh|Coblentz|Coburg|Cochabamba|Cochin|Coconada|Cognac|Collingwood|Collo|Cologne|Colombo|Colon|Colonia|Comayagua|Conakry|Concepcion|Concepcion Del Oro|Constantine|Copalquin|Copenhagen|Coquimbo|Corcubion|Cordoba|Corfu|Corinto|Cork|Corn Island|Cornwall|Cornwallis|Coro|Coronel|Corunna|Coteau|Cotonou|Courtwright|Crefeld|Cronstadt|Cruz Grande|Cumana|Curacao|Curitiba|Curityba|Cuxhaven|Daiguiri|Dairen|Dakar|Damascus|Damietta|Danang|Danzig|Dar es Salaam|Dardanelles|Dartmouth|Denia|Derby|Deseronto|Desterro|Dhahran|Dhaka|Dieppe|Dijon|Dili|Djibouti|Doha|Douala|Dover|Dresden|Duart|Dubai|Dublin|Dundee|Dunedin|Dunfermline|Dunkirk|Dunmore Town|Durango|Durban|Dushanbe|Dyreford|Düsseldorf|East London|Edinburgh|Edmonton|Eibenstock|El Jadida|Elizabethville|Elsinore|Emden|Emerson|Ensenada|Enugu|Erbil|Erfurt|Erie|Erzerum|Esbjerg|Esmeraldas|Essaouira|Essen|Eten|Fajardo|Falmouth|Farnham|Faro|Fayal|Ferrol|Fiume|Florence|Flores|Florianopolis|Flushing|Foochow|Fort Erie|Fort William and Port Authur|Fortaleza|Foynes|Frankfurt|Fredericia|Fredericton|Freetown|Frelighsburg|Frieburg|Frontera|Fukuoka|Funchal|Furth|Gaborone|Galashiels|Galliod|Gallipoli|Galt|Galveston|Galway|Gananoque|Garita Gonzales|Garrucha|Gaspe|Gdansk|Geestemunde|Gefle|Geneva|Genoa|Georgetown|Gera|Ghent|Gibara|Gibraltar|Gijon|Gioja|Girgeh|Girgenti|Glasgow|Glauchau|Gloucester|Goderich|Godthaab|Golfito|Gonaives|Gore Bay|Gothenburg|Governor’s Harbor|Graciosa|Granada|Grand Bassa|Grao|Green Turtle Cay|Greenock|Grenoble|Grenville|Guadalajara|Guadalupe Y Calvo|Guanajuato|Guangzhou|Guantanamo|Guatemala|Ciudad de Guatemala|Guatemala City|Guayama|Guayaquil|Guaymas|Guazacualco|Guben|Guelph|Guernsey|Guerrero|Haida|Haifa|Hakodate|Halifax|Halsingborg|Hamburg|Hamilton|Hammerfest|Hangchow|Hankow|Hanoi|Hanover|Harare|Harbin|Harburg|Harput|Hartlepool|Habana|Havana|Havre|Havre De Grace|Helder|Helsingborg|Helsinki|Hemmingford|Herat|Hermosillo|Hesse Cassel|Hesse Darmstadt|Hilo|Hinchenbrooke|Ho Chi Minh City|Holy See|Holyhead|Homs|Honda|Honfleur|Hong Kong|Honiara|Honolulu|Hoochelaga and Longeuil|Horgen|Horta|Huangpu|Huddersfield|Hue|Huelva|Hull|Huntington|Hyde Park|Hyderabad|Ibadan|Ichang|Ile De Re|Ilo|Innsbruck|Iquique|Iquitos|Isfahan|Iskenderun|Islamabad|Isle of Wight|Ismaila|Istanbul|Ivica|Izmir|Jacmel|Jaffa|Jaffna|Jakarta|Jalapa|Jeddah|Jeremie|Jeres de la Frontera|Jerusalem|Johannesburg|Juba|Kabul|Kaduna|Kahului|Kalamata|Kalgan|Kampala|Kanagawa|Karachi|Kathmandu|Kehl|Keneh|Kenora|Khartoum|Khorramshahr|Kidderminster|Kiev|Kigali|Kingston|Kingston upon Hull|Kingstown|Kinshasa|Kirkaldy|Kirkuk|Kisangani|Kishinev|Kiu Kiang|Kobe|Kolding|Kolkata|Kolonia|Konigsberg|Koror|Kovno|Krakow|Kuala Lumpur|Kuching|Kunming|Kuwait City|Kweilin|Kyiv|La Ceiba|La Guaira|La Oroya|La Paz|La Rochelle|La Romana|Lachine|Lacolle|Lagos|Laguna De Terminos|Lahore|Lambayeque|Langen Schwalbach|Laraiche and Asilah|Latakia|Lausanne|Lauthala|Leeds|Leghorn|Leicester|Leige|Leipzig|Leith|Leningrad|Leone|Lethbridge|Levis|Levuka|Libau|Libreville|Lille|Lilongwe|Lima|Limassol|Limerick|Limoges|Lindsay|Lisbon|Liverpool|Livingston|Ljubljana|Llanelly|Lobos|Lodz|Lome|Londenderry|London|Londonderry|Los Mochis|Luanda|Lubeck|Lucerne|Lugano|Luneburg|Lurgan|Lusaka|Luxembourg|Luxor|Lyon|Macau|Maceio|Madras|Madrid|Magallanes|Magdalen Islands|Magdalena|Magdeburg|Mahukona|Mainz|Majuro|Malabo|Malaga|Maldives|Male|Malmo|Malta|Managua|Manama|Manaos|Manaus|Manchester|Mandalay|Manila|Mannheim|Mansurah|Manta|Manzanillo|Maputo|Maracaibo|Maranhao|Marash|Markneukirchen|Marseille|Maseru|Matagalpa|Matagorda|Matamoros|Matanzas|Matthew Town|Mayaguez|Mazar-e-Sharif|Mazatlan|Mbabana|Mbabane|Medan|Medellin|Melbourne|Melekeok|Melilla|Mendoza|Mentone|Merida|Mersine|Meshed|Messina|Mexicali|Mexico City|Mexico, D. F.|México, D. F.|Midland|Mier|Milan|Milazzo|Milford Haven|Milk River|Minatitlan|Minich|Minsk|Miragoane|Mogadishu|Mollendo|Mombasa|Monaco|Monganui|Monrovia|Montego Bay|Monterrey|Montevideo|Montreal|Morelia|Morlaix|Moroni|Morpeth|Morrisburgh|Moscow|Mostar|Moulmein|Mukden|Mulhausen|Mumbai|Munich|Murree|Muscat|Nacaome|Nagasaki|Nagoya|Naguabo|Naha, Okinawa|Nairobi|Nancy|Nanking|Nantes|Napanee|Naples|Nassau|Natal|Neustadt|New Delhi|New York|Newcastle|Newchwang|Newport|Newry|Nha Trang|Niagara Falls|Niamey|Nice|Nicosia|Niewediep|Ningpo|Nogales|Norrkoping|North Bay|Nottingham|Nouakchott|Nuevitas|Nuevo Laredo|Nukualofa|Nuku’alofa|Nuremberg|Nuuk|N’Djamena|N’Djamena|Oaxaca|Ocean Falls|Ocos|Odense|Odessa|Old Harbor|Omoa|Omsk|Oporto|Oran|Orillia|Oruro|Osaka|Oshawa|Oslo|Otranto|Ottawa|Ouagadougou|Owen Sound|Pago Pago|Paita|Palamos|Palermo|Palikir|Palma de Mallorca|Panamá|Panama|Panama City|Pará|Paraiba|Paramaribo|Paris|Parral|Parry Sound|Paso Del Norte|Paspebiac|Patras|Pau|Paysandu|Peiping|Penang|Penedo|Perigueux|Pernambuco|Perth|Peshawar|Pesth|Peterborough|Petit Goave|Petrograd|Phnom Penh|Picton|Piedras Negras|Piraeus|Piura|Plauen|Plymouth|Podgorica|Point De Galle|Point Levi|Ponce|Ponta Delgada, Azores|Porsgrund|Port Antonio|Port Arthur|Port Elizabeth|Port Hope|Port Limon|Port Louis|Port Maria|Port Morant|Port Moresby|Port Rowan|Port Said|Port St. Mary’s|Port Stanley|Port Vila|Port au Prince|Port de Paix|Port of Marbella|Port of Spain|Port-au-Prince|Porto Alegre|Porto Novo|Portsmouth|Potosi|Potsdam|Poznan|Pozzuoli|Prague|Praha|Praia|Prescott|Pretoria|Prince Rupert|Pristina|Progreso|Puebla|Puerto Armuelles|Puerto Barrios|Puerto Bello|Puerto Cabello|Puerto Cabezas|Puerto La Cruz|Puerto Libertador|Puerto Mexico|Puerto Perez|Puerto Plata|Puerto Principe|Puerto Vallarta|Punta Arenas|Puntarenas|Pyongyang|Quebec|Quepos|Quezaltenango|Quito|Rabat|Rangoon|Ravenna|Rawalpindi|Recife|Redditch|Reggio|Regina|Reichenberg|Rennes|Reval|Reykjavik|Reynosa|Rheims|Rhenish|Ribe|Riga|Rio Bueno|Rio Grande Do Sul|Rio Hacha|Rio de Janeiro|Ritzebuttel|Riviere Du Loup|Riyadh|Rochefort|Rodi Garganico|Rome|Rosario|Roseau|Rostoff|Rotterdam|Roubaix|Rouen|Ruatan|Rustchuk|Sabanilla|Sabine|Safi|Sagua La Granda|Saigon|Saint George’s|Saint John’s|Salango|Salaverry|Salerno|Salina Cruz|Salonika|Saltillo|Salvador|Salzburg|Samana|San Andres|San Antonio|San Benito|San Cristobal|San Felin de Guxols|San Francisco|San Jose|San José|San Juan|San Juan de los Remedios|San Juan del Norte|San Juan del Sur|San Lucar de Barrameda|San Luis Potosi|San Marino|San Pedro Sula|San Pedro de Macoris|San Remo|San Salvador|San Sebastian|Sanaa|Sana’a|Sancti Spiritus|Santa Clara|Santa Cruz|Santa Cruz Point|Santa Fe|Santa Marta|Santa Rosalia|Santander|Santiago|Santiago de Los Caballeros|Santo Domingo|Santos|Sao Tome|Sapporo|Sarajevo|Sarnia|Sault Ste. Marie|Savannah La Mar|Schiedam|Sedan|Seoul|Setubal|Seville|Seychelles|Shanghai|Sheffield|Shenyang|Sherbrooke|Shimonoseki|Shiraz|Sidon|Sierra Mojada|Simoda|Simonstown|Singapore|Sivas|Skopje|Sligo|Smith’s Falls|Sofia|Sohag|Solingen|Songkhla|Sonneberg|Sorau|Sorrento|Southampton|Spezzia|St. Andero|St. Ann’s Bay|St. Catherines|St. Etienne|St. Eustatius|St. Gall|St. George|St. George’s|St. Helen’s|St. John|St. Johns|St. Leonards|St. Malo|St. Marc|St. Michael’s|St. Nazaire|St. Petersburg|St. Salvador|St. Stephen|Stanbridge|Stanleyville|Stanstead Junction|Stavanger|Stettin|Stockholm|Stoke on Trent|Strasbourg|Stratford|Stuttgart|Sudbury|Suez|Sunderland|Sundsvall|Surabaya|Sutton|Suva|Swatow|Swinemunde|Sydney|Syra|São Paulo|Tabasco|Tabriz|Tacna|Taganrog|Taipei|Taiz|Talcahuano|Tallinn|Tamatave|Tampico|Tangier|Tapachula|Taranto|Tarawa Atoll|Tarragona|Tarsus|Tashkent|Tbilisi|Tegucigalpa|Tehran|Tehuantepect|Tel Aviv|Tela|Tereira|Tetouan|The Hague|Thessaloniki|Thimphu|Tientsin|Tiflis|Tihwa|Tijuana|Tirana|Tirane|Tlacotalpam|Tocopilla|Tokyo|Topia|Topolobampo|Toronto|Torreon|Torrevieja|Toulon|Toulouse|Tovar|Trapani|Trebizond|Trenton|Trieste|Trinidad|Tripoli|Tromso|Trondhjem|Troon|Troyes|Trujillo|Tsinan|Tsingtao|Tumbes|Tunis|Tunstall|Turin|Tutuila|Tuxpam|Udorn|Ulaanbaatar|Utilla|Vaduz|Vaiaku village|Valdivia|Valencia|Valera|Valletta|Valparaiso|Vancouver|Vardo|Vatican City|Velasco|Venice|Vera Cruz|Verona|Versailles|Verviers|Vevey|Vianna|Viborg|Victoria|Vienna|Vientiane|Vigo|Vilnius|Vivero|Vlaardingen|Vladivostok|Volo|Warsaw|Washington|Washington, D.C.|Waterford|Waterloo|Waubaushene|Weimar|Wellington|Weymouth|Whitby|White Horse|Wiarton|Windhoek|Windsor|Wingham|Winnipeg|Winterthur|Wolverhampton|Worcester|Wuhan|Yalta|Yamoussoukro|Yangon|Yaounde|Yekaterinburg|Yenan|Yerevan|Yokkaichi|Yokohama|Yuscaran|Zacatecas|Zagreb|Zante|Zanzibar|Zaza|Zittau|Zomba|Zurich)'

let $docIssues :=

  for $doc in $v//tei:div[attribute::type='document'][not(contains(tei:head,'Editor'))]
  
  let $docID := data($doc/attribute::xml:id)
  let $volID := data($doc/ancestor::tei:TEI/attribute::xml:id)
  let $url := concat('https://history.state.gov/historicaldocuments/',$volID,'/',$docID)

  let $head := functx:remove-elements-not-contents($doc/tei:head, 'hi')  
  let $headReplace := normalize-space(replace(replace(data($head), 'p. m.', 'p.m.'),'a. m.', 'a.m.'))
  
  let $dateInHead := $head/tei:date
  
  (: dateTime in Head :)
  let $dResult :=
  
    let $d := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space(serialize(data($headReplace))),'(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+\d{4}'))),'\s\s+'))[1]
        
    let $year := substring-after($d, ', ')
    let $month :=
          switch (substring-before($d,' '))
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
    let $day := data(substring-after(substring-before($d, ','),' '))
        
    let $dISO := concat($year,'-',$month,'-',functx:pad-integer-to-length($day,2))
    
    let $phraseBeforeDate := 
    
    functx:substring-after-last(substring-before(normalize-space(serialize(data($headReplace))),concat(', ', data($d))),', ')
    
    let $phraseAfterDate := substring-after(normalize-space(serialize(data($headReplace))), concat(data($d),', '))
    
    let $timeFrom := 
    
    if (matches(data($phraseBeforeDate),'(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
    then (tokenize(functx:trim(serialize(functx:get-matches(data($phraseBeforeDate), '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))),'\s\s+'))[1]
    else 
      if (matches(data($phraseAfterDate),'(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
      then (tokenize(functx:trim(serialize(functx:get-matches(data($phraseAfterDate), '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))),'\s\s+'))[1]
      
      else null

    let $timeFromISO :=
    
      if (matches($timeFrom, 'noon'))
      then '12:00:00'
      else
        if (matches($timeFrom, 'midnight'))
        then '00:00:00'
        else
          if (contains($timeFrom, 'a.m.'))
          then
            replace(
              replace(
                replace($timeFrom,' [ap]\.m\.',':00'),
              '^(\d{1}):','0$1:'),
            '^(\d{2}):00$','$1:00:00')
            else
              if (contains($timeFrom, 'p.m.'))
              then
              
              let $replacePM :=
              replace($timeFrom,' [ap]\.m\.',':00')
              let $add12 := xs:integer(substring-before($replacePM,':')) + 12
              
              let $adjustAdd12 := replace(xs:string($add12),'24','12')
                
              let $finish := replace(
                replace($replacePM, '^\d{1,2}:', concat($adjustAdd12, ':')),
                '^(\d{2}):00$','$1:00:00')
            return $finish
                 else ''
 
    let $timeTo := 
    
      if (matches($phraseBeforeDate, '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
      then (tokenize(functx:trim(serialize(functx:get-matches(data($phraseBeforeDate), '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))),'\s\s+'))[2]
      else
          if (matches($phraseAfterDate, '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))
          then (tokenize(functx:trim(serialize(functx:get-matches(data($phraseAfterDate), '(\d{1,2}(:\d{2})? [ap]\.m\.|noon|midnight)'))),'\s\s+'))[2]
          else null

    let $timeToISO :=
         
      if (matches($timeTo, 'noon'))
      then '12:00:00'
      else
        if (matches($timeTo, 'midnight'))
        then '00:00:00'
        else
          if (contains($timeTo, 'a.m.'))
          then
            replace(
              replace(
                replace($timeTo,' [ap]\.m\.',':00'),
              '^(\d{1}):','0$1:'),
            '^(\d{2}):00$','$1:00:00')
            else
              if (contains($timeTo, 'p.m.'))
              then
              
              let $replacePMto :=
              replace($timeTo,' [ap]\.m\.',':00')
              let $add12to := xs:integer(substring-before($replacePMto,':')) + 12
              
              let $adjustAdd12to := replace(xs:string($add12to),'24','12')
                
              let $finishTo := replace(
                replace($replacePMto, '^\d{1,2}:', concat($adjustAdd12to, ':')),
                '^(\d{2}):00$','$1:00:00')
            return $finishTo
                 else ''        
    return 
    
    if (exists($timeTo))
    then 
    <date from="{concat(data($dISO),'T',data($timeFromISO))}" to="{concat(data($dISO),'T',data($timeToISO))}" ana="#date_undated-inferred-from-document-head">{$d}, {$timeFrom} to {$timeTo}</date>
    else
      if (exists($timeFrom))
      then 
      <date when="{concat(data($dISO),'T',data($timeFromISO))}" ana="#date_undated-inferred-from-document-head">{$d}, {$timeFrom}</date>
      else
        if (exists($d))
        then <date when="{data($dISO)}" ana="#date_undated-inferred-from-document-head">{$d}</date>
        else <date>undated</date>
   
  let $date := 
    if (exists($dateInHead))
    then
      normalize-space(serialize(
    functx:remove-attributes-deep(functx:remove-elements-not-contents($dateInHead, 'hi'),('xmlns','xmlns:frus','xmlns:xi'))))  
      else
      serialize($dResult)

  (: Place in Head :)
  let $placeEntry := data($coll//tei:div[attribute::type='document']//tei:dateline/tei:placeName)
  
  let $placeList :=
    for $p in distinct-values($placeEntry)
    let $pNormal := normalize-space($p)
    order by $pNormal ascending
    return <place>{$pNormal}</place>
    
  let $phraseBefore :=       
        functx:substring-after-last(
          normalize-space(
            substring-before(
              serialize(data($head)), ', '
              (:
              concat(', ', data($date))
              :)
            )
          ),
         ', ')    

  let $pMatch := 
      if (matches($headReplace, $cities))
      then <placeName>{functx:trim(normalize-space(serialize(functx:get-matches($headReplace, $cities))))}</placeName>
      else '' 

  let $fr := (' xmlns="http://www.tei-c.org/ns/1.0"')
  let $to := ('')

  let $place := 
    if (exists($head/tei:placeName))
    then 
      functx:replace-multi(normalize-space(serialize(
    functx:remove-attributes-deep($head/tei:placeName,('xmlns','xmlns:frus','xmlns:xi')))),$fr,$to)
    else ''

  (: New Dateline from Head :)
  let $newDateline :=    
      if (exists($place) and not($place eq ''))
      then
        <dateline>
          {$place}, {functx:replace-multi($date,$fr,$to)}
        </dateline>
      else
        if (exists($pMatch) and not($pMatch eq ''))
        then
          <dateline>
            {serialize($pMatch)}, {functx:replace-multi($date,$fr,$to)}
          </dateline>
        else
         <dateline>
              {functx:replace-multi($date, $fr, $to)}
         </dateline>

(: Unmarked Dateline in Text :)
let $unmarkedDateline := 
  for $u in $doc//tei:p[tei:date]
  let $s := serialize(functx:remove-attributes-deep($u,('xmlns','xmlns:frus','xmlns:xi')))
  let $sFr := ('<p([ >])', '</p>', ' xmlns="http://www.tei-c.org/ns/1.0"')
  let $sTo := ('<dateline$1', '</dateline>', '')
  return functx:replace-multi($s, $sFr, $sTo)
  

(: Unmarked Dateline in Postscript:)
let $postscriptDateline := 
  for $postscript in functx:remove-elements-not-contents($doc//tei:postscript, 'hi')
  let $psDate := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space(serialize(data($postscript))),'((\d{1,2}[(st)(nd)(rd)(th)]*\s+(January|February|March|April|May|June|July|August|September|October|November|December),*\s+\d{4})|((January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}[(st)(nd)(rd)(th)]*,\s+\d{4}))'))),'\s\s+'))[1]
  
  let $psYear := functx:trim(serialize(functx:get-matches($psDate, '\d{4}$')))    

  let $psDay := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space(substring-before($psDate, xs:string($psYear))),'\d{1,2}'))),'\s\s+'))[1]

  let $psMonth :=
    switch (functx:trim((serialize(functx:get-matches($psDate,'(January|February|March|April|May|June|July|August|September|October|November|December)')))))
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
    
  let $psISO := concat($psYear,'-',$psMonth,'-',functx:pad-integer-to-length($psDay,2))
        
  let $psPlace := <placeName><hi rend="smallcaps">{functx:trim(normalize-space(serialize(functx:get-matches(data($postscript), $cities))))}</hi></placeName>
    
  where $postscript[matches(.,'((\d{1,2}[(st)(nd)(rd)(th)]*\s+(January|February|March|April|May|June|July|August|September|October|November|December),*\s+\d{4})|((January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}[(st)(nd)(rd)(th)]*,\s+\d{4}))')]

  return 
    if (not(empty($psPlace)))
    then 
      <closer>
         <dateline>{$psPlace}, <date when="{$psISO}">{$psDate}</date>.</dateline>
      </closer>
    else
        if (not(empty($psDate)))
        then 
          <closer>
            <dateline><date when="{$psISO}">{$psDate}</date>.</dateline>
          </closer>
        else ''

(: Unmarked Dateline in Last Paragraph of Document :)
let $possibleCloserDateline := 

  for $possibleCloser in serialize(functx:remove-elements-not-contents($doc/tei:p[last()], 'hi'))
  let $possibleCloserDate := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space($possibleCloser),'((\d{1,2}[(st)(nd)(rd)(th)]*\s+(January|February|March|April|May|June|July|August|September|October|November|December),*\s+\d{4})|((January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}[(st)(nd)(rd)(th)]*,\s+\d{4}))'))),'\s\s+'))[1]

  let $pcdYear := functx:trim(serialize(functx:get-matches($possibleCloserDate, '\d{4}$')))                
  let $pcdDay := (tokenize(functx:trim(serialize(functx:get-matches(normalize-space(substring-before($possibleCloserDate, xs:string($pcdYear))),'\d{1,2}'))),'\s\s+'))[1]
    
  let $pcdMonth :=
    switch (functx:trim((serialize(functx:get-matches($possibleCloserDate,'(January|February|March|April|May|June|July|August|September|October|November|December)')))))
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
    
  let $pcdISO := concat($pcdYear,'-',$pcdMonth,'-',functx:pad-integer-to-length($pcdDay,2))
        
  let $possiblePlace := <placeName><hi rend="smallcaps">{functx:trim(normalize-space(serialize(functx:get-matches(data($possibleCloser), $cities))))}</hi></placeName>
    
  where $possibleCloser[matches(.,'((\d{1,2}[(st)(nd)(rd)(th)]*\s+(January|February|March|April|May|June|July|August|September|October|November|December),*\s+\d{4})|((January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2}[(st)(nd)(rd)(th)]*,\s+\d{4}))')]

  return 
  <closer>
    <dateline>{$possiblePlace}, <date when="{$pcdISO}">{$possibleCloserDate}</date>.</dateline>
  </closer> 
    
where
    
  (not(exists($doc//tei:dateline))) and
  (
    not(empty($newDateline)) or not(empty($unmarkedDateline)) or not(empty($postscriptDateline)) or not(empty($possibleCloserDateline))
  )

  return 
  
    if (not(empty($unmarkedDateline)))
    then concat('- [x] ',$url,'&#10;',string-join(
  ('  - [x] Edit existing `p` to `dateline` (Move to `closer` as necessary):&#10;```xml&#10;',$unmarkedDateline,'&#10;```'),'&#10;'))
    else
      if (not(empty($postscriptDateline)))
      then concat('- [x] ',$url,'&#10;',string-join(
  ('  - [x] Edit existing `postscript/p` to `closer/dateline`:&#10;```xml&#10;',serialize($postscriptDateline),'```&#10;**OR**&#10;  - [x] Add `dateline`:&#10;```xml&#10;<dateline>',$newDateline,'</dateline>&#10;```'),'&#10;'))
      else
          if (not(empty($possibleCloserDateline)))
          then concat('- [x] ',$url,'&#10;',string-join(
    ('  - [x] Edit existing `p` and add `dateline` to new `closer`:&#10;```xml',serialize($possibleCloserDateline),'```&#10;**OR**&#10;  - [x] Add `dateline`:&#10;```xml&#10;<dateline>',$newDateline,'</dateline>&#10;```'),'&#10;'))
          else
            if (not(empty($newDateline)))
            then concat('- [x] ',$url,'&#10;',string-join(
            ('  - [x] Add `dateline`:&#10;```xml&#10;<dateline>',$newDateline,'</dateline>&#10;```'),'&#10;'))
            else 'error'


where 
  (not(empty($docIssues))) 

return string-join($docIssues,'&#10;')



(:

return concat('Add missing `dateline` in ', $vID,'&#10;',string-join($docIssues,'&#10;'), '&#10;----------&#10;')

return string-join($docIssues,'&#10;')
:)
(:,'&#10;----------&#10;') :)