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
		_tileSet.find_tile_by_name(_atlasName) > 0,
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
	var dimenstionAtlasItem: Vector2 = _tileSet.autotile_get_size(tileIdAtlas)
	# Number of columns and row in the atlas region
	var numberOfColumns: int = regionAtlas.size.x / dimenstionAtlasItem.x
	var numberOfRows: int = regionAtlas.size.y / dimenstionAtlasItem.y
	# Random tile selected corresponding to item
	return AtlasTileFactory.AtlasTileSelected(
		Vector2(randi() % numberOfColumns, randi() % numberOfRows),
		tileIdAtlas,
		_atlasName
	)
