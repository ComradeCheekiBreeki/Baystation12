/area/milsat
	icon = "maps/away/military_satellite/military_satellite_sprites.dmi"

//the interior areas and gantry areas are listed from top to bottom like a sandwich
//interiors
/area/milsat/interior
	icon_state = "interior"

/area/milsat/interior/upper
	name = "\improper Military Satellite"
	icon_state = "telecomms"

/area/milsat/interior/main
	name = "\improper Military Satellite"

/area/milsat/interior/tcomms
	name = "\improper Military Satellite Telecomms"
	icon_state = "telecomms"

/area/milsat/interior/storage
	name = "\improper Military Satellite Storage"
	icon_state = "storage"

//gantries and solars
/area/milsat/gantry
	name = "\improper Military Satellite Gantry"
	icon_state = "gantry"
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = 0
	always_unpowered = 1
	has_gravity = FALSE
	base_turf = /turf/space

/area/milsat/gantry/upper
	name = "\improper Military Satellite Upper Gantry"

/area/milsat/gantry/main
	name = "\improper Military Satellite Main Gantry"

/area/milsat/gantry/solar_upper
	name = "\improper Military Satellite Upper Solars"
	icon_state = "solars"

/area/milsat/gantry/lower
	name = "\improper Military Satellite Lower Gantry"

/area/milsat/gantry/solar_lower
	name = "\improper Military Satellite Lower Solars"
	icon_state = "solars"
