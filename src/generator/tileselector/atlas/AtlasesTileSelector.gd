########################
# ATLASES TILE SELECTOR
########################
extends TileSelector
class_name AtlasesTileSelector


var _atlasTileSelectorArray: Array = []
var _priorityArray: Array = []
var _totalPriority: int = 0


func initialize(
	atlasTileSelectorArray: Array,
	priorityArrary: Array = [] # Array of ints
) -> void:
	_atlasTileSelectorArray = atlasTileSelectorArray
	_priorityArray = priorityArrary
	_initializeTotalPriority()


func _initializeTotalPriority() -> void:
	for i in range(0, _priorityArray.size()):
		_totalPriority += _priorityArray[i]


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
func get_random_tile() -> TileSelected:
	_assert()
	var selectedPriority = randi() % _totalPriority + 1
	var totalPriority = 0
	for i in range(0, _atlasTileSelectorArray.size()):
		totalPriority += _priorityArray[i]
		if totalPriority >= selectedPriority:
			return _atlasTileSelectorArray[i].get_random_tile_from_atlas()
	return null

