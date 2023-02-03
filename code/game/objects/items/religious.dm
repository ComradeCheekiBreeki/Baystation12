// Procession crosses
// Carried during religious ceremonies
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

// Prayer rug
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
