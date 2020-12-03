########################
# ATLASES TILE SELECTOR
########################
extends TileSelector
class_name AtlasesTileSelector


var _atlasTileSelectorPriorityArray: Array = []
var _totalPriority: int = 0


func initialize(
	atlasTileSelectorPriorityArray: Array # Array of tile selector and prio, e.g. [obj: TileSelector, priority: int]
) -> void:
	_atlasTileSelectorPriorityArray = atlasTileSelectorPriorityArray
	_initializeTotalPriority()


func _initializeTotalPriority() -> void:
	for i in range(0, _atlasTileSelectorPriorityArray.size()):
		_totalPriority += _atlasTileSelectorPriorityArray[i][1]


func _assert() -> void:
	assert(
		_atlasTileSelectorPriorityArray.size() != 0, 
		"Function initialize() must be called"
	)
	var atlasSelectorPriority = _atlasTileSelectorPriorityArray.front()
	assert(
		atlasSelectorPriority[0] is AtlasTileSelector,
		"Atlas array must contain [AtlasTileSelector, int]"
	)
	assert(
		atlasSelectorPriority[1] is int,
		"Atlas array must contain [AtlasTileSelector, int]"
	)


# Gets a random tile from an array of atlas.
func get_random_tile() -> TileSelected:
	_assert()
	var selectedPriority = randi() % _totalPriority + 1
	var totalPriority = 0
	for i in range(0, _atlasTileSelectorPriorityArray.size()):
		totalPriority += _atlasTileSelectorPriorityArray[i][1]
		if totalPriority >= selectedPriority:
			return _atlasTileSelectorPriorityArray[i][0].get_random_tile_from_atlas()
	return null

