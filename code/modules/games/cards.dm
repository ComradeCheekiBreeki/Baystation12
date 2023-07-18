/*
	Playing card datum
*/
/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"
	var/desc = "A regular old playing card."

/datum/playingcard/proc/card_image(concealed, deck_icon)
	return image(deck_icon, concealed ? back_icon : card_icon)

/datum/playingcard/custom
	var/use_custom_front = TRUE
	var/use_custom_back = TRUE

/datum/playingcard/custom/card_image(concealed, deck_icon)
	if(concealed)
		return image((src.use_custom_back ? CUSTOM_ITEM_OBJ : deck_icon), "[back_icon]")
	else
		return image((src.use_custom_front ? CUSTOM_ITEM_OBJ : deck_icon), "[card_icon]")

/*
	Decks of cards
*/
/obj/item/deck
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()
	abstract_type = /obj/item/deck

/obj/item/deck/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(islist(citem.additional_data["extra_cards"]))
		for(var/card_singleton in citem.additional_data["extra_cards"])
			if(islist(card_singleton))
				var/datum/playingcard/custom/P = new()
				if(!isnull(card_singleton["name"]))
					P.name = card_singleton["name"]
				if(!isnull(card_singleton["card_icon"]))
					P.card_icon = card_singleton["card_icon"]
				if(!isnull(card_singleton["back_icon"]))
					P.back_icon = card_singleton["back_icon"]
				if(!isnull(card_singleton["desc"]))
					P.desc = card_singleton["desc"]
				if(!isnull(card_singleton["use_custom_front"]))
					P.use_custom_front = card_singleton["use_custom_front"]
				if(!isnull(card_singleton["use_custom_back"]))
					P.use_custom_back = card_singleton["use_custom_back"]
				cards += P

/obj/item/deck/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("There are [cards.len ? cards.len : "no"] cards left in the deck."))

/obj/item/deck/attack_self(mob/user)

	cards = shuffle(cards)
	user.visible_message("\The [user] shuffles [src].")

/*

	Not a fan of this

/obj/item/deck/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!cards.len)
		to_chat(usr, SPAN_WARNING("There are no cards left in \the [src]."))
		return

	deal_at(usr, over)

*/

/obj/item/deck/attackby(obj/O, mob/user)

	if(istype(O,/obj/item/hand))
		//Make sure the user is holding the item if it's in their inventory, so it can't get stuck in their pockets
		if(O.loc == user && !user.IsHolding(O))
			return

		var/obj/item/hand/H = O
		var/response = input("What do you want to do?") in list("Draw card into hand", "Return hand to deck")
		if(response == "Draw card into hand")
			draw_from_deck(user)
		else if(response == "Return hand to deck")
			for(var/datum/playingcard/P in H.cards)
				cards += P
			qdel(O)
			user.visible_message(
				SPAN_NOTICE("\The [user] places \his cards onto the bottom of \the [src]."),
				SPAN_NOTICE("You place your cards onto the bottom of \the [src].")
			)
		return
	..()

/obj/item/deck/attack_hand(mob/user)
	if(src.loc == user)
		if(!istype(user,/mob/living/carbon))
			return

		// See before - prevents deck from getting stuck in players' pockets
		if(user.IsHolding(src))
			draw_from_deck(user)
		else
			..()
	else
		..()

/*
/obj/item/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from the deck."
	set src in view(1)

	if(!istype(usr,/mob/living/carbon))
		return

	var/mob/living/carbon/user = usr
	draw_from_deck(user)
*/

//Handles the actual drawing from the deck part
/obj/item/deck/proc/draw_from_deck(mob/user)
	if(user.stat || !Adjacent(user))
		return

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("\The src is empty."))
		return

	var/obj/item/hand/H = user.IsHolding(/obj/item/hand)
	if (!H)
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user)
		return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.concealed = 1
	H.update_icon()
	user.visible_message(
		SPAN_NOTICE("\The [user] draws a card."),
		SPAN_NOTICE("You draw a card.")
	)
	to_chat(user, "It's \the [P].")


/obj/item/deck/verb/deal_card()

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from the deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!length(cards))
		to_chat(usr, SPAN_WARNING("\The src is empty."))
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player

	var/mob/living/M = input("Whom do you want to deal to?") as null|anything in players
	if(!usr || !src || !M)
		return
	var/numcards = input("How many cards do you want to deal?") as num
	if(numcards < 1)
		return
	if(numcards > cards.len)
		to_chat(usr, SPAN_NOTICE("There are not enough cards to deal that many."))
		return

	deal_at(usr, M, numcards)

/obj/item/deck/proc/deal_at(mob/user, mob/target, numcards)
	var/i

	if()
	var/obj/item/hand/H = new(get_step(user, user.dir))

	for(i = 1, i <= numcards, i++)
		// A bit cringe, but because we're removing cards from the deck we can just access the top card each time since it'll always be different
		H.cards += cards[1]
		cards -= cards[1]
		H.concealed = 1
		H.update_icon()

	//Seems redundant but without this the hand would get stuck in walls/windows/whatever the user is standing in front of if they deal to themselves
	if(target == user)
		H.dropInto(user.loc)
	else
		H.throw_at(get_step(target,target.dir),10,1,user)

	var/message = numcards == 1 ? "a card" : "[numcards] cards"
	if(user == target)
		user.visible_message(
				"\The [user] deals [message] to \himself.",
				"You deal [message] to yourself."
			)
	else
		user.visible_message(
				"\The [user] deals [message] to \the [target].",
				"You deal [message] to \the [target].",
			)

/*
	Deck types
*/
//Standard playing cards
/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of French-suited playing cards. This one includes jokers."
	icon_state = "deck"
	var/list/suits = list(
		"hearts_red",
		"diamonds_red",
		"clubs_black",
		"spades_black"
	)
	var/list/pips = list(
		"ace",
		"two",
		"three",
		"four",
		"five",
		"six",
		"seven",
		"eight",
		"nine",
		"ten"
	)
	var/list/faces = list(
		"jack",
		"king",
		"queen"
	)

/obj/item/deck/cards/New()
	..()

	var/datum/playingcard/P

	for(var/s in suits)

		var/suitlist = splittext(s,"_")

		var/suit = suitlist[1]
		var/colour = suitlist[2]

		for(var/number in pips)
			P = new()
			P.name = "\improper [number] of [suit]"
			P.card_icon = "card_[colour]_pip"
			P.back_icon = "card_back"
			cards += P

		for(var/number in faces)
			P = new()
			P.name = "\improper [number] of [suit]"
			P.card_icon = "card_[colour]_face"
			P.back_icon = "card_back"
			cards += P

	for(var/i = 0, i < 2 , i++)
		P = new()
		P.name = "\improper joker"
		P.card_icon = "joker"
		cards += P

//Deck box
/obj/item/deck/holder
	name = "deck box"
	desc = "A small leather deck box for cards, to show just how classy you are."
	icon_state = "card_holder"

/obj/item/deck/holder/verb/dump_out_box()

	set category = "Object"
	set name = "Dump Out"
	set desc = "Dump out the deck box."
	set src in view(1)

	if(!istype(usr,/mob/living/carbon))
		return

	var/mob/living/carbon/user = usr

	if(!cards.len)
		to_chat(user, SPAN_WARNING("There aren't any cards left in \the [src]."))
		return

	var/obj/item/hand/new_hand = new(user.loc)
	new_hand.concealed = FALSE

	for(var/datum/playingcard/P in cards)
		new_hand.cards += P
		cards -= P

	new_hand.update_icon()

	if(user.HasFreeHand())
		user.put_in_hands(new_hand)
	else
		new_hand.dropInto(user.loc)

	user.visible_message(
		SPAN_WARNING("\The [user] dumps out \the [src]."),
		SPAN_WARNING("You dump out \the [src].")
	)

/*
	Card packs
*/
/obj/item/pack
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEM_SIZE_TINY
	var/list/cards = list()
	abstract_type = /obj/item/pack

/obj/item/pack/Initialize()
	. = ..()
	SetupCards()

/obj/item/pack/proc/SetupCards()
	return

/obj/item/pack/attack_self(mob/user)
	user.visible_message(
		SPAN_NOTICE("\The [user] rips open \the [src]."),
		SPAN_NOTICE("You rip open \the [src].")
	)
	var/obj/item/hand/H = new()

	H.cards += cards
	cards.Cut();
	qdel(src)

	H.update_icon()
	user.put_in_active_hand(H)

/*
	Hands of cards
*/
/obj/item/hand
	name = "hand of cards"
	desc = "Some cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY

	var/concealed = 0
	var/list/datum/playingcard/cards = list()

/obj/item/hand/attackby(obj/O, mob/user)
	if(istype(O,/obj/item/hand))
		var/obj/item/hand/H = O
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		qdel(src)
		H.update_icon()
		return
	..()

/obj/item/hand/verb/cut_cards()

	set category = "Object"
	set name = "Cut Hand"
	set desc = "Cut the hand in half."
	set src in view(1)

	if(!istype(usr,/mob/living/carbon))
		return

	var/mob/living/carbon/user = usr

	if(!user.HasFreeHand())
		to_chat(user, SPAN_WARNING("You need a free hand to cut \the [src]."))

	if(!cards.len)
		return

	var/i
	var/numcards = round(cards.len / 2)
	var/obj/item/hand/new_hand = new(user.loc)
	new_hand.concealed = FALSE
	user.put_in_hands(new_hand)

	for(i = 1, i <= numcards, i++)
		var/datum/playingcard/P = cards[i]

		new_hand.cards += P
		cards -= P

	new_hand.update_icon()
	src.update_icon()

	user.visible_message(
		SPAN_NOTICE("\The [user] cuts \the [src]."),
		SPAN_NOTICE("You cut \the [src].")
	)

/obj/item/hand/attack_self(mob/user)
	concealed = !concealed
	update_icon()
	user.visible_message(
		SPAN_NOTICE("\The [user] [concealed ? "conceals" : "reveals"] their hand."),
		SPAN_NOTICE("You [concealed ? "conceal" : "reveal"] your hand.")
	)

/obj/item/hand/attack_hand(mob/user)
	//Make sure the user is holding the cards in their active hand so they don't get stuck in the user's inventory
	if(src.loc == user && user.IsHolding(src))
		// build the list of cards in the hand
		var/list/to_discard = list()
		for(var/datum/playingcard/P in cards)
			to_discard[P.name] = P
		var/discarding = null
		//don't prompt if only 1 card
		if(length(to_discard) == 1)
			discarding = to_discard[1]
		else
			discarding = input(user, "Which card do you wish to take?") as null|anything in to_discard
		if(!discarding || !to_discard[discarding] || !CanPhysicallyInteract(user)) return

		var/datum/playingcard/card = to_discard[discarding]
		var/obj/item/hand/new_hand = new(src.loc)
		new_hand.cards += card
		cards -= card
		new_hand.concealed = 0
		new_hand.update_icon()
		src.update_icon()

		if(!length(cards))
			qdel(src)

		user.put_in_hands(new_hand)
	else
		. = ..()

/obj/item/hand/examine(mob/user)
	. = ..()
	//To avoid cluttering up the chat log with stupidly long details about cards should someone accrue an unreasonably large hand
	if(cards.len >= 20)
		to_chat(user, SPAN_BOLD("There are too many cards for you to count."))

	else if((!concealed || concealed && (src.loc == user)) && cards.len > 1)
		to_chat(user, SPAN_BOLD("It contains: "))
		for(var/datum/playingcard/P in cards)
			to_chat(user, "\The [P.name].")

	else if(concealed && src.loc == user)
		to_chat(user, "It's \the [cards[1].name].")

/obj/item/hand/on_update_icon(direction = 0)
	if(!length(cards))
		qdel(src)
		return
	else if(length(cards) > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else if(concealed)
		name = "single playing card"
		desc = "An unknown playing card, concealed."
	else
		var/datum/playingcard/P = cards[1]
		name = "[P.name]"
		desc = "[P.desc]"

	overlays.Cut()

	if(length(cards) == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = P.card_image(concealed, src.icon)
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		overlays += I
		return

	var/offset = floor(20/length(cards))
	var/matrix/M = matrix()
	M.Update(
		rotation = (direction & EAST|WEST) ? 90 : 0,
		offset_x = (direction == EAST) ? -2 : (direction == WEST) ? 3 : 0,
		offset_y = direction == SOUTH ? 4 : 0
	)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = P.card_image(concealed, src.icon)
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.SetTransform(others = M)
		overlays += I
		i++

/obj/item/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/hand/pickup(mob/user)
	src.update_icon()

// Missing playing card; steals a random card from any random map-placed deck
/obj/item/hand/missing_card
	name = "missing playing card"

/obj/item/hand/missing_card/Initialize()
	. = ..()
	var/list/deck_list = list()
	for(var/obj/item/deck/D in world)
		if(isturf(D.loc))		//Decks hiding in inventories are safe. Respect the sanctity of loadout items.
			deck_list += D

	if(length(deck_list))
		var/obj/item/deck/the_deck = pick(deck_list)
		var/datum/playingcard/the_card = length(the_deck.cards) ? pick(the_deck.cards) : null

		if(the_card)
			cards += the_card
			the_deck.cards -= the_card
			concealed = pick(0,1)	//Maybe up, maybe down.
	update_icon()	//Automatically qdels if no card can be found.
