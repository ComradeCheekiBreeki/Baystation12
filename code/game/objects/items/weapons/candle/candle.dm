/obj/item/flame/candle
	name = "candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"

	var/available_colours = list(COLOR_WHITE, COLOR_DARK_GRAY, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)
	var/wax
	var/initial_wax
	var/burn_time = list(27 MINUTES, 33 MINUTES) // Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.
	var/last_lit
	var/icon_set = "candle"
	var/candle_max_bright = 0.3
	var/candle_inner_range = 0.1
	var/candle_outer_range = 4
	var/candle_falloff = 2

/obj/item/flame/candle/Initialize()
	wax = rand(burn_time[1], burn_time[2]) / SSobj.wait
	initial_wax = wax
	if(available_colours)
		color = pick(available_colours)
	. = ..()

/obj/item/flame/candle/on_update_icon()
	switch(wax)
		if((initial_wax * (2/3)) to INFINITY)
			icon_state = "[icon_set]1"
		if((initial_wax * (1/3)) to (initial_wax * (2/3)))
			icon_state = "[icon_set]2"
		else
			icon_state = "[icon_set]3"

	if(lit != last_lit)
		last_lit = lit
		overlays.Cut()
		if(lit)
			overlays += overlay_image(icon, "[icon_state]_lit", flags=RESET_COLOR)

/obj/item/flame/candle/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(isflamesource(W) || is_hot(W))
		light(user, FALSE)

/obj/item/flame/candle/resolve_attackby(atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/item/flame/candle) && is_hot(src))
		var/obj/item/flame/candle/other_candle = A
		other_candle.light()

/obj/item/flame/candle/proc/light(mob/user, var/silent = FALSE)
	if(!lit)
		lit = 1
		set_light(candle_max_bright, candle_inner_range, candle_outer_range, candle_falloff)
		START_PROCESSING(SSobj, src)

		if(silent)
			src.visible_message(SPAN_NOTICE("\The [src] ignites."))

		else
			user.visible_message(
				SPAN_NOTICE("\The [user] lights \the [src]."),
				SPAN_NOTICE("You light \the [src].")
			)


/obj/item/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		var/obj/item/trash/candle/C = new(loc)
		C.color = color
		qdel(src)
		return
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
		remove_extension(src, /datum/extension/scent)

/obj/item/storage/candle_box
	name = "candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox"
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7
	slot_flags = SLOT_BELT

	startswith = list(/obj/item/flame/candle = 7)

// Liturgical candle
/obj/item/flame/candle/tall
	name = "tall candle"
	desc = "A tall pillar candle that burns for an extended period of time."
	icon_state = "tallcandle1"
	item_state = "tallcandle1"
	w_class = ITEM_SIZE_SMALL
	light_color = "#e09d37"
	burn_time = list(65 MINUTES, 70 MINUTES)

	available_colours = list(COLOR_WHITE)
	icon_set = "tallcandle"

/obj/item/storage/candle_box/tall
	name = "liturgical candle pack"
	desc = "A pack of tall liturgical candles."
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 14

	startswith = list(/obj/item/flame/candle/tall = 7)

/obj/item/flame/candle/votive
	name = "votive candle"
	desc = "A short, round votive candle."
	icon_state = "candle_votive1"
	item_state = "candle_votive1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"
	burn_time = list(25 MINUTES, 35 MINUTES)

	available_colours = list(COLOR_WHITE, COLOR_SOL, COLOR_BRASS, COLOR_GREEN_GRAY, COLOR_PALE_RED_GRAY, COLOR_CHESTNUT)
	icon_set = "candle_votive"

/obj/item/storage/candle_box/votive
	name = "votive candle pack"
	desc = "A box of votive candles."
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 12

	startswith = list(/obj/item/flame/candle/votive = 12)
