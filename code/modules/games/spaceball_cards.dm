//Keeping the name "spaceball" for now, may change it later
/obj/item/pack/spaceball
	name = "\improper spaceball booster pack"
	desc = "Officially licensed by the Intersolar Baseball League to take your money."
	var/list/teams = list(
		//Inner solar teams
		"Olympus Black J's",
		"New Hamburg Gunners",
		"Hamilton White J's",
		"Selene Trojans",
		"Miyoshi Jets",
		"Morgantown Rakers",
		//Outer solar teams
		"Neustaat Woodsmen",
		"Siverek Aristocrats",
		"Pikeville Boxers",
		"Marion Prospectors",
		//Near-solar teams
		"Verlize Raiders",
		"Saloniki Crosses",
		"Erdeigz Magicians",
		"Helnburg Astros",
		//Teams from and near Gaia
		"New Madrid Jokers",
		"New Venice Red Aces",
		"Surya Champions",
		"Nottingham Matchers"
	)
	//Really deep lore in here about how the baseball rules have changed since the 21st century
	var/list/positions = list(
		"left-fielder",
		"center-fielder",
		"right-fielder",
		"short-fielder",
		"first baseman",
		"second baseman",
		"third baseman",
		"shortstop",
		"anchor",
		"catcher",
		"pitcher"
	)
	//For rare cards
	var/list/positions_special = list(
		"left-fielding slugger",
		"center-fielding slugger",
		"right-fielding slugger",
		"rover",
		"defensive baseman",
		"shortstop slugger",
		"hard anchor",
		"defensive catcher",
		"starting pitcher",
		"relief pitcher"
	)
	icon_state = "card_pack_spaceball"

/obj/item/pack/spaceball/SetupCards()
	var/datum/playingcard/P
	var/i

	var/pName
	var/pYear
	var/pTeam
	var/language_type = pick(/datum/language/human)
	var/datum/language/L = new language_type()

	for(i = 0; i < 5; i++)
		P = new()

		//Set up the basic stuff
		if(prob(35))
			pName = L.get_random_name(FEMALE)
		else
			pName = L.get_random_name(MALE)

		pYear = "[GLOB.using_map.game_year - rand(0, 50)]"
		pTeam = "[pick(teams)]"

		if(prob(2))
			P.name = "signed spaceball card ([pName], '[copytext(pYear,-2)] [pTeam])"
			P.desc = "A limited-edition IBL baseball card featuring [pick(positions_special)] and hall-of-famer [pName], playing the [pYear] season for the [pTeam]. This one's got an autograph!"
			P.card_icon = "card_spaceball_signed_[rand(1,4)]"
			P.back_icon = "card_back_spaceball_signed"
		else if(prob(10))
			P.name = "limited edition spaceball card ([pName], '[copytext(pYear,-2)] [pTeam])"
			P.desc = "A limited-edition IBL baseball card featuring [pick(positions_special)][pick(" and hall-of-famer ", " ")][pName], playing the [pYear] season for the [pTeam]."
			P.card_icon = "card_spaceball_lim_[rand(1,4)]"
			P.back_icon = "card_back_spaceball_lim"
		else
			P.name = "spaceball card ([pName], '[copytext(pYear,-2)] [pTeam])"
			P.desc = "An IBL baseball card featuring [pick(positions)] [pName], playing the [pYear] season for the [pTeam]."
			P.card_icon = "card_spaceball_[rand(1,8)]"
			P.back_icon = "card_back_spaceball"

		cards += P
