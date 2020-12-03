##########################
# TILE SELECTOR INTERFACE
# Not meant to be used, only here as a template for other selectors.
##########################
extends Node
class_name TileSelector


func get_random_tile() -> TileSelected:
	assert(false, "This is the tile selector interface, use a specific one instead")
	return null
