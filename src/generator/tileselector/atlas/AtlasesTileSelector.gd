######################
# ATLAS TILE SELECTOR
######################
extends Node
class_name AtlasesTileSelector


var _atlasTileSelectorArray: Array = []


func initialize(
	atlasTileSelectorArray: Array
) -> void:
	_atlasTileSelectorArray = atlasTileSelectorArray


func _assert() -> void:
	assert(
		_atlasTileSelectorArray.size() != 0, 
		"Function initialize() must be called"
	)
	assert(
		_atlasTileSelectorArray.front() is AtlasTileSelector,
		"Atlas array must contain AtlasTileSelector"
	)


# Gets a random tile from an array of atlas.
func get_random_tile_from_atlases() -> TileSelected:
	_assert()
	_atlasTileSelectorArray.shuffle()
	var atlasSelector: AtlasTileSelector = _atlasTileSelectorArray.front()
	return atlasSelector.get_random_tile_from_atlas()

