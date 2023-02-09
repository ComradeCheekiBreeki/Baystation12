
/*****************
Procession crosses
*****************/
/obj/item/cross_procession
	name = "processional cross"
	desc = "A processional cross."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "cross_procession"
	item_state = "cross_procession"
	var/icon_state_base = "cross_procession"
	// Just a small icon change to make it look less goofy when set up on the ground
	var/icon_state_deployed = "cross_procession_D"
	abstract_type = /obj/item/cross_procession
	randpixel = 0
	// Probably would hurt a lot to be hit by
	force = 8
	throwforce = 2
	w_class = ITEM_SIZE_HUGE

/obj/item/cross_procession/dropped(mob/user as mob)
	update_icon()
	..()

/obj/item/cross_procession/pickup(mob/user)
	// We have to force this instead of using update_icon() since the pickup() proc triggers before the item's loc has changed
	icon_state = icon_state_base
	..()

/obj/item/cross_procession/moved(mob/user as mob, old_loc as turf)
	update_icon()
	..()

/obj/item/cross_procession/on_update_icon()
	..()
	// If the item's on a turf, change the icon to its "deployed" state
	if(istype(src.loc, /turf))
		icon_state = icon_state_deployed
	else
		icon_state = icon_state_base

/obj/item/cross_procession/get_mechanics_info()
	. = ..()
	. += "<p>A large cross carried by altar servers during some Christian ceremonies. It can be placed on the ground and moved around to change its direction or carried.</p>"

// Procession cross types
/obj/item/cross_procession/eastern
	name = "eastern processional cross"
	desc = "An Eastern Christian style processional cross. Probably not even real gold."
	icon_state = "cross_procession_eastern"
	item_state = "cross_procession_eastern"
	icon_state_base = "cross_procession_eastern"
	icon_state_deployed = "cross_procession_eastern_D"
	// I'm just going to say it's gold/brass plated steel
	matter = list(MATERIAL_STEEL = 2000)

/obj/item/cross_procession/western
	name = "western processional cross"
	desc = "A Latin rite processional cross in the style of a crucifix, with an image of Jesus Christ."
	icon_state = "cross_procession_western"
	item_state = "cross_procession_western"
	icon_state_base = "cross_procession_western"
	icon_state_deployed = "cross_procession_western_D"
	matter = list(MATERIAL_WOOD = 2000, MATERIAL_BRONZE = 250)

/**********
Prayer rugs
**********/
/obj/item/prayer_rug
	name = "prayer rug"
	desc = "A prayer rug."
	icon = 'icons/obj/prayer_rug.dmi'
	icon_state = "prayer_rug"
	var/icon_state_base = "prayer_rug"
	var/icon_state_deployed = "prayer_rug_D"
	abstract_type = /obj/item/prayer_rug
	randpixel = 2
	force = 3
	throwforce = 3
	w_class = ITEM_SIZE_LARGE
	var/deployed = FALSE
	matter = list(MATERIAL_CLOTH = 2000)

/obj/item/prayer_rug/attack_hand(mob/user as mob)
	if(deployed && (user.a_intent != I_HURT))
		if(get_dist(src, user) > 0)
			to_chat(user, SPAN_WARNING("You're too far away to interact with \the [src]."))

		else
			user.visible_message(
				SPAN_NOTICE("\The [user] prostrates themselves on \the [src]."),
				SPAN_NOTICE("You prostrate yourself on \the [src].")
			)

	else if(!deployed)
		..()

/obj/item/prayer_rug/AltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_WARNING("You can't roll \the [src] right now."))
		return

	if(!user.HasFreeHand())
		to_chat(user, SPAN_WARNING("You need a free hand to roll \the [src]."))
		return

	if(!deployed)
		// If it's in the player's inventory just roll it out on the ground
		if(user == loc)
			deploy(user, TRUE)
		else
			deploy(user, FALSE)

	else
		undeploy(user)

/obj/item/prayer_rug/attack_self(mob/user as mob)
	deploy(user, TRUE)
	return

/obj/item/prayer_rug/proc/deploy(mob/user, var/inInventory)
	if(inInventory && !user.canUnEquip(src))
		to_chat(user, SPAN_WARNING("You can't roll out \the [src] here."))
		return

	else if(!isturf(loc) && !inInventory)
		to_chat(user, SPAN_WARNING("You can't roll out \the [src] here."))
		return

	else
		if(inInventory)
			user.unEquip(src, user.loc)

		icon_state = icon_state_deployed
		deployed = TRUE
		add_fingerprint(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] rolls out \the [src]."),
			SPAN_NOTICE("You roll out \the [src].")
		)

/obj/item/prayer_rug/proc/undeploy(var/mob/m)
	if(!(istype(src.loc, /turf)))
		to_chat(m, SPAN_WARNING("You can't roll up \the [src] here."))
		return

	else
		icon_state = icon_state_base
		deployed = FALSE
		add_fingerprint(m)
		m.visible_message(
			SPAN_NOTICE("\The [m] rolls up \the [src]."),
			SPAN_NOTICE("You roll up \the [src].")
		)

/obj/item/prayer_rug/get_mechanics_info()
	. = ..()
	. += "<p>A rug that can be rolled out on the ground for prayer.</p>"

/obj/item/prayer_rug/get_interactions_info()
	. = ..()
	.["Empty Hand (While rolled out)"] += "Allows you to prostrate yourself on the rug."
	.[CODEX_INTERACTION_USE_SELF] += "Places the rug down and rolls it out if it's possible to do so. You need a free hand to do this."
	.[CODEX_INTERACTION_ALT_CLICK] += "Rolls the rug out on the ground or rolls it back up. If it's in your inventory, it'll get placed on the ground first. You need a free hand to do this."

// Prayer rug types
/obj/item/prayer_rug/ornate
	name = "ornate prayer rug"
	desc = "An ornate prayer rug, decorated with geometric and floral symbols."
	icon_state = "prayer_rug_ornate"
	icon_state_base = "prayer_rug_ornate"
	icon_state_deployed = "prayer_rug_ornate_D"

// "ottoman" in the sense of a descriptor, not a reference to the specific empire/nation
/obj/item/prayer_rug/ottoman
	name = "ottoman prayer rug"
	desc = "An antique ottoman-style prayer rug woven in intricate patterns with naturally-dyed cloth."
	icon_state = "prayer_rug_ottoman"
	icon_state_base = "prayer_rug_ottoman"
	icon_state_deployed = "prayer_rug_ottoman_D"

/obj/item/prayer_rug/rustic
	name = "rustic prayer rug"
	desc = "A coarse and thickly-woven prayer rug. Handmade, and of very simple design."
	icon_state = "prayer_rug_rustic"
	icon_state_base = "prayer_rug_rustic"
	icon_state_deployed = "prayer_rug_rustic_D"

/*********
Candleabra
*********/
/obj/item/storage/candelabrum
	name = "candlestick"
	desc = "A simple iron candlestick. Pre-aged, for that 1500s look."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candelabrum"
	var/base_icon = "candelabrum"
	force = 6
	// We want the user to be able to place it specifically
	randpixel = 0
	throwforce = 6
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/flame/candle, /obj/item/flame/candle/tall)
	storage_slots = 1
	allow_slow_dump = FALSE
	center_of_mass = "x=16;y=6"
	// Whether or not to put the overlays as underlays so they display below the object (used for transparent containers)
	var/underlay = FALSE

/obj/item/storage/candelabrum/on_update_icon()
	..()
	// Kind of dirty, but it works
	overlays.Cut()
	underlays.Cut()
	if(contents.len)
		var/i = 1
		for(var/obj/item/flame/candle/cand in contents)
			if(istype(cand))
				// I'm sure this could be done much more intelligently but I'm too lazy to figure it out
				var/image/image = image(icon,"[base_icon]_[i]")
				image.color = cand.color
				if(underlay)
					underlays += image
				else
					overlays += image

				if(cand.lit)
					if(underlay)
						underlays += "[base_icon]_[i]_lit"
					else
						overlays += "[base_icon]_[i]_lit"

			i++

/obj/item/storage/candelabrum/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = ..()
	if(contents.len)
		for(var/obj/item/flame/candle/cand in contents)
			if(remove_from_storage(cand, src.loc))
				cand.throw_at(CircularRandomTurfAround(target, Frand(1, 3)), Frand(1,get_dist(src.loc, target)), Frand(3,10))

		visible_message(SPAN_WARNING("The candles in \the [src] go flying everywhere!"))

/obj/item/storage/candelabrum/attackby(obj/item/W as obj, mob/user as mob)
	if((isflamesource(W) || is_hot(W)))
		if(contents.len)
			var/unlightable = 0
			for(var/obj/item/flame/candle/cand in contents)
				if(!cand.lit)
					cand.light(user, FALSE)
					update_icon()
					break
				else
					unlightable++

			// If all candles are unlightable
			if(unlightable == contents.len)
				if((W.type in can_hold) && contents.len < storage_slots)
					..()
				else
					to_chat(user, SPAN_WARNING("The candles in \the [src] are already lit."))

		else if(W.type in can_hold)
			..()
		else
			to_chat(user, SPAN_WARNING("There are no candles in \the [src]."))
	else
		..()

/obj/item/storage/candelabrum/attack_self(mob/user as mob)
	var/ext = 0
	for(var/obj/item/flame/candle/cand in contents)
		if(cand.lit)
			cand.lit = 0
			cand.set_light(0)
			remove_extension(cand, /datum/extension/scent)
			cand.update_icon()
			ext++

	if(ext > 0)
		user.visible_message(
			SPAN_NOTICE("\The [user] extinguishes all the candles in \the [src]."),
			SPAN_NOTICE("You extinguish all the candles in \the [src].")
		)
	update_icon()

/obj/item/storage/candelabrum/get_mechanics_info()
	. = ..()
	. += "<p>An object that lets you place candles in it for easier organization, cleaner lighting, or just to look nice. \n This one can hold [storage_slots] candle(s).</p>"

/obj/item/storage/candelabrum/get_interactions_info()
	. = ..()
	.["Fire Source"] += "Lights the unlit candles one by one. Another lit candle can be used for this purpose, but only if there are no empty slots; otherwise the candle will be placed in it."
	.[CODEX_INTERACTION_USE_SELF] += "Extinguishes all of the lit candles."

/obj/item/storage/candelabrum/altar_candlestick
	name = "altar candlestick"
	desc = "A tall golden candlestick that looks great on an altar."
	icon_state = "altar_candlestick"
	base_icon = "altar_candlestick"
	can_hold = list(/obj/item/flame/candle, /obj/item/flame/candle/tall)
	storage_slots = 1
	center_of_mass = "x=16;y=3"

/obj/item/storage/candelabrum/menorah_temple
	name = "temple menorah"
	desc = "A golden seven-armed candelabrum, a symbol of Jewish synagogues, modeled after the original in the Temple of Jerusalem. <i>Not</i> to be confused with the nine-armed Hanukkah menorah."
	icon_state = "menorah"
	base_icon = "menorah"
	can_hold = list(/obj/item/flame/candle, /obj/item/flame/candle/tall)
	storage_slots = 7
	center_of_mass = "x=16;y=3"

/obj/item/storage/candelabrum/votive_glass
	name = "glass votive"
	desc = "A small glass votive container for holding candles."
	icon_state = "votive_glass"
	base_icon = "votive_glass"
	randpixel = 3
	can_hold = list(/obj/item/flame/candle/votive)
	storage_slots = 1
	center_of_mass = "x=16;y=12"
	matter = list(MATERIAL_GLASS = 150)
	underlay = TRUE
	var/available_colors = list(COLOR_WHITE, COLOR_RED_GRAY, COLOR_GREEN_GRAY, COLOR_PALE_BLUE_GRAY, COLOR_BOTTLE_GREEN, COLOR_COMMAND_BLUE, COLOR_ASTEROID_ROCK)

/obj/item/storage/candelabrum/votive_glass/Initialize()
	color = pick(available_colors)
	. = ..()

/*****
Censer
*****/
/obj/item/storage/censer
	name = "censer"
	desc = "A brass censer for dispersing incese or other aromatic things, usually during a religious service. If you're crazy enough, you could also use it like a flail."
	icon = 'icons/obj/items.dmi'
	icon_state = "censer"
	item_state = "censer"
	force = 5
	throwforce = 4
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/flame/candle/scented/incense, /obj/item/flame/candle/scented/incense/religious)
	storage_slots = 1
	var/lit = FALSE
	// The censer can only be swung when it's held in two hands
	var/wielded_item_state = "censer-wielded"
	var/last_swing = 0
	var/cooldown = 2 SECONDS
	allow_slow_dump = FALSE
	center_of_mass = "x=17;y=4"

/obj/item/storage/censer/update_twohanding()
	update_icon()
	..()

// Pilfered this from somewhere, don't remember where
/obj/item/storage/censer/update_icon()
	var/mob/living/user = loc
	if(istype(user))
		if(is_held_twohanded(user))
			item_state_slots[slot_l_hand_str] = wielded_item_state
			item_state_slots[slot_r_hand_str] = wielded_item_state
		else
			item_state_slots[slot_l_hand_str] = initial(item_state)
			item_state_slots[slot_r_hand_str] = initial(item_state)

/obj/item/storage/censer/attackby(obj/item/W as obj, mob/user as mob)

	if((isflamesource(W) || is_hot(W)))
		if(!lit)
			if(!contents.len && (W.type in can_hold))
				..()

			else
				lit = TRUE
				user.visible_message(
						SPAN_NOTICE("\The [user] opens the front slot and ignites \the [src]."),
						SPAN_NOTICE("You open the front slot and ignite \the [src].")
					)
				for(var/obj/item/flame/candle/scented/incense/inc in contents)
					if(!inc.lit)
						inc.light(user, TRUE)

		else if(W.type in can_hold)
			..()
		else
			to_chat(user, SPAN_WARNING("\The [src] is already lit."))
	else
		..()

	if(contents.len && lit)
		for(var/obj/item/flame/candle/scented/incense/inc in contents)
			if(!inc.lit)
				inc.light(user, TRUE)

/obj/item/storage/censer/AltClick(mob/user as mob)
	if(lit)
		lit = FALSE
		if(contents.len)
			for(var/obj/item/flame/candle/scented/incense/inc in contents)
				if(inc.lit)
					inc.lit = 0
					inc.update_icon()
					inc.set_light(0)
					remove_extension(inc, /datum/extension/scent)
		user.visible_message(
			SPAN_NOTICE("\The [user] closes the slot over the chamber, extinguishing \the [src]."),
			SPAN_NOTICE("You close the slot over the chamber, extinguishing \the [src].")
		)
	else
		to_chat(user, SPAN_WARNING("\The [src] isn't lit."))

/obj/item/storage/censer/attack_self(mob/user as mob)
	if(!(last_swing < world.time) && last_swing != 0)
		return
	else
		last_swing = world.time + cooldown

	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_WARNING("You can't swing \the [src] right now."))
		return

	if(!is_held_twohanded(user))
		to_chat(user, SPAN_WARNING("You need to hold \the [src] in both hands to swing it!"))
		return

	if(contents.len)
		if(lit)
			user.visible_message(
				SPAN_NOTICE("\The [user] swings the \the [src] left and right, dispersing the incense."),
				SPAN_NOTICE("You swing \the [src] left and right, dispersing the incense.")
			)
			var/datum/effect/effect/system/smoke_spread/small/smoke = new /datum/effect/effect/system/smoke_spread/small()
			smoke.set_up(3, 0, user.loc)
			smoke.start()

		else
			user.visible_message(
				SPAN_NOTICE("\The [user] swings \the unlit [src] left and right."),
				SPAN_NOTICE("You swing \the unlit [src] left and right.")
			)

	else if(lit)
		user.visible_message(
			SPAN_NOTICE("\The [user] swings the \the [src] left and right."),
			SPAN_NOTICE("You swing \the [src] left and right, but smell only smoldering charcoal.")
		)

	else
		user.visible_message(
			SPAN_NOTICE("\The [user] swings the \the [src] left and right."),
			SPAN_NOTICE("You swing \the [src] left and right.")
		)

/obj/item/storage/censer/get_mechanics_info()
	. = ..()
	. += "<p>A little perforated metal chamber suspended from a chain used to disperse incense. Incense can be placed in it and lit to fill the room with a pleasant (or possibly revolting) smell.</p>"

/obj/item/storage/censer/get_interactions_info()
	. = ..()
	.["Fire Source"] += "Lights the combustion base in the censer. Any unlit incense inside will be ignited along with it. Another lit incense cone can be used for this purpose, but only if the censer is not empty; otherwise it will be placed inside."
	.[CODEX_INTERACTION_USE_SELF] += "Swings the censer left and right. Disperses incense smoke throughout the room if it's lit and filled. Requires the item to be wielded two-handed."
	.[CODEX_INTERACTION_ALT_CLICK] += "Closes a slot over the chamber to put out the fire. Extinguishes the censer and any incense inside it."
