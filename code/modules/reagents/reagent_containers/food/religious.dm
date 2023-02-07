// Foods
/obj/item/reagent_containers/food/snacks/communionwafer
	name = "communion wafer"
	desc = "A small, round piece of unleavened bread. Part of the Christian communion rite."
	icon_state = "wafer"
	w_class = ITEM_SIZE_TINY
	filling_color = "#c6bf85"
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("bread" = 1)
	nutriment_amt = 2
	bitesize = 2

// Glasses
/obj/item/reagent_containers/food/drinks/glass2/communion_chalice
	name = "communion chalice"
	desc = "A golden chalice used in Christian communion."
	base_name = "chalice"
	base_icon = "chalice"
	icon = 'icons/obj/drink_glasses/chalice.dmi'
	filling_states = "80;100"
	volume = 30
	possible_transfer_amounts = "5;10;15;20"
	rim_pos = "y=26;x_left=11;x_right=20"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_wine
	name = "carafe"
	base_name = "carafe"

/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_wine/New()
	..()
	reagents.add_reagent(/datum/reagent/ethanol/communion_wine, 80)
	update_icon()

/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_water
	name = "carafe"
	base_name = "carafe"

/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_water/New()
	..()
	reagents.add_reagent(/datum/reagent/water, 80)
	update_icon()
