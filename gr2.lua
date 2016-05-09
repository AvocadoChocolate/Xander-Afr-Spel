local gr2 = {}
local words = {
"aanskou",
"aanwend",
"aarbei",
"afdroog",
"afvee",
"agterop",
"albaster",
"alleen",
"almal",
"ambulans",
"appelboom",
"aspris",
"aster",
"bakkery",
"baklei",
"baksteen",
"bang",
"beeld",
"been",
"bekommer",
"bekruip",
"berg",
"besoek",
"betaal",
"bloedrooi",
"blokkie",
"blombak",
"blomme",
"bloos",
"boomhuis",
"boomstomp",
"braai",
"breek",
"brein",
"breukdeel",
"bring",
"broeksak",
"brood",
"bruggie",
"bruin",
"bult",
"busse",
"bustoer",
"buurman",
"buurvrou",
"dagboek",
"damme",
"diere",
"Donderdag",
"dorp",
"draai",
"drade",
"drank",
"drentel",
"driehoekie",
"dronk",
"droog",
"dwarslat",
"fabriek",
"fietse",
"foeitog",
"fontein",
"gang",
"gasvrou",
"gehelp",
"gehoor",
"gemmerkat",
"gemors",
"geverf",
"gieter",
"glad",
"gleuf",
"glimlag",
"gloeilamp",
"gluur",
"glyplank",
"graaf",
"graan",
"grafiek",
"grasperk",
"groentetuin",
"groep",
"groot",
"handdoek",
"hardloop",
"hemp",
"herfstyd",
"hiervan",
"hoeveel",
"hoeveelheid",
"hospitaal",
"houtvloer",
"huil",
"jag",
"jammer",
"Jeugdag",
"joggie",
"jonkheid",
"juis",
"jukskei",
"julle",
"kalm",
"kameelperd",
"kamer",
"kierie",
"kieriebeen",
"klaswerk",
"kleiner",
"kleurvol",
"kleurwiel",
"klippies",
"klop",
"klou",
"knip",
"koekie",
"sonbril",
"koerant",
"koerier",
"koeverte",
"koppie",
"korrek",
"kraakbeen",
"kraan",
"krabbel",
"kringloop",
"kroos",
"kuiken",
"laaikas",
"lampskerm",
"landbou",
"lank",
"lapsak",
"leesles",
"legkaart",
"lugballon",
"maagpyn",
"maand",
"middagson",
"modder",
"moenie",
"monster",
"motorfiets",
"muis",
"muntstuk",
"muskiet",
"naby",
"nagwag",
"natspuit",
"naweek",
"neerskryf",
"netbalbaan",
"netheid",
"neusbrug",
"neutvars",
"nooit",
"nounet",
"nuus",
"oerwoud",
"omdraai",
"omlyn",
"onderbroek",
"ondersoek",
"oopstoot",
"opklim",
"orrel",
"paddavis",
"papier",
"pasop",
"plak",
"plant",
"pleister",
"plus",
--"poppe",
"positief",
"potlood",
"potlepel",
"praatkous",
"prenteboek",
"prettig",
"pronk",
"raas",
"reis",
"rolspel",
"romp",
"roomtert",
--"rugby",
"rustig",
"sakgeld",
"samelewing",
"sandkasteel",
"sangstuk",
"sappig",
"seemeeu",
"seisoen",
"seunskoor",
"sing",
"sirkelrond",
"skiet",
"skoen",
"skoenlapper",
"skooldrag",
"skoolruit",
"skoolsport",
"skoorsteen",
"skottelgoed",
"skotvry",
"skraap",
"skreeu",
"skrik",
"skuit",
"skyfies",
"slang",
"slap",
"sleep",
"sloot",
"smaaklik",
"smelt",
"sneeuman",
"snoek",
"snoet",
"soetgoed",
"soggens",
"sokker",
"somme",
"Sondagskool",
"sonhoed",
"sonskyn",
"sopnat",
"span",
"spanspek",
"speelgoed",
"spoel",
"spreeu",
"spreukbeurt",
"springtou",
"sproet",
"staanplek",
"stert",
"steurnis",
"stoei",
"stokkie",
"storm",
"straat",
"strandhuis",
"streek",
"streep",
"strikkie",
"strooidak",
"suiker",
"suur",
"swaai",
"swaaiverhoog",
"swart",
"swembad",
"swerm",
"tafeldoek",
"tamatiesop",
"tandeborsel",
"tang",
"telbord",
"totdat",
"trapkar",
"troetelnaampie",
"trompet",
"trourok",
"polonektrui",
"tydsaam",
"uitknip",
"uitstappie",
"vakansie",
"varkstert",
"vensterraam",
"verpleeg",
"versprei",
"vleis",
"vliegvrees",
"vloei",
"voedsel",
"voltooi",
"vreemd",
"vroeg",
"vrou",
"vrugteboom",
"vullis",
"vyftig",
"waarheen",
"waarmee",
"waatlemoen",
"walvisse",
"warmbloedig",
"wasgoed",
"weerkaart",
"weggaan",
"weke",
"welbekend",
"werkloos",
"wiegie",
"wildtuin",
"wolkbreuk",
"wurmpie",
}
function gr2.getWord(i)
	return words[i]
end
function gr2.total()
	return #words
end
function gr2.maxlength()
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
return gr2