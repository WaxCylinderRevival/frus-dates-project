xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace frus="http://history.state.gov/frus/ns/1.0";

import module namespace functx="http://www.functx.com" at "functx-1.0.xq";

let $coll := collection('frus-volumes')

let $cities :=

<cities>
<city>Aarhus</city>
<city>Aberdeen</city>
<city>Abidjan</city>
<city>Abo</city>
<city>Abu Dhabi</city>
<city>Abuja</city>
<city>Acajutla</city>
<city>Acapulco</city>
<city>Accra</city>
<city>Adana</city>
<city>Addis Ababa</city>
<city>Adelaide</city>
<city>Aden</city>
<city>Adrianople</city>
<city>Aegean Sea Islands</city>
<city>Agua Prieta</city>
<city>Aguadilla</city>
<city>Aguas Calientes</city>
<city>Aguatulco</city>
<city>Aintab</city>
<city>Aix La Chapelle</city>
<city>Akyab</city>
<city>Alamos</city>
<city>Albany</city>
<city>Albert Town</city>
<city>Aleppo</city>
<city>Alexandretta</city>
<city>Alexandria</city>
<city>Algeciras</city>
<city>Algiers</city>
<city>Algoma</city>
<city>Alicante</city>
<city>Almaty</city>
<city>Almeria</city>
<city>Almirante</city>
<city>Altata</city>
<city>Altona</city>
<city>Alvouro Obregon</city>
<city>Amherstburg</city>
<city>Amiens</city>
<city>Amman</city>
<city>Amoor River</city>
<city>Amoy</city>
<city>Ampala</city>
<city>Amsterdam</city>
<city>Ancona</city>
<city>Andorra</city>
<city>Andorra la Vella</city>
<city>Angers</city>
<city>Ankara</city>
<city>Antananarivo</city>
<city>Antilla</city>
<city>Antioch</city>
<city>Antofagasta</city>
<city>Antung</city>
<city>Antwerp</city>
<city>Apia</city>
<city>Aquin</city>
<city>Aracaju</city>
<city>Archangel</city>
<city>Arecibo</city>
<city>Arendal</city>
<city>Arequipa</city>
<city>Arica</city>
<city>Arnprior</city>
<city>Aruba</city>
<city>Ashgabat</city>
<city>Asmara</city>
<city>Aspinwall</city>
<city>Assioot</city>
<city>Assouan</city>
<city>Astana</city>
<city>Asuncion</city>
<city>Athens</city>
<city>Athlone</city>
<city>Auckland</city>
<city>Augsburg</city>
<city>Aux Cayes</city>
<city>Aveiro</city>
<city>Avlona</city>
<city>Ayamonte</city>
<city>Babelsberg</city>
<city>Baden-Baden</city>
<city>Baghdad</city>
<city>Bahia</city>
<city>Bahia Blanca</city>
<city>Bahia de Caraqeuz</city>
<city>Baida</city>
<city>Baku</city>
<city>Ballina</city>
<city>Ballymena</city>
<city>Bamako</city>
<city>Bamberg</city>
<city>Bandar Seri Begawan</city>
<city>Banes</city>
<city>Bangalore</city>
<city>Bangkok</city>
<city>Bangui</city>
<city>Banja Luca</city>
<city>Banjul</city>
<city>Baracoa</city>
<city>Barcelona</city>
<city>Bari</city>
<city>Barmen</city>
<city>Barnsley</city>
<city>Barranquilla</city>
<city>Barrie</city>
<city>Basel</city>
<city>Basrah</city>
<city>Bassein</city>
<city>Basseterre</city>
<city>Bassorah</city>
<city>Batavian Republic</city>
<city>Batopilas</city>
<city>Batum</city>
<city>Bay of Islands</city>
<city>Bayonne</city>
<city>Beaumaris</city>
<city>Beijing</city>
<city>Beirut</city>
<city>Belem</city>
<city>Belfast</city>
<city>Belgrade</city>
<city>Belize City</city>
<city>Belleville</city>
<city>Bello Horizonte</city>
<city>Belmopan</city>
<city>Benghazi</city>
<city>Beni Saf</city>
<city>Benisouef</city>
<city>Bergen</city>
<city>Berlin</city>
<city>Bern</city>
<city>Biarritz</city>
<city>Bien Hoa</city>
<city>Bilboa</city>
<city>Birmingham</city>
<city>Bishkek</city>
<city>Bissau</city>
<city>Bizerta</city>
<city>Black River</city>
<city>Bloemfontein</city>
<city>Bluefields</city>
<city>Bocas del Toro</city>
<city>Bogota</city>
<city>Boguillas</city>
<city>Bologna</city>
<city>Boma</city>
<city>Bonacca</city>
<city>Bone-Bona</city>
<city>Bonn</city>
<city>Boodroom</city>
<city>Bordeaux</city>
<city>Boulogne</city>
<city>Bradford</city>
<city>Brake</city>
<city>Brantford</city>
<city>Brasilia</city>
<city>Bratislava</city>
<city>Brazoria</city>
<city>Brazzaville</city>
<city>Bremen</city>
<city>Bremerhaven</city>
<city>Breslau</city>
<city>Brest</city>
<city>Bridgetown</city>
<city>Brindisi</city>
<city>Brisbane</city>
<city>Bristol</city>
<city>Brockville</city>
<city>Brousa</city>
<city>Brunn</city>
<city>Brussels</city>
<city>Bucharest</city>
<city>Budapest</city>
<city>Buenaventura</city>
<city>Buenos Aires</city>
<city>Bujumbura</city>
<city>Bukavu</city>
<city>Burslem</city>
<city>Burtscheid</city>
<city>Busan</city>
<city>Cadiz</city>
<city>Cagliari</city>
<city>Caibarien</city>
<city>Caimanera</city>
<city>Cairo</city>
<city>Calais</city>
<city>Caldera</city>
<city>Calgary</city>
<city>Cali</city>
<city>Callao</city>
<city>Camaguey</city>
<city>Camargo</city>
<city>Camp David</city>
<city>Campbellton</city>
<city>Campeachy</city>
<city>Can Tho</city>
<city>Cananea</city>
<city>Canberra</city>
<city>Candia</city>
<city>Cannes</city>
<city>Canton</city>
<city>Cape Gracias a Dios</city>
<city>Cape Haitien</city>
<city>Cape Palmas</city>
<city>Cape Town</city>
<city>Capri</city>
<city>Caracas</city>
<city>Cardenas</city>
<city>Cardiff</city>
<city>Carini</city>
<city>Caripito</city>
<city>Carleton</city>
<city>Carlisle</city>
<city>Carlsruhe</city>
<city>Carrara</city>
<city>Carril</city>
<city>Cartagena</city>
<city>Carthagena</city>
<city>Carupano</city>
<city>Casablanca</city>
<city>Cassel</city>
<city>Castellamare</city>
<city>Castries</city>
<city>Catania</city>
<city>Caudry</city>
<city>Cayenne</city>
<city>Ceara</city>
<city>Cebu</city>
<city>Cephalonia Island</city>
<city>Cerro de Pasco</city>
<city>Cette</city>
<city>Ceuta</city>
<city>Champerico</city>
<city>Chanaral</city>
<city>Changchun</city>
<city>Changsha</city>
<city>Charleroi</city>
<city>Chatham</city>
<city>Chaux-de-fonds</city>
<city>Chefoo</city>
<city>Chengdu</city>
<city>Chennai</city>
<city>Cherbourg</city>
<city>Chiang Mai</city>
<city>Chiclayo</city>
<city>Chicoutimi</city>
<city>Chihuahua</city>
<city>Chimbote</city>
<city>Chinanfu</city>
<city>Chinkiang</city>
<city>Chisinau</city>
<city>Chittagong</city>
<city>Christchurch</city>
<city>Christiansand</city>
<city>Chungking</city>
<city>Chunking</city>
<city>Chuquicamata</city>
<city>Cienfuegos</city>
<city>Ciudad Bolivar</city>
<city>Ciudad Del Carmen</city>
<city>Ciudad Juarez</city>
<city>Ciudad Obregon</city>
<city>Ciudad Porfirio Diaz</city>
<city>Ciudad Trujillo</city>
<city>Civita Vecchia</city>
<city>Clarenceville</city>
<city>Clifton</city>
<city>Clinton</city>
<city>Cluj-Napoca</city>
<city>Coatzacoalcos</city>
<city>Cobh</city>
<city>Coblentz</city>
<city>Coburg</city>
<city>Cochabamba</city>
<city>Cochin</city>
<city>Coconada</city>
<city>Cognac</city>
<city>Collingwood</city>
<city>Collo</city>
<city>Cologne</city>
<city>Colombo</city>
<city>Colon</city>
<city>Colonia</city>
<city>Comayagua</city>
<city>Conakry</city>
<city>Concepcion</city>
<city>Concepcion Del Oro</city>
<city>Constantine</city>
<city>Copalquin</city>
<city>Copenhagen</city>
<city>Coquimbo</city>
<city>Corcubion</city>
<city>Cordoba</city>
<city>Corfu</city>
<city>Corinto</city>
<city>Cork</city>
<city>Corn Island</city>
<city>Cornwall</city>
<city>Cornwallis</city>
<city>Coro</city>
<city>Coronel</city>
<city>Corunna</city>
<city>Coteau</city>
<city>Cotonou</city>
<city>Courtwright</city>
<city>Crefeld</city>
<city>Cronstadt</city>
<city>Cruz Grande</city>
<city>Cumana</city>
<city>Curacao</city>
<city>Curitiba</city>
<city>Curityba</city>
<city>Cuxhaven</city>
<city>Daiguiri</city>
<city>Dairen</city>
<city>Dakar</city>
<city>Damascus</city>
<city>Damietta</city>
<city>Danang</city>
<city>Danzig</city>
<city>Dar es Salaam</city>
<city>Dardanelles</city>
<city>Dartmouth</city>
<city>Denia</city>
<city>Derby</city>
<city>Deseronto</city>
<city>Desterro</city>
<city>Dhahran</city>
<city>Dhaka</city>
<city>Dieppe</city>
<city>Dijon</city>
<city>Dili</city>
<city>Djibouti</city>
<city>Doha</city>
<city>Douala</city>
<city>Dover</city>
<city>Dresden</city>
<city>Duart</city>
<city>Dubai</city>
<city>Dublin</city>
<city>Dundee</city>
<city>Dunedin</city>
<city>Dunfermline</city>
<city>Dunkirk</city>
<city>Dunmore Town</city>
<city>Durango</city>
<city>Durban</city>
<city>Dushanbe</city>
<city>Dyreford</city>
<city>Düsseldorf</city>
<city>East London</city>
<city>Edinburgh</city>
<city>Edmonton</city>
<city>Eibenstock</city>
<city>El Jadida</city>
<city>Elizabethville</city>
<city>Elsinore</city>
<city>Emden</city>
<city>Emerson</city>
<city>Ensenada</city>
<city>Enugu</city>
<city>Erbil</city>
<city>Erfurt</city>
<city>Erie</city>
<city>Erzerum</city>
<city>Esbjerg</city>
<city>Esmeraldas</city>
<city>Essaouira</city>
<city>Essen</city>
<city>Eten</city>
<city>Fajardo</city>
<city>Falmouth</city>
<city>Farnham</city>
<city>Faro</city>
<city>Fayal</city>
<city>Ferrol</city>
<city>Fiume</city>
<city>Florence</city>
<city>Flores</city>
<city>Florianopolis</city>
<city>Flushing</city>
<city>Foochow</city>
<city>Fort Erie</city>
<city>Fort William and Port Authur</city>
<city>Fortaleza</city>
<city>Foynes</city>
<city>Frankfurt</city>
<city>Fredericia</city>
<city>Fredericton</city>
<city>Freetown</city>
<city>Frelighsburg</city>
<city>Frieburg</city>
<city>Frontera</city>
<city>Fukuoka</city>
<city>Funchal</city>
<city>Furth</city>
<city>Gaborone</city>
<city>Galashiels</city>
<city>Galliod</city>
<city>Gallipoli</city>
<city>Galt</city>
<city>Galveston</city>
<city>Galway</city>
<city>Gananoque</city>
<city>Garita Gonzales</city>
<city>Garrucha</city>
<city>Gaspe</city>
<city>Gdansk</city>
<city>Geestemunde</city>
<city>Gefle</city>
<city>Geneva</city>
<city>Genoa</city>
<city>Georgetown</city>
<city>Gera</city>
<city>Ghent</city>
<city>Gibara</city>
<city>Gibraltar</city>
<city>Gijon</city>
<city>Gioja</city>
<city>Girgeh</city>
<city>Girgenti</city>
<city>Glasgow</city>
<city>Glauchau</city>
<city>Gloucester</city>
<city>Goderich</city>
<city>Godthaab</city>
<city>Golfito</city>
<city>Gonaives</city>
<city>Gore Bay</city>
<city>Gothenburg</city>
<city>Governor’s Harbor</city>
<city>Graciosa</city>
<city>Granada</city>
<city>Grand Bassa</city>
<city>Grao</city>
<city>Green Turtle Cay</city>
<city>Greenock</city>
<city>Grenoble</city>
<city>Grenville</city>
<city>Guadalajara</city>
<city>Guadalupe Y Calvo</city>
<city>Guanajuato</city>
<city>Guangzhou</city>
<city>Guantanamo</city>
<city>Guatemala</city>
<city>Ciudad de Guatemala</city>
<city>Guatemala City</city>
<city>Guayama</city>
<city>Guayaquil</city>
<city>Guaymas</city>
<city>Guazacualco</city>
<city>Guben</city>
<city>Guelph</city>
<city>Guernsey</city>
<city>Guerrero</city>
<city>Haida</city>
<city>Haifa</city>
<city>Hakodate</city>
<city>Halifax</city>
<city>Halsingborg</city>
<city>Hamburg</city>
<city>Hamilton</city>
<city>Hammerfest</city>
<city>Hangchow</city>
<city>Hankow</city>
<city>Hanoi</city>
<city>Hanover</city>
<city>Harare</city>
<city>Harbin</city>
<city>Harburg</city>
<city>Harput</city>
<city>Hartlepool</city>
<city>Habana</city>
<city>Havana</city>
<city>Havre</city>
<city>Havre De Grace</city>
<city>Helder</city>
<city>Helsingborg</city>
<city>Helsinki</city>
<city>Hemmingford</city>
<city>Herat</city>
<city>Hermosillo</city>
<city>Hesse Cassel</city>
<city>Hesse Darmstadt</city>
<city>Hilo</city>
<city>Hinchenbrooke</city>
<city>Ho Chi Minh City</city>
<city>Holy See</city>
<city>Holyhead</city>
<city>Homs</city>
<city>Honda</city>
<city>Honfleur</city>
<city>Hong Kong</city>
<city>Honiara</city>
<city>Honolulu</city>
<city>Hoochelaga and Longeuil</city>
<city>Horgen</city>
<city>Horta</city>
<city>Huangpu</city>
<city>Huddersfield</city>
<city>Hue</city>
<city>Huelva</city>
<city>Hull</city>
<city>Huntington</city>
<city>Hyde Park</city>
<city>Hyderabad</city>
<city>Ibadan</city>
<city>Ichang</city>
<city>Ile De Re</city>
<city>Ilo</city>
<city>Innsbruck</city>
<city>Iquique</city>
<city>Iquitos</city>
<city>Isfahan</city>
<city>Iskenderun</city>
<city>Islamabad</city>
<city>Isle of Wight</city>
<city>Ismaila</city>
<city>Istanbul</city>
<city>Ivica</city>
<city>Izmir</city>
<city>Jacmel</city>
<city>Jaffa</city>
<city>Jaffna</city>
<city>Jakarta</city>
<city>Jalapa</city>
<city>Jeddah</city>
<city>Jeremie</city>
<city>Jeres de la Frontera</city>
<city>Jerusalem</city>
<city>Johannesburg</city>
<city>Juba</city>
<city>Kabul</city>
<city>Kaduna</city>
<city>Kahului</city>
<city>Kalamata</city>
<city>Kalgan</city>
<city>Kampala</city>
<city>Kanagawa</city>
<city>Karachi</city>
<city>Kathmandu</city>
<city>Kehl</city>
<city>Keneh</city>
<city>Kenora</city>
<city>Khartoum</city>
<city>Khorramshahr</city>
<city>Kidderminster</city>
<city>Kiev</city>
<city>Kigali</city>
<city>Kingston</city>
<city>Kingston upon Hull</city>
<city>Kingstown</city>
<city>Kinshasa</city>
<city>Kirkaldy</city>
<city>Kirkuk</city>
<city>Kisangani</city>
<city>Kishinev</city>
<city>Kiu Kiang</city>
<city>Kobe</city>
<city>Kolding</city>
<city>Kolkata</city>
<city>Kolonia</city>
<city>Konigsberg</city>
<city>Koror</city>
<city>Kovno</city>
<city>Krakow</city>
<city>Kuala Lumpur</city>
<city>Kuching</city>
<city>Kunming</city>
<city>Kuwait City</city>
<city>Kweilin</city>
<city>Kyiv</city>
<city>La Ceiba</city>
<city>La Guaira</city>
<city>La Oroya</city>
<city>La Paz</city>
<city>La Rochelle</city>
<city>La Romana</city>
<city>Lachine</city>
<city>Lacolle</city>
<city>Lagos</city>
<city>Laguna De Terminos</city>
<city>Lahore</city>
<city>Lambayeque</city>
<city>Langen Schwalbach</city>
<city>Laraiche and Asilah</city>
<city>Latakia</city>
<city>Lausanne</city>
<city>Lauthala</city>
<city>Leeds</city>
<city>Leghorn</city>
<city>Leicester</city>
<city>Leige</city>
<city>Leipzig</city>
<city>Leith</city>
<city>Leningrad</city>
<city>Leone</city>
<city>Lethbridge</city>
<city>Levis</city>
<city>Levuka</city>
<city>Libau</city>
<city>Libreville</city>
<city>Lille</city>
<city>Lilongwe</city>
<city>Lima</city>
<city>Limassol</city>
<city>Limerick</city>
<city>Limoges</city>
<city>Lindsay</city>
<city>Lisbon</city>
<city>Liverpool</city>
<city>Livingston</city>
<city>Ljubljana</city>
<city>Llanelly</city>
<city>Lobos</city>
<city>Lodz</city>
<city>Lome</city>
<city>Londenderry</city>
<city>London</city>
<city>Londonderry</city>
<city>Los Mochis</city>
<city>Luanda</city>
<city>Lubeck</city>
<city>Lucerne</city>
<city>Lugano</city>
<city>Luneburg</city>
<city>Lurgan</city>
<city>Lusaka</city>
<city>Luxembourg</city>
<city>Luxor</city>
<city>Lyon</city>
<city>Macau</city>
<city>Maceio</city>
<city>Madras</city>
<city>Madrid</city>
<city>Magallanes</city>
<city>Magdalen Islands</city>
<city>Magdalena</city>
<city>Magdeburg</city>
<city>Mahukona</city>
<city>Mainz</city>
<city>Majuro</city>
<city>Malabo</city>
<city>Malaga</city>
<city>Maldives</city>
<city>Male</city>
<city>Malmo</city>
<city>Malta</city>
<city>Managua</city>
<city>Manama</city>
<city>Manaos</city>
<city>Manaus</city>
<city>Manchester</city>
<city>Mandalay</city>
<city>Manila</city>
<city>Mannheim</city>
<city>Mansurah</city>
<city>Manta</city>
<city>Manzanillo</city>
<city>Maputo</city>
<city>Maracaibo</city>
<city>Maranhao</city>
<city>Marash</city>
<city>Markneukirchen</city>
<city>Marseille</city>
<city>Maseru</city>
<city>Matagalpa</city>
<city>Matagorda</city>
<city>Matamoros</city>
<city>Matanzas</city>
<city>Matthew Town</city>
<city>Mayaguez</city>
<city>Mazar-e-Sharif</city>
<city>Mazatlan</city>
<city>Mbabana</city>
<city>Mbabane</city>
<city>Medan</city>
<city>Medellin</city>
<city>Melbourne</city>
<city>Melekeok</city>
<city>Melilla</city>
<city>Mendoza</city>
<city>Mentone</city>
<city>Merida</city>
<city>Mersine</city>
<city>Meshed</city>
<city>Messina</city>
<city>Mexicali</city>
<city>Mexico City</city>
<city>Mexico, D. F.</city>
<city>México, D. F.</city>
<city>Midland</city>
<city>Mier</city>
<city>Milan</city>
<city>Milazzo</city>
<city>Milford Haven</city>
<city>Milk River</city>
<city>Minatitlan</city>
<city>Minich</city>
<city>Minsk</city>
<city>Miragoane</city>
<city>Mogadishu</city>
<city>Mollendo</city>
<city>Mombasa</city>
<city>Monaco</city>
<city>Monganui</city>
<city>Monrovia</city>
<city>Montego Bay</city>
<city>Monterrey</city>
<city>Montevideo</city>
<city>Montreal</city>
<city>Morelia</city>
<city>Morlaix</city>
<city>Moroni</city>
<city>Morpeth</city>
<city>Morrisburgh</city>
<city>Moscow</city>
<city>Mostar</city>
<city>Moulmein</city>
<city>Mukden</city>
<city>Mulhausen</city>
<city>Mumbai</city>
<city>Munich</city>
<city>Murree</city>
<city>Muscat</city>
<city>Nacaome</city>
<city>Nagasaki</city>
<city>Nagoya</city>
<city>Naguabo</city>
<city>Naha, Okinawa</city>
<city>Nairobi</city>
<city>Nancy</city>
<city>Nanking</city>
<city>Nantes</city>
<city>Napanee</city>
<city>Naples</city>
<city>Nassau</city>
<city>Natal</city>
<city>Neustadt</city>
<city>New Delhi</city>
<city>New York</city>
<city>Newcastle</city>
<city>Newchwang</city>
<city>Newport</city>
<city>Newry</city>
<city>Nha Trang</city>
<city>Niagara Falls</city>
<city>Niamey</city>
<city>Nice</city>
<city>Nicosia</city>
<city>Niewediep</city>
<city>Ningpo</city>
<city>Nogales</city>
<city>Norrkoping</city>
<city>North Bay</city>
<city>Nottingham</city>
<city>Nouakchott</city>
<city>Nuevitas</city>
<city>Nuevo Laredo</city>
<city>Nukualofa</city>
<city>Nuku’alofa</city>
<city>Nuremberg</city>
<city>Nuuk</city>
<city>N’Djamena</city>
<city>N’Djamena</city>
<city>Oaxaca</city>
<city>Ocean Falls</city>
<city>Ocos</city>
<city>Odense</city>
<city>Odessa</city>
<city>Old Harbor</city>
<city>Omoa</city>
<city>Omsk</city>
<city>Oporto</city>
<city>Oran</city>
<city>Orillia</city>
<city>Oruro</city>
<city>Osaka</city>
<city>Oshawa</city>
<city>Oslo</city>
<city>Otranto</city>
<city>Ottawa</city>
<city>Ouagadougou</city>
<city>Owen Sound</city>
<city>Pago Pago</city>
<city>Paita</city>
<city>Palamos</city>
<city>Palermo</city>
<city>Palikir</city>
<city>Palma de Mallorca</city>
<city>Panamá</city>
<city>Panama</city>
<city>Panama City</city>
<city>Pará</city>
<city>Paraiba</city>
<city>Paramaribo</city>
<city>Paris</city>
<city>Parral</city>
<city>Parry Sound</city>
<city>Paso Del Norte</city>
<city>Paspebiac</city>
<city>Patras</city>
<city>Pau</city>
<city>Paysandu</city>
<city>Peiping</city>
<city>Peking</city>
<city>Penang</city>
<city>Penedo</city>
<city>Perigueux</city>
<city>Pernambuco</city>
<city>Perth</city>
<city>Peshawar</city>
<city>Pesth</city>
<city>Peterborough</city>
<city>Petit Goave</city>
<city>Petrograd</city>
<city>Phnom Penh</city>
<city>Picton</city>
<city>Piedras Negras</city>
<city>Piraeus</city>
<city>Piura</city>
<city>Plauen</city>
<city>Plymouth</city>
<city>Podgorica</city>
<city>Point De Galle</city>
<city>Point Levi</city>
<city>Ponce</city>
<city>Ponta Delgada, Azores</city>
<city>Porsgrund</city>
<city>Port Antonio</city>
<city>Port Arthur</city>
<city>Port Elizabeth</city>
<city>Port Hope</city>
<city>Port Limon</city>
<city>Port Louis</city>
<city>Port Maria</city>
<city>Port Morant</city>
<city>Port Moresby</city>
<city>Port Rowan</city>
<city>Port Said</city>
<city>Port St. Mary’s</city>
<city>Port Stanley</city>
<city>Port Vila</city>
<city>Port au Prince</city>
<city>Port de Paix</city>
<city>Port of Marbella</city>
<city>Port of Spain</city>
<city>Port-au-Prince</city>
<city>Porto Alegre</city>
<city>Porto Novo</city>
<city>Portsmouth</city>
<city>Potosi</city>
<city>Potsdam</city>
<city>Poznan</city>
<city>Pozzuoli</city>
<city>Prague</city>
<city>Praha</city>
<city>Praia</city>
<city>Prescott</city>
<city>Pretoria</city>
<city>Prince Rupert</city>
<city>Pristina</city>
<city>Progreso</city>
<city>Puebla</city>
<city>Puerto Armuelles</city>
<city>Puerto Barrios</city>
<city>Puerto Bello</city>
<city>Puerto Cabello</city>
<city>Puerto Cabezas</city>
<city>Puerto La Cruz</city>
<city>Puerto Libertador</city>
<city>Puerto Mexico</city>
<city>Puerto Perez</city>
<city>Puerto Plata</city>
<city>Puerto Principe</city>
<city>Puerto Vallarta</city>
<city>Punta Arenas</city>
<city>Puntarenas</city>
<city>Pyongyang</city>
<city>Quebec</city>
<city>Quepos</city>
<city>Quezaltenango</city>
<city>Quito</city>
<city>Rabat</city>
<city>Rangoon</city>
<city>Ravenna</city>
<city>Rawalpindi</city>
<city>Recife</city>
<city>Redditch</city>
<city>Reggio</city>
<city>Regina</city>
<city>Reichenberg</city>
<city>Rennes</city>
<city>Reval</city>
<city>Reykjavik</city>
<city>Reynosa</city>
<city>Rheims</city>
<city>Rhenish</city>
<city>Ribe</city>
<city>Riga</city>
<city>Rio Bueno</city>
<city>Rio Grande Do Sul</city>
<city>Rio Hacha</city>
<city>Rio de Janeiro</city>
<city>Ritzebuttel</city>
<city>Riviere Du Loup</city>
<city>Riyadh</city>
<city>Rochefort</city>
<city>Rodi Garganico</city>
<city>Rome</city>
<city>Rosario</city>
<city>Roseau</city>
<city>Rostoff</city>
<city>Rotterdam</city>
<city>Roubaix</city>
<city>Rouen</city>
<city>Ruatan</city>
<city>Rustchuk</city>
<city>Sabanilla</city>
<city>Sabine</city>
<city>Safi</city>
<city>Sagua La Granda</city>
<city>Saigon</city>
<city>Saint George’s</city>
<city>Saint John’s</city>
<city>Salango</city>
<city>Salaverry</city>
<city>Salerno</city>
<city>Salina Cruz</city>
<city>Salonika</city>
<city>Saltillo</city>
<city>Salvador</city>
<city>Salzburg</city>
<city>Samana</city>
<city>San Andres</city>
<city>San Antonio</city>
<city>San Benito</city>
<city>San Cristobal</city>
<city>San Felin de Guxols</city>
<city>San Francisco</city>
<city>San Jose</city>
<city>San José</city>
<city>San Juan</city>
<city>San Juan de los Remedios</city>
<city>San Juan del Norte</city>
<city>San Juan del Sur</city>
<city>San Lucar de Barrameda</city>
<city>San Luis Potosi</city>
<city>San Marino</city>
<city>San Pedro Sula</city>
<city>San Pedro de Macoris</city>
<city>San Remo</city>
<city>San Salvador</city>
<city>San Sebastian</city>
<city>Sanaa</city>
<city>Sana’a</city>
<city>Sancti Spiritus</city>
<city>Santa Clara</city>
<city>Santa Cruz</city>
<city>Santa Cruz Point</city>
<city>Santa Fe</city>
<city>Santa Marta</city>
<city>Santa Rosalia</city>
<city>Santander</city>
<city>Santiago</city>
<city>Santiago de Los Caballeros</city>
<city>Santo Domingo</city>
<city>Santos</city>
<city>Sao Tome</city>
<city>Sapporo</city>
<city>Sarajevo</city>
<city>Sarnia</city>
<city>Sault Ste. Marie</city>
<city>Savannah La Mar</city>
<city>Schiedam</city>
<city>Sedan</city>
<city>Seoul</city>
<city>Setubal</city>
<city>Seville</city>
<city>Seychelles</city>
<city>Shanghai</city>
<city>Sheffield</city>
<city>Shenyang</city>
<city>Sherbrooke</city>
<city>Shimonoseki</city>
<city>Shiraz</city>
<city>Sidon</city>
<city>Sierra Mojada</city>
<city>Simoda</city>
<city>Simonstown</city>
<city>Singapore</city>
<city>Sivas</city>
<city>Skopje</city>
<city>Sligo</city>
<city>Smith’s Falls</city>
<city>Sofia</city>
<city>Sohag</city>
<city>Solingen</city>
<city>Songkhla</city>
<city>Sonneberg</city>
<city>Sorau</city>
<city>Sorrento</city>
<city>Southampton</city>
<city>Spezzia</city>
<city>St. Andero</city>
<city>St. Ann’s Bay</city>
<city>St. Catherines</city>
<city>St. Etienne</city>
<city>St. Eustatius</city>
<city>St. Gall</city>
<city>St. George</city>
<city>St. George’s</city>
<city>St. Helen’s</city>
<city>St. John</city>
<city>St. Johns</city>
<city>St. Leonards</city>
<city>St. Malo</city>
<city>St. Marc</city>
<city>St. Michael’s</city>
<city>St. Nazaire</city>
<city>St. Petersburg</city>
<city>St. Salvador</city>
<city>St. Stephen</city>
<city>Stanbridge</city>
<city>Stanleyville</city>
<city>Stanstead Junction</city>
<city>Stavanger</city>
<city>Stettin</city>
<city>Stockholm</city>
<city>Stoke on Trent</city>
<city>Strasbourg</city>
<city>Stratford</city>
<city>Stuttgart</city>
<city>Sudbury</city>
<city>Suez</city>
<city>Sunderland</city>
<city>Sundsvall</city>
<city>Surabaya</city>
<city>Sutton</city>
<city>Suva</city>
<city>Swatow</city>
<city>Swinemunde</city>
<city>Sydney</city>
<city>Syra</city>
<city>São Paulo</city>
<city>Tabasco</city>
<city>Tabriz</city>
<city>Tacna</city>
<city>Taganrog</city>
<city>Taipei</city>
<city>Taiz</city>
<city>Talcahuano</city>
<city>Tallinn</city>
<city>Tamatave</city>
<city>Tampico</city>
<city>Tangier</city>
<city>Tapachula</city>
<city>Taranto</city>
<city>Tarawa Atoll</city>
<city>Tarragona</city>
<city>Tarsus</city>
<city>Tashkent</city>
<city>Tbilisi</city>
<city>Tegucigalpa</city>
<city>Teheran</city>
<city>Tehran</city>
<city>Tehuantepect</city>
<city>Tel Aviv</city>
<city>Tela</city>
<city>Tereira</city>
<city>Tetouan</city>
<city>The Hague</city>
<city>Thessaloniki</city>
<city>Thimphu</city>
<city>Tientsin</city>
<city>Tiflis</city>
<city>Tihwa</city>
<city>Tijuana</city>
<city>Tirana</city>
<city>Tirane</city>
<city>Tlacotalpam</city>
<city>Tocopilla</city>
<city>Tokyo</city>
<city>Topia</city>
<city>Topolobampo</city>
<city>Toronto</city>
<city>Torreon</city>
<city>Torrevieja</city>
<city>Toulon</city>
<city>Toulouse</city>
<city>Tovar</city>
<city>Trapani</city>
<city>Trebizond</city>
<city>Trenton</city>
<city>Trieste</city>
<city>Trinidad</city>
<city>Tripoli</city>
<city>Tromso</city>
<city>Trondhjem</city>
<city>Troon</city>
<city>Troyes</city>
<city>Trujillo</city>
<city>Tsinan</city>
<city>Tsingtao</city>
<city>Tumbes</city>
<city>Tunis</city>
<city>Tunstall</city>
<city>Turin</city>
<city>Tutuila</city>
<city>Tuxpam</city>
<city>Udorn</city>
<city>Ulaanbaatar</city>
<city>Utilla</city>
<city>Vaduz</city>
<city>Vaiaku village</city>
<city>Valdivia</city>
<city>Valencia</city>
<city>Valera</city>
<city>Valletta</city>
<city>Valparaiso</city>
<city>Vancouver</city>
<city>Vardo</city>
<city>Vatican City</city>
<city>Velasco</city>
<city>Venice</city>
<city>Vera Cruz</city>
<city>Verona</city>
<city>Versailles</city>
<city>Verviers</city>
<city>Vevey</city>
<city>Vianna</city>
<city>Viborg</city>
<city>Victoria</city>
<city>Vienna</city>
<city>Vientiane</city>
<city>Vigo</city>
<city>Vilnius</city>
<city>Vivero</city>
<city>Vlaardingen</city>
<city>Vladivostok</city>
<city>Volo</city>
<city>Warsaw</city>
<city>Washington</city>
<city>Washington, D.C.</city>
<city>Waterford</city>
<city>Waterloo</city>
<city>Waubaushene</city>
<city>Weimar</city>
<city>Wellington</city>
<city>Weymouth</city>
<city>Whitby</city>
<city>White Horse</city>
<city>Wiarton</city>
<city>Windhoek</city>
<city>Windsor</city>
<city>Wingham</city>
<city>Winnipeg</city>
<city>Winterthur</city>
<city>Wolverhampton</city>
<city>Worcester</city>
<city>Wuhan</city>
<city>Yalta</city>
<city>Yamoussoukro</city>
<city>Yangon</city>
<city>Yaounde</city>
<city>Yekaterinburg</city>
<city>Yenan</city>
<city>Yerevan</city>
<city>Yokkaichi</city>
<city>Yokohama</city>
<city>Yuscaran</city>
<city>Zacatecas</city>
<city>Zagreb</city>
<city>Zante</city>
<city>Zanzibar</city>
<city>Zaza</city>
<city>Zittau</city>
<city>Zomba</city>
<city>Zurich</city>
</cities>

let $placeName := 

  for $place in data($coll//tei:placeName)
  let $p := normalize-space($place)
  return $p
  
  
let $issue :=
  
  for $distinctPlaces in distinct-values($cities/city)
    
  let $count := count($placeName[contains(.,$distinctPlaces)])
  
  order by $count descending, $distinctPlaces ascending
    
  return concat($distinctPlaces,' | ', $count)
    
return concat('Place Name | Number of Documents&#10; --- | ---&#10;', string-join($issue,'&#10;'))