######################
# ATLAS TILE SELECTOR
######################
extends Node
class_name AtlasTileSelector


var _tileMap: TileMap = null
var _atlasName: String

var _tileSet: TileSet = null
var _tileId: int = 0 # The atlas tile ID

var _totalColumns: int = 0 # Number of columns in the atlas
var _totalRows: int = 0 # Number of rows in the atlas
var _totalPriority: int = 0 # Total of all priorities
var _arrayPositionPriority: Array = [] # Array of Vector3


func initialize(
	tileMap: TileMap,
	atlasName: String
) -> void:
	_tileMap = tileMap
	_atlasName = atlasName
	
	_tileSet = _tileMap.get_tileset()
	_tileId = _tileSet.find_tile_by_name(_atlasName)
	
	_initialize_columns_rows()
	_initialize_position_priority_array()


# Counts columns and rows, and stores the count
func _initialize_columns_rows():
	# Atlas "region" coordinates in the tileset, e.g. (startx = 256, starty=0, sizex=32, sizey=32)
	var regionAtlas: Rect2 = _tileSet.tile_get_region(_tileId)
	# Dimensions x/y of one of the atlas item, e.g. x16/y16
	var dimensionAtlasItem: Vector2 = _tileSet.autotile_get_size(_tileId)
	# Number of columns and row in the atlas region
	_totalColumns = max(regionAtlas.size.x / dimensionAtlasItem.x, 1) # Minimum of 1
	_totalRows = max(regionAtlas.size.y / dimensionAtlasItem.y, 1) # Minimum of 1
	

# Iterates over all tiles positions within an atlas, and record the priority of each
func _initialize_position_priority_array():
	for c in range(0, _totalColumns):
		for r in range(0, _totalRows):
			var priority: int = _tileSet.autotile_get_subtile_priority(
				_tileId, 
				Vector2(c, r)
			)
			_totalPriority += priority
			_arrayPositionPriority.append(Vector3(c, r, priority)) # Store prio on Z


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
	return AtlasTile.from(
		_tileId,
		_atlasName,
		_get_subtile_with_priority()
	)


# Gets a subtile from the autotile or atlas, using priority
func _get_subtile_with_priority() -> Vector2:
	# Select one tile based on priority
	var selectedPriorityId = randi() % _totalPriority + 1
	var totalPriority: int = 0
	for i in range(0, _arrayPositionPriority.size()):
		var posAndPrio: Vector3 = _arrayPositionPriority[i]
		totalPriority += posAndPrio.z
		if (totalPriority >= selectedPriorityId):
			return Vector2(posAndPrio.x, posAndPrio.y)
	return Vector2(0, 0)
