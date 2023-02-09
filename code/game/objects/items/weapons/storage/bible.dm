/obj/item/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	icon = 'icons/obj/bibles.dmi'
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4
	// Pretty dirty band-aid fix, at some point these items just shouldn't be storage items anymore
	virtual = TRUE
	// For displaying different flavor text
	var/list/familiar_religions = list(RELIGION_CHRISTIANITY)
	// As far as I can tell, this is not used anywhere
	// var/mob/affecting = null
	var/deity_name = "Christ"
	// var/renamed = 0
	// var/icon_changed = 0
	// see below for why these are commented out

/obj/item/storage/bible/get_mechanics_info()
	. = ..()
	. += "<p>A religious text that can be read from and used to bless objects.</p>"

/obj/item/storage/bible/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_USE_SELF] += "Begins reading from \the [src]. Switching hands or moving will cancel this action."
	.["Other Player"] += "Allows you to place \the [src] on their forehead and recite a prayer. Switching hands or moving will cancel this action."
	.["Container of Water"] += "Blesses the water inside and turns it into holy water."

// For an away site/maint meme or something
/obj/item/storage/bible/booze
	name = "\improper Bible"
	desc = "The central religiou- wait, this one seems to have a cut-out in the center..."
	icon_state ="bible"
	virtual = FALSE

	startswith = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/spacecash/bundle/c50,
		/obj/item/spacecash/bundle/c50,
		)

/obj/item/storage/bible/bible
	name = "\improper Bible"
	desc = "The central religious text of Christianity. It contains the writings of the Israelites and the chronicle of Jesus and his disciples."
	icon_state ="bible"
	// Baha'i Faith being on all of these is supposed to reflect that it's a syncretic religion that preaches the inherent value of all relgions
	familiar_religions = list(RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/tanakh
	name = "\improper Tanakh"
	desc = "The central religious text of Judaism. It contains the Law of Moses, the Israelite prophets and the writings of the Israelites."
	icon_state = "tanakh"
	familiar_religions = list(RELIGION_JUDAISM, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/quran
	name = "\improper Qur'an"
	desc = "The central religious text of Islam. It containins the divine revelation of the Prophet Muhammad."
	icon_state = "quran"
	familiar_religions = list(RELIGION_ISLAM, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/quran_hadith
	name = "\improper Qur'an and Hadith"
	desc = "The central religious text of Islam. It containins the divine revelation of the Prophet Muhammad. This version also contains the Hadith, what some Muslims believe to be the writings and experiences of the Prophet Muhammad."
	icon_state = "quran"
	familiar_religions = list(RELIGION_ISLAM, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/aqdas
	name = "\improper Kitab-i-Aqdas"
	desc = "Also called \"The Most Holy Book,\" the Kitab-i-Aqdas is the central religious text of the Baha'i Faith. It contains the religious principles and philosophy of its founder, Baha'u'llah."
	icon_state = "aqdas"
	familiar_religions = list(RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/guru
	name = "\improper Guru Granth Sahib"
	desc = "The central religious text of Sikhism. It is the collection and revision of the writings of the ten human Gurus, considered to be the final \"eternal Guru.\""
	icon_state = "guru"
	familiar_religions = list(RELIGION_SIKHISM, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/kojiki
	name = "\improper Kojiki"
	desc = "A chronicle of ancient Japanese myths and legends. Many of its aspects are part of the Japanese Shinto religion."
	icon_state = "kojiki"
	familiar_religions = list(RELIGION_SHINTO, RELIGION_BAHAI_FAITH)

/obj/item/storage/bible/proc/affect_user(mob/living/carbon/human/user)
	// If the user's religion would have them be "familiar" with this text
	if(user.get_cultural_value(TAG_RELIGION).name in familiar_religions)
		to_chat(user, SPAN_ITALIC("You feel somewhat reassured."))
	else
		to_chat(user, SPAN_ITALIC("You aren't entirely sure what to think."))

/obj/item/storage/bible/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(user == M || !istype(user) || !istype(M))
		return

	if(user.mind)
		user.visible_message(
				SPAN_NOTICE("\The [user] places \the [src] on \the [M]'s forehead, praying."),
				SPAN_NOTICE("You place \the [src] on \the [M]'s forehead, praying.")
			)
		if(do_after(user, 5 SECONDS, M, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && user.Adjacent(M))
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes praying and removes \the [src] from \the [M]'s forehead."),
				SPAN_NOTICE("You finish praying and remove \the [src] from \the [M]'s forehead.")
			)
			// Prevent dead/uncon people from hearing the word of God... or maybe it's a feature?
			if(M.stat)
				affect_user(M)
		..()

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && istype(user.mind.assigned_job, /datum/job/chaplain))
		if(A.reagents && A.reagents.has_reagent(/datum/reagent/water)) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("You bless \the [A].")) // I wish it was this easy in nethack ------ what is this, 1991?
			var/water2holy = A.reagents.get_reagent_amount(/datum/reagent/water)
			A.reagents.del_reagent(/datum/reagent/water)
			A.reagents.add_reagent(/datum/reagent/water/holywater,water2holy)

/*

	This presently does nothing so it's commented out

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

*/

/obj/item/storage/bible/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(user.mind)
		if(user.get_cultural_value(TAG_RELIGION).name in familiar_religions)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts to read a passage from \the [src]."),
				SPAN_NOTICE("You carefully leaf through \the [src] and begin to read a passage.")
			)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] starts to read a passage from \the [src]."),
				SPAN_NOTICE("You flip through \the [src] and start reading a passage.")
			)

		if(do_after(user, 5 SECONDS, src, do_flags = DO_PUBLIC_UNIQUE))
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes reading from \the [src]."),
				SPAN_NOTICE("You finish reading from \the [src].")
			)
			affect_user(user)
			for(var/mob/living/carbon/human/H in view(user))
				if(istype(H) && H != user)
					affect_user(H)


/***********
Torah scroll
***********/

// Not in loadouts because the Torch spawns with one by default
/obj/item/storage/bible/torah_scroll
	name = "\improper Torah scroll"
	desc = "A very old, sacred, handmade copy of the Torah on scroll rollers. Used for the Torah reading at Jewish synagogues."
	icon_state = "torahscroll_rolled"
	var/icon_state_rolled = "torahscroll_rolled"
	var/icon_state_unrolled = "torahscroll"
	var/rolled = TRUE
	// Torah scrolls are in Hebrew
	familiar_religions = list(RELIGION_JUDAISM)

/obj/item/storage/bible/torah_scroll/update_icon()
	..()
	if(rolled)
		icon_state = icon_state_rolled
		w_class = ITEM_SIZE_NORMAL
	else
		// You should roll it up before putting it in something
		w_class = ITEM_SIZE_LARGE
		icon_state = icon_state_unrolled

/obj/item/storage/bible/torah_scroll/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	if(rolled)
		to_chat(user, SPAN_WARNING("You need to unroll \the [src] first to read it."))
	else
		..()

/obj/item/storage/bible/torah_scroll/AltClick(mob/user)
	if(!istype(user))
		return

	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_WARNING("You can't roll \the [src] right now."))
		return

	user.visible_message(
		SPAN_NOTICE("\The [user] [rolled ? "unrolls" : "rolls up"] \the [src]."),
		SPAN_NOTICE("You [rolled ? "unroll" : "roll up"] \the [src].")
	)
	rolled = !rolled
	update_icon()

/obj/item/storage/bible/torah_scroll/get_mechanics_info()
	. = ..()
	. += "<p>Can be rolled up and rolled out, which changes its size.</p>"

/obj/item/storage/bible/torah_scroll/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_ALT_CLICK] += "Rolls up/out the scroll. Rolling it up makes it easier to fit inside other objects."

/*

Commenting these verbs out because they're pretty dated and need a total rework if they're to be useful ever again

/obj/item/storage/bible/verb/rename_bible()
	set name = "Rename Bible"
	set category = "Object"
	set desc = "Click to rename your bible."

	if(!renamed)
		var/input = sanitizeSafe(input("What do you want to rename your bible to? You can only do this once.", ,""), MAX_NAME_LEN)

		var/mob/M = usr
		if(src && input && !M.stat && in_range(M,src))
			SetName(input)
			to_chat(M, "You name your religious book [input].")
			renamed = 1
			return 1

/obj/item/storage/bible/verb/set_icon()
	set name = "Change Icon"
	set category = "Object"
	set desc = "Click to change your book's icon."

	if(!icon_changed)
		var/mob/M = usr

		for(var/i = 10; i >= 0; i -= 1)
			if(src && !M.stat && in_range(M,src))
				var/icon_picked = input(M, "Icon?", "Book Icon", null) in list("don't change", "bible", "koran", "scrapbook", "white", "holylight", "atheist", "kojiki", "torah", "kingyellow", "ithaqua", "necronomicon", "ninestar")
				if(icon_picked != "don't change" && icon_picked)
					icon_state = icon_picked
				if(i != 0)
					var/confirm = alert(M, "Is this what you want? Chances remaining: [i]", "Confirmation", "Yes", "No")
					if(confirm == "Yes")
						icon_changed = 1
						break
				if(i == 0)
					icon_changed = 1
*/
