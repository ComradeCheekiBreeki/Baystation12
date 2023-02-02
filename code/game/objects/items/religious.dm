// Procession cross
// Carried during religious stuff
/obj/item/cross_procession
	name = "processional cross"
	desc = "A processional cross."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "cross_procession"
	var/icon_state_base = "cross_procession"
	var/icon_state_deployed = "cross_procession_D"
	abstract_type = /obj/item/cross_procession
	randpixel = 0
	// It's giant and probably hurts a shit ton
	force = 8
	throwforce = 2
	w_class = ITEM_SIZE_HUGE

/obj/item/cross_procession/dropped(mob/user as mob)
	if(isturf(loc))
		icon_state = icon_state_deployed
	else
		icon_state = icon_state_base
	update_held_icon()
	..()

/obj/item/cross_procession/pickup(mob/user)
	icon_state = icon_state_base
	update_held_icon()
	..()

/obj/item/cross_procession/moved(mob/user as mob, old_loc as turf)
	icon_state = icon_state_base
	update_held_icon()
	..()

/*
/obj/item/cross_procession/on_update_icon()
	..()
	// If the item's on a turf, change the icon
	if(istype(src.loc, /turf))
		icon_state = icon_state_deployed
	else
		icon_state = icon_state_base
*/

// Procession cross types
/obj/item/cross_procession/eastern
	name = "eastern processional cross"
	desc = "An Eastern Christian style processional cross. Probably not even real gold."
	icon_state = "cross_procession_eastern"
	icon_state_base = "cross_procession_eastern"
	icon_state_deployed = "cross_procession_eastern_D"

// Prayer rug
/obj/item/prayer_rug
	name = "prayer rug"
	desc = "A prayer rug."
	icon = 'icons/obj/prayer_rug.dmi'
	icon_state = "prayer_rug"
	var/icon_state_base = "prayer_rug"
	var/icon_state_deployed = "prayer_rug_D"
	abstract_type = /obj/item/prayer_rug
	randpixel = 0
	force = 3
	throwforce = 3
	w_class = ITEM_SIZE_LARGE
	var/deployed = FALSE

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
