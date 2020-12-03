######################
# ATLAS TILE SELECTOR
######################
extends Node
class_name AtlasTileSelector


var _tileMap: TileMap = null
var _atlasName: String

var _tileSet: TileSet = null


func initialize(
	tileMap: TileMap,
	atlasName: String
) -> void:
	_tileMap = tileMap
	_atlasName = atlasName
	_tileSet = _tileMap.get_tileset()


func _assert() -> void:
	assert(
		_tileMap != null && _atlasName != "", 
		"Function initialize() must be called"
	)
	assert(
		_tileSet.find_tile_by_name(_atlasName) >= 0,
		"Invalid atlas name " + _atlasName
	)


# Gets a random column and row number from an atlas.
# This can be passed to the set_cell method.
func get_random_tile_from_atlas() -> TileSelected:
	_assert()
	var tileIdAtlas: int = _tileSet.find_tile_by_name(_atlasName)
	# Atlas "region" coordinates in the tileset, e.g. (startx = 256, starty=0, sizex=32, sizey=32)
	var regionAtlas: Rect2 = _tileSet.tile_get_region(tileIdAtlas)
	# Dimensions x/y of one of the atlas item, e.g. x16/y16
	var dimensionAtlasItem: Vector2 = _tileSet.autotile_get_size(tileIdAtlas)
	# Number of columns and row in the atlas region
	var numberOfColumns: int = max(regionAtlas.size.x / dimensionAtlasItem.x, 1) # Minimum of 1
	var numberOfRows: int = max(regionAtlas.size.y / dimensionAtlasItem.y, 1) # Minimum of 1
	# Random tile selected corresponding to item
	return AtlasTile.from(
		tileIdAtlas,
		_atlasName,
		_get_subtile_with_priority(
			numberOfColumns,
			numberOfRows,
			tileIdAtlas
		)
	)


# Gets a subtile from the autotile or atlas, using priority
func _get_subtile_with_priority(
	numberOfColumns: int,
	numberOfRows: int,
	tileIdAtlas: int
) -> Vector2:
	var totalPriority = 0
	var arrayPositionPrio: Array
	# Iterate over all tiles positions and record them, using Vector2
	for c in range(0, numberOfColumns):
		for r in range(0, numberOfRows):
			var priority: int = _tileSet.autotile_get_subtile_priority(
				tileIdAtlas, 
				Vector2(c, r)
			)
			totalPriority += priority
			arrayPositionPrio.append(Vector3(c, r, priority)) # Store prio on Z
	# Select one tile based on priority
	var selectedPriorityId = randi() % totalPriority + 1
	totalPriority = 0
	for i in range(0, arrayPositionPrio.size()):
		var posAndPrio: Vector3 = arrayPositionPrio[i]
		totalPriority += posAndPrio.z
		if (totalPriority >= selectedPriorityId):
			return Vector2(posAndPrio.x, posAndPrio.y)
	return Vector2(0, 0)
