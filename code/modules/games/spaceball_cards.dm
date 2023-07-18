//Keeping the name "spaceball" for now
/obj/item/pack/spaceball
	name = "\improper spaceball card pack"
	desc = "Officially licensed by the Interplanetary Baseball League to take your money."
	var/list/teams = list(
		//Some of these are locations in lore, some I just made up. Some are inspired by actual baseball teams
		"Olympus Black J's",
		"New Hamburg Gunners",
		"Hamilton White J's",
		"Selene Trojans",
		"Miyoshi Jets",
		"Morgantown Rakers",
		"Neustaat Woodsmen",
		"Siverek Aristocrats",
		"Pikeville Boxers",
		"Marion Prospectors",
		"Verlize Raiders",
		"Saloniki Crosses",
		"Erdeigz Magicians",
		"Helnburg Astros",
		"New Madrid Lances",
		"New Venice Aces",
		"Surya Champions",
		"Nottingham Starmen"
	)
	var/list/positions = list(
		"left-fielder",
		"center-fielder",
		"right-fielder",
		"first baseman",
		"second baseman",
		"third baseman",
		"shortstop",
		"second infielder",
		"anchor",
		"catcher",
		"pitcher",
		"relief pitcher"
	)
	//For rare cards
	var/list/positions_special = list(
		"outfield slugger",
		"infield slugger",
		"shortstop slugger",
		"menace hitter",
		"power hitter",
		"multi-position hitter",
		"technical infielder",
		"defensive baseman",
		"specialist catcher",
		"starting pitcher",
		"closing pitcher",
		"specialist pitcher",
		"left-handed pitcher"
	)
	var/list/ad_cards = list(
		/datum/playingcard/adcard/ibl,
		/datum/playingcard/adcard/sportsbetting,
		/datum/playingcard/adcard/nanotrasen,
		/datum/playingcard/adcard/saare,
		/datum/playingcard/adcard/cigarettes
	)
	icon_state = "card_pack_spaceball"

/obj/item/pack/spaceball/SetupCards()
	var/datum/playingcard/P

	var/pName
	var/pYear
	var/pTeam
	var/language_type = pick(/datum/language/human)
	var/datum/language/L = new language_type()

	var/i
	var/cards_in_pack = rand(3, 8)

	for(i = 0; i < cards_in_pack; i++)
		P = new()

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

	if(prob(35))
		var/ad_path = pick(ad_cards)
		cards += new ad_path

/*
	Advertisement cards
*/
/datum/playingcard/adcard/ibl
	name = "\improper IBL advertisement"
	desc = "A card advertising some IBL-sponsored team merchandise, with discounts for subscribers of the \"IBL Insiders\" newsletter."
	card_icon = "card_ad_ibl"
	back_icon = "card_back_ad_ibl"

/datum/playingcard/adcard/sportsbetting
	name = "sports betting advertisement"
	desc = "An ad card for a shady-looking sports betting company. Looks like they got away with not including a gambling warning notice."
	card_icon = "card_ad_sportsbetting"
	back_icon = "card_back_ad_sportsbetting"

/datum/playingcard/adcard/nanotrasen
	name = "\improper NanoTrasen advertisement"
	desc = "An ad card for the ever-present NanoTrasen corporation, featuring an endorsement from a sports commentator."
	card_icon = "card_ad_nanotrasen"
	back_icon = "card_back_ad_nanotrasen"

/datum/playingcard/adcard/saare
	name = "\improper SAARE advertisement"
	desc = "A collectible card featuring a unique SAARE \"special operator\" loadout displayed in a fancy 3D-looking graph. The back has some disturbingly bloodthirsty text encouraging people to join up."
	card_icon = "card_ad_saare"
	back_icon = "card_back_ad_saare"

/datum/playingcard/adcard/cigarettes
	name = "cigarette advertisement"
	desc = "An advertisement for a cheap cigarette brand. There's big text at the top that says, \"NOT FOR INDIVIDUALS UNDER 18,\" and a huge paragraph about cancer."
	card_icon = "card_ad_cigs"
	back_icon = "card_back_ad_cigs"
