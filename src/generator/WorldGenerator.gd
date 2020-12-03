extends Node2D

onready var tileMap: TileMap = $TileMap
onready var tileMapItems: TileMap = $TileMapItems

const map_size: Vector2 = Vector2(32, 19)

const grass_cap: float = 0.5
const road_caps: Vector2 = Vector2(0.3, 0.05)


var noise: OpenSimplexNoise

# Tiles
var tileIdGrass: int
var tileIdRoad: int
var tileIdWalls: int
var tileSelectorAtlases: AtlasesTileSelector


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
	tileMapItems.clear()
	
	_init_noise()
	_init_tile_selectors()
	
	make_map()

	tileMap.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	tileMapItems.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	
	_free_all()


func _init_noise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12


func _init_tile_selectors() -> void:
	
	var tileSet: TileSet = tileMap.get_tileset()
	# Simple tile
	tileIdGrass = tileSet.find_tile_by_name("grass-solo")
	# Auto tile
	tileIdRoad = tileSet.find_tile_by_name("road")
	tileIdWalls = tileSet.find_tile_by_name("walls")
	
	# Atlas
	tileSelectorAtlases = TileSelectorFactory.AtlasesTileSelectorWithPriorityFrom(
			tileMapItems,
			[
				["atlas-rocks", 	2], 
				["atlas-mushroom", 	4], 
				["tree", 			4],
			]
		)


func _free_all() -> void:
	tileSelectorAtlases.free()


############
# GENERATORS
############
func make_map():
	for x in map_size.x:
		for y in map_size.y:
			var noiseValue: float = noise.get_noise_2d(x, y)
			select_tile_for_tilemaps(x, y, noiseValue)


# Selects a tile with some rules
func select_tile_for_tilemaps(x: int, y: int, selection: float) -> void:
	var tileTypeSelected: int = tileMap.get_cell(x, y)
	
	# Grass layer
	if selection < grass_cap:
		tileTypeSelected = tileIdGrass
		
		# Add items on grass
		if (randi() % 100 <= 2):
			var tileSelected: TileSelected = tileSelectorAtlases.get_random_tile()
			tileMapItems.set_cell(
					x, y, 
					tileSelected.tileId, 
					false, false, false, 
					tileSelected.tileSelected
			)
		
		# Add walls 1 below grass
		tileMap.set_cell(x, y + 1, tileIdWalls)
	
	# Road layer
	if selection < road_caps.x and selection > road_caps.y:
		tileTypeSelected = tileIdRoad
		# Erase items on roads
		tileMapItems.set_cell(
				x, y, 
				-1
		)
		
	tileMap.set_cell(x, y, tileTypeSelected)

