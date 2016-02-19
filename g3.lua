local g3 = {}

local words = { "aardkors", " balans", " gebreekte", " gebruik", " gedagte", " geeet", " gefluit", " gegrawe", " gehardloop", " geheime", " geheuekaart", " gekreun", 
		"gelukkig", " gelukwensing", " gelykop", " geskenk", " geskreeu", " gewaarsku", " gewildste", " gimnasium", " getalle", " gunsteling", " haaie", " halfmaan",
		" hande", "hansworse", " hartseer", " heining", " heuwel", " handskoen", " verfblikke", " hondekos", " honderd", " hoofletter", " hoofmaaltyd", " horing", " horlosie", 
        "hospitaliseer", " huisvlieg", " hulp", " idees", " iemand", " inhoud", " inhoudsopgawe", " inligting", " inspuiting", " interessant", " Januarie", " jellievis", " joune",
        " jouself", " juwele", " kaartjiekantoor", " kalender", " kameel", " kampioen", " karakters", " katte", " kettings", " kindernuus", " kinders", " kleurvolle", 
        "kleuterskool", " koeldrank", " koerantpapier", " koerantjie", " kombers", " kommunikasie", " kompetisie", " korreltjie", " kort", " koud", " kringetjies", " kwaad", 
        "kwartaal", " KwaZulu-Natal", " landskap", " leesteken", " leeu", " lewende", " liefde", " liewers", " liggaamsdeel", " Limpopo", " luiperds", " maandkaart", " Maandae", 
        "Maart", " masjinis", " medisyne", " meisietjie", " melkbeker", " meneer", " meteens", " middel", " middelmatig", " mieliepitte", " minister", " minute", " moeilike", 
        "moeilikheid", " more", " morsjors", " motorhawe", " Mpumalanga", " musiek", " myne", " natgegooi", " netbaloefening", " netbalspan", " netjiese", " niemand", " niks", 
        "nommerplaat", " Noord-Kaap", " Noordwes", " nuttige", " Nuwejaarsdag", " nuwemaan", " oefening", " olifante", " omgegee", " omgewing", " omkring", " onderaan", 
        "onderstreepte", " onderwyser", " onderwysersdag", " onmiddellik", " onmoontlik", " ontslae", " ontvang", " Oos-Kaap", " opgewonde", " opgewondenheid", " opruiming", 
        "ouer", " padaanwysings", " paddatjie", " parfuum", " partytjie", " penne", " perdekar", " persoonlike", " piekniek", " piepklein", " pikkewyne", " plakkaat", " plek", 
        "plesier", " polisiestasie", " poskaart", " potloodstreep", " pragtige", " prentraam", " probeer", " pronksug", " proppe", " provinsie", " punt", " reeds", " reen", 
        "reenerig", " regterkant", " rekenaar", " rekenaarsentrum", " rekenaarspeletjie", " renosters", " restaurant", " roei", " rolspeler", " rolstoel", " rondstrooi", 
        "rooster", " rowwe", " rugby", " saamdrom", " sakhorlosie", " sakkies", " sambreelstaander", " Saterdae", " seekatte", " seevisse", " seisoene", " sekelmaan", " selfone", 
        "selfsugtig", " sker", " skerm", " skeur", " skilpaaie", " skoenborsel", " skoolkinders", " skoolprogram", " skooluitstappie", " skotteldoek", " skryfbehoeftes", 
        "skrywer", " skuur", " slaperig", " snorkel", " sodat", " soetigheid", " sokkerklere", " solank", " spellys", " spesiale", " berekeninge", " spoorwegstasie", " sport", 
        "spring", " springmielies", " sproet", " stadslewe", " stamperig", " stemme", " sterkste", " stingel", " stoeier", " stokperdjie", " straatblokke", " strandstoel", 
        "strande", " streepdas", " strikdas", " strooitjie", " stroompies", " stukkend", " verflenter", " Suid-Afrika", " sukkel", " superkampioen", " suurstof", " suurstoftenk", 
        "tabel", " Tafelberg", " tegelyk", " terug", " teruggestap", " tevrede", " toebroodjie", " toegelaat", " toerusting", " toneelspel", " tuinslang", " uitgekom", " uitveer",
        " uitverkoping", " vakansieganger", " vasbeslote", " vangnet", " veiligheid", " vensters", " verdeling", " vergeet", " verkeerd", " verkeerskonstabel", " verkeerslig", 
        "verlede", " vermenigvuldiging", " vermiste", " veroorsaak", " verrassing", " verrot", " versigtig", " verskeie", " verskillend", " versper", " vinne", " vinniger", 
        "vleisagtig", " vlooi", " voeltjie", " volgende", " volgens", " volgorde", " volstruis", " volmaan", " vreesloos", " vriendelik", " vrugtedrank", " Vrystaat", 
        "vuilgoeddrom", " waarheid", " waarskynlikheid", " waarvan", " wakker", " waterpokkies", " weduwee", " weersomstandighede", " weesolifantjies", " weggeraak", " wenkbroue",
        " wentel", " wereld", " Wes-Kaap", " Woensdag", " woninkie", " woonstelle", " wurmpies" }
function g3.getWord(i)
	return words[i]
end
function g3.maxlength()
	local maximum = 0
	local maxWord =""
	local l
	for i=1,#words-1 do
		l =string.len(words[i])
		if(l>maximum)then
			maximum = l
			maxWord = words[i]
		end
	end
	
	return maxWord
end
return g3