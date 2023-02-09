/obj/structure/closet/crate/tabernacle
	name = "tabernacle"
	desc = "A sacred container that houses items used in Christian communion."
	closet_appearance = null
	icon = 'icons/obj/closets/tabernacle.dmi'
	setup = 0
	points_per_crate = 350 // You really should not be salvaging a fucking tabernacle but it *is* made of gold

/obj/structure/closet/crate/tabernacle/filled
	setup = 0

/obj/structure/closet/crate/tabernacle/filled/WillContain()
	return list(
		/obj/item/storage/communion_bowl/filled = 1,
		/obj/item/reagent_containers/food/drinks/glass2/communion_chalice = 2,
		/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_wine = 1,
		/obj/item/reagent_containers/food/drinks/glass2/carafe/communion_water = 1
	)

/*
/obj/structure/closet/crate/torah_ark
	name = "\improper Torah ark"
	desc = "A sacred container found in Jewish places of worship used to contain the Torah scrolls."
	closet_appearance = null
	icon = 'icons/obj/closets/torah_ark.dmi'
	setup = 0

/obj/structure/closet/crate/torah_ark/filled
	setup = 0

/obj/structure/closet/crate/torah_ark/filled/WillContain()
	return list(/obj/item/storage/bible/torah_scroll = 1)
*/
