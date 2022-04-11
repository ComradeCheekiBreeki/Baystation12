#include "milsat_areas.dm"
#include "milsat_objects.dm"


/obj/effect/overmap/visitable/sector/military_satellite
	name = "Unusual debris"
	desc = "A drifiting debris field pockmarked with scrambled sensor readings and hints of radiation."
	in_space = TRUE
	icon_state = "object"
	known = FALSE

	initial_generic_waypoints = list(
		"nav_milsat_1",
		"nav_milsat_2"
	)

/datum/map_template/ruin/away_site/military_satellite
	name = "Military satellite"
	id = "awaysite_military_satellite"
	description = "A damaged military satellite."
	suffixes = list('military_satellite/military_satellite-1.dmm','military_satellite/military_satellite-2.dmm','military_satellite/military_satellite-3.dmm')
	spawn_cost = 1
	accessibility_weight = 10
	area_usage_test_exempted_areas = list(/area/AIsattele)
	area_usage_test_exempted_root_areas = list(/area/constructionsite, /area/derelict)
	apc_test_exempt_areas = list(
		/area/AIsattele = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite/ai = NO_SCRUBBER|NO_VENT,
		/area/constructionsite/atmospherics = NO_SCRUBBER|NO_VENT,
		/area/constructionsite/teleporter = NO_SCRUBBER|NO_VENT,
		/area/derelict/ship = NO_SCRUBBER|NO_VENT,
		/area/djstation = NO_SCRUBBER|NO_VENT|NO_APC
	)
	area_coherency_test_subarea_count = list(
		/area/constructionsite = 7,
		/area/constructionsite/maintenance = 14,
		/area/constructionsite/solar = 3,
	)
