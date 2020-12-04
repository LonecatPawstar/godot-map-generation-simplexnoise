extends Node2D

onready var labelInfo: Label = $LabelInfo
var iteration: int = 0

onready var tileMapGrass: TileMap = $TileMapGrass
onready var tileMapRoad: TileMap = $TileMapRoad
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
	
	if Input.is_action_pressed("ui_right"):
		initialize()
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func initialize() -> void:
	tileMapGrass.clear()
	tileMapRoad.clear()
	tileMapItems.clear()
	
	_init_label()
	_init_noise()
	_init_tile_selectors()
	
	make_map()
	
	tileMapGrass.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	tileMapRoad.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	tileMapItems.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))
	
	_free_all()


func _init_label() -> void:
	iteration += 1
	labelInfo.text = "Iteration: " + str(iteration)

func _init_noise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12


func _init_tile_selectors() -> void:
	
	var tileSet: TileSet = tileMapGrass.get_tileset()
	# Simple tile
	#tileIdGrass = tileSet.find_tile_by_name("grass-solo")
	tileIdGrass = tileSet.find_tile_by_name("grass")
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
	
	for x in map_size.x:
		for y in map_size.y:
			var noiseValue: float = noise.get_noise_2d(x, y)
			add_items_layer(x, y, noiseValue)


# Selects a tile with some rules
func select_tile_for_tilemaps(
	x: int, 
	y: int, 
	selection: float
) -> void:
	var tileTypeSelected: int = tileMapGrass.get_cell(x, y)
	
	# Grass layer
	if selection < grass_cap:
		tileTypeSelected = tileIdGrass
		# Add walls 1 below grass
		tileMapGrass.set_cell(x, y + 1, tileIdWalls)
	
	# Road layer
	if selection < road_caps.x and selection > road_caps.y:
		tileMapRoad.set_cell(x, y, tileIdRoad)
		
	tileMapGrass.set_cell(x, y, tileTypeSelected)


func add_items_layer(
	x: int, 
	y: int, 
	selection: float
) -> void:
	# Grass layer
	if selection < grass_cap:
		# Add items on grass
		if (randi() % 100 <= 8):
			var tileSelected: TileSelected = tileSelectorAtlases.get_random_tile()
			if (!is_drawing_over_forbidden_tile(
					x,
					y,
					tileSelected
				)):
				tileMapItems.set_cell(
						x, y, 
						tileSelected.tileId, 
						false, false, false, 
						tileSelected.tileSelected
				)


func is_drawing_over_forbidden_tile(
	x: int,
	y: int,
	tileSelected: TileSelected
) -> bool:
	var numberOfCells: Vector2 = get_number_of_cells(tileSelected)
	# Return tiles covering a road
	var foriddenTileFound: bool = false
	for a in range(0, numberOfCells.x):
		for b in range(0, numberOfCells.y):
			var tileRoad: int = tileMapRoad.get_cell(x + a, y + b)
			if (tileRoad != TileMap.INVALID_CELL):
				foriddenTileFound = true
			
			var tileGrass: int = tileMapGrass.get_cell(x + a, y + b)
			if (tileGrass == TileMap.INVALID_CELL
					or tileGrass == tileIdWalls):
				foriddenTileFound = true
	
	return foriddenTileFound

# The number of cells is 1, 1 for autotiles (since only 1 cell is drawn at a time)
# and only different for large single tiles
func get_number_of_cells(
		tileSelected: TileSelected
) -> Vector2:
	var tileSet: TileSet = tileMapItems.get_tileset()
	# Get region size of tile selected
	var tileRegion: Rect2 = tileSet.tile_get_region(tileSelected.tileId)
	# Get tilemap cell size
	var tileMapCellSize: Vector2 = tileMapItems.get_cell_size()
	
	var tileMode = tileSet.tile_get_tile_mode(tileSelected.tileId)
	# Divide the region size of the tile (x, y) by the tilemap cell size (x, y)
	if (tileMode != TileSet.SINGLE_TILE):
		return Vector2(1, 1)
	else:
		var numberOfCells: Vector2 = Vector2(
			tileRegion.size.x / tileMapCellSize.x,
			tileRegion.size.y / tileMapCellSize.y
		)
		return numberOfCells
