extends Node2D

onready var tileMap: TileMap = $TileMap
onready var tileMapItems: TileMap = $TileMapItems

const map_size: Vector2 = Vector2(32, 19)

const grass_cap: float = 0.5
const road_caps: Vector2 = Vector2(0.3, 0.05)

var noise: OpenSimplexNoise

func _ready() -> void:
	#randomize()
	initialize()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		initialize()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func initialize() -> void:
	tileMap.clear()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	
	make_map()
	#make_grass_map()
	#make_road_map()
	tileMap.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	tileMapItems.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))


############
# GENERATORS
############
func make_map():
	for x in map_size.x:
		for y in map_size.y:
			var noiseValue: float = noise.get_noise_2d(x, y)
			select_tile_for_tilemap(x, y, noiseValue)

# Selects a tile with some rules
func select_tile_for_tilemap(x: int, y: int, selection: float) -> void:
	# Tileset for TileMap
	var tileSet: TileSet = tileMap.get_tileset()
	var tileIdGrassSolo: int = tileSet.find_tile_by_name("grass-solo")
	var tileIdRoad: int = tileSet.find_tile_by_name("road")
	
	# Tileset for TileMapItems
	var tileSetItems: TileSet = tileMap.get_tileset()
	var tileIdRocks: int = tileSet.find_tile_by_name("atlas-rocks")
	#var tileIdMushrooms: int = tileSet.find_tile_by_name("atlas-mushrooms")
	

	
	var tileTypeSelected: int = -1
	var tileItemTypeSelected: int = -1
	if selection < grass_cap:
		tileTypeSelected = tileIdGrassSolo
		tileItemTypeSelected = tileIdRocks
		var itemFromAtlas: Vector2 = select_item_from_atlas(tileSetItems, "atlas-rocks")
		tileMapItems.set_cell(x, y, tileItemTypeSelected, false, false, false, itemFromAtlas)
	
	if selection < road_caps.x and selection > road_caps.y:
		tileTypeSelected = tileIdRoad
		
	tileMap.set_cell(x, y, tileTypeSelected)

# Gets a random column and row number from an atlas.
# This can be passed to the set_cell method.
func select_item_from_atlas(
	tileSetContainingAtlas: TileSet,
	atlasName: String
) -> Vector2:
	var tileIdAtlas: int = tileSetContainingAtlas.find_tile_by_name(atlasName)
	# Atlas "region" coordinates in the tileset, e.g. (startx = 256, starty=0, sizex=32, sizey=32)
	var regionAtlas: Rect2 = tileSetContainingAtlas.tile_get_region(tileIdAtlas)
	# Dimensions x/y of one of the atlas item, e.g. x16/y16
	var dimenstionAtlasItem: Vector2 = tileSetContainingAtlas.autotile_get_size(tileIdAtlas)
	# Number of columns and row in the atlas region
	var numberOfColumns: int = regionAtlas.size.x / dimenstionAtlasItem.x
	var numberOfRows: int = regionAtlas.size.y / dimenstionAtlasItem.y
	# Random column and row corresponding to item
	return Vector2(randi() % numberOfColumns, randi() % numberOfRows)
