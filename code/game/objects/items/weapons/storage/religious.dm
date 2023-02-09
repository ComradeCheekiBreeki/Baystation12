// Assorted items that could count as "storage" for religious purposes

// Christian
/obj/item/storage/communion_bowl
	name = "communion bowl"
	desc = "A golden bowl used to hold communion wafers for Christian mass."
	icon_state = "communionbowl-empty"
	can_hold = list(/obj/item/reagent_containers/food/snacks/communionwafer)
	max_storage_space = 10
	allow_slow_dump = TRUE

/obj/item/storage/communion_bowl/on_update_icon()
	if(contents.len)
		icon_state = "communionbowl-full"
	else
		icon_state = "communionbowl-empty"

/obj/item/storage/communion_bowl/filled
	name = "communion bowl"
	desc = "A golden bowl used to hold communion wafers for Christian mass."
	icon_state = "communionbowl-empty"
	can_hold = list(/obj/item/reagent_containers/food/snacks/communionwafer)
	max_storage_space = 10
	allow_slow_dump = TRUE

	startswith = list(/obj/item/reagent_containers/food/snacks/communionwafer = 10)

// Christian - boxes
/obj/item/storage/box/communionwafer
	name = "box of communion wafers"
	desc = "A box full of communion wafers for Christian mass."
	startswith = list(/obj/item/reagent_containers/food/snacks/communionwafer = 10)
