let $coll := collection('locales')

let $capitals := ('Abu Dhabi', 'Abuja', 'Accra', 'Addis Ababa', 'Algiers', 'Amman', 'Andorra la Vella', 'Ankara', 'Antananarivo', 'Apia', 'Ashgabat', 'Asmara', 'Astana', 'Asuncion', 'Athens', 'Baku', 'Bandar Seri Begawan', 'Baghdad', 'Bamako', 'Bangkok', 'Bangui', 'Banjul', 'Basseterre', 'Beijing', 'Beirut', 'Belgrade', 'Belmopan', 'Belfast', 'Berlin', 'Bern', 'Bishkek', 'Bissau', 'Bogota', 'Bonn', 'Brasilia', 'Bratislava', 'Brazzaville', 'Bridgetown', 'Brussels', 'Budapest', 'Bucharest', 'Buenos Aires', 'Bujumbura', 'Cairo', 'Canberra', 'Caracas', 'Cardiff', 'Castries', 'Cayenne', 'Chisinau', 'Kishinev', 'Colombo', 'Conakry', 'Copenhagen', 'Dakar', 'Damascus', 'Dhaka', 'Dar es Salaam', 'Dili', 'Djibouti', 'Doha', 'Dublin', 'Dushanbe', 'Edinburgh', 'Freetown', 'Gaborone', 'Georgetown', 'Guatemala City', 'Hanoi', 'Harare', 'Havana', 'Helsinki', 'Honiara', 'Islamabad', 'Jakarta', 'Juba', 'Kabul', 'Kathmandu', 'Kampala', 'Khartoum', 'Kiev', 'Kigali', 'Kingston', 'Kingstown', 'Kinshasa', 'Kuala Lumpur', 'Kuwait City', 'La Paz', 'Libreville', 'Lilongwe', 'Lima', 'Lisbon', 'Ljubljana', 'Lome', 'London', 'London', 'Luanda', 'Lusaka', 'Luxembourg', 'Madrid', 'Majuro', 'Malabo', 'Male', 'Managua', 'Manama', 'Manila', 'Maputo', 'Maseru', 'Mbabana', 'Melekeok', 'Mexico City', 'Minsk', 'Mogadishu', 'Monaco', 'Monrovia', 'Montevideo', 'Moroni', 'Moscow', 'Muscat', 'Nairobi', 'Nassau', 'N&#39;Djamena', 'New Delhi', 'Niamey', 'Nicosia', 'Nouakchott', 'Nuku&#39;alofa', 'Ouagadougou', 'Oslo', 'Ottawa', 'Palikir', 'Panama City', 'Paramaribo', 'Paris', 'Phnom Penh', 'Podgorica', 'Port au Prince', 'Port Louis', 'Port Moresby', 'Port of Spain', 'Port Vila', 'Porto Novo', 'Prague', 'Praia', 'Pretoria', 'Pristina', 'Pyongyang', 'Quito', 'Rabat', 'Rangoon', 'Rio de Janeiro', 'Yangon', 'Reykjavik', 'Riga', 'Riyadh', 'Rome', 'Roseau', 'Saint George&#39;s', 'Saint John&#39;s', 'San Jose', 'San Marino', 'San Salvador', 'Sanaa', 'Santiago', 'Santo Domingo', 'Sao Tome', 'Sarajevo', 'Seoul', 'Singapore', 'Skopje', 'Sofia', 'Stockholm', 'Suva', 'Taipei', 'Tallinn', 'Tarawa Atoll', 'Tashkent', 'Tbilisi', 'Tegucigalpa', 'Tehran', 'Tel Aviv', 'Amsterdam', 'Thimphu', 'Tirana', 'Tirane', 'Tokyo', 'Tripoli', 'Tunis', 'Ulaanbaatar', 'Vaduz', 'Vaiaku village', 'Valletta', 'Vatican City', 'Victoria', 'Vienna', 'Vientiane', 'Vilnius', 'Warsaw', 'Washington', 'Washington, D.C.', 'Wellington', 'Windhoek', 'Yamoussoukro', 'Yaounde', 'Yerevan', 'Zagreb')

let $locale :=
  for $name in distinct-values($coll/locale/name/text())
  order by $name ascending
  return normalize-space($name)

let $combined := ($capitals, $locale)

let $unique :=
  for $distinct in distinct-values($combined)
  let $d := replace(replace(replace($distinct,"'","’"),"pozzuoli","Pozzuoli"),"APP Alexandria","Alexandria")
  order by $d ascending
  return $d

return string-join($unique,'|')