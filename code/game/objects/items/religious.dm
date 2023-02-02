
/obj/item/prayer_rug
	name = "prayer rug"
	desc = "A prayer rug."
	icon = 'icons/obj/prayer_rug.dmi'
	icon_state = "prayer_rug"
	var/icon_state_deployed = "prayer_rug_deployed"
	randpixel = 0
	force = 3
	throwforce = 3
	w_class = ITEM_SIZE_LARGE
	var/deployed = FALSE

/obj/item/prayer_rug/attackby()

/obj/item/prayer_rug/AltClick(var/mob/user)
	if(deployed && (user.HasFreeHand()))

/obj/item/prayer_rug/attack_self(mob/user as mob)
	deploy(usr)
	return

/obj/item/prayer_rug/proc/deploy(var/mob/m)
	if(m == loc && istype(m.loc, /turf) && m.unEquip(src, m.loc))
		icon_state = icon_state_deployed
		deployed = TRUE
		add_fingerprint(m)
		m.visible_message(
			SPAN_NOTICE("\The [m] rolls out \the [src]."),
			SPAN_NOTICE("You roll out \the [src].")
		)
	else
		to_chat(m, SPAN_NOTICE("You can't roll out \the [src] here."))
