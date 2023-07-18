
//These are intended to be genericized tarot cards, so you can divine with them or play tarot games
//The "alt" names are the original and *technically* correct names of the cards, the current ones are the modern ones created in the 1900s (after tarot games stopped being popular)
/obj/item/deck/tarot
	name = "tarot deck"
	desc = "A classical-style tarot deck."
	icon_state = "deck_tarot"
	var/list/trumps = list(
		"The Fool",
		"The Juggler (I)", //Alt. "The Magician"
		"The High Priestess (II)", //Alt. "The Popess"
		"The Empress (III)",
		"The Emperor (IV)",
		"The Hierophant (V)", //Alt. "The Pope"
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
		"The Tower (XVI)", //Alt. "The House of God"
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
		"one",
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
		P.name = "\proper [name]"
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

/obj/item/deck/tarot/attack_self(mob/user as mob)
	var/list/newcards = list()
	while(length(cards))
		var/datum/playingcard/P = pick(cards)
		P.name = replacetext(P.name," reversed","")
		if(prob(50))
			P.name += " reversed"
		newcards += P
		cards -= P
	cards = newcards
	user.visible_message("\The [user] shuffles [src].")
