
//This is specifically based off the Tarot of Marseille as it can be used for both playing and diviniation
//Modern styles are usually intended for one specific purpose, either diviniation (as is the case with the Rider-Waite tarot deck) or playing (the Tarot Nouveau)
/obj/item/deck/tarot
	name = "tarot deck"
	desc = "A tarot deck in the classical style of the Tarot of Marseille. You could use it for cartomancy, or play a game with it (if you even know any)."
	icon_state = "deck_tarot"
	var/list/trumps = list(
		"The Fool",
		"The Magician (I)",
		"The Popess (II)", //Both the Popess and Pope are commonly replaced with the High Priestess and the Hierophant to avoid being too associated with Christianity
		"The Empress (III)",
		"The Emperor (IV)",
		"The Pope (V)",
		"The Lover (VI)",
		"The Chariot (VII)",
		"Justice (VIII)",
		"The Hermit (VIIII)",
		"The Wheel of Fortune (X)",
		"Strength (XI)",
		"The Hanged Man (XII)",
		"Death (XIII)",
		"Temperance (XIIII)",
		"The Devil (XV)",
		"The Tower (XVI)", //Techincally "The House of God" but the Tower is a common replacement
		"The Star (XVII)",
		"The Moon (XVIII)",
		"The Sun (XVIIII)",
		"Judgement (XX)",
		"The World (XXI)"
	)
	var/list/suits = list(
		"coins",
		"cups",
		"swords",
		"clubs"
	)
	var/list/pips = list(
		"one", //Yes they are actually called "one" and not "ace"
		"two",
		"three",
		"four",
		"five",
		"six",
		"seven",
		"eight",
		"nine",
		"ten",
		"page",
		"knight",
		"queen",
		"king"
	)

/obj/item/deck/tarot/New()
	..()

	var/datum/playingcard/P

	for(var/name in trumps)
		P = new()
		P.name = "[name]"
		P.card_icon = "tarot_trump"
		P.back_icon = "card_back_tarot"
		P.desc = "A tarot trump/major arcana card."
		cards += P

	for(var/suit in suits)
		for(var/number in pips)
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "tarot_[suit]"
			P.back_icon = "card_back_tarot"
			P.desc = "A tarot pip/minor arcana card."
			cards += P
