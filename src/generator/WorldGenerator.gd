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
	
	var tileTypeSelected: int = -1
	var tileItemTypeSelected: int = -1
	if selection < grass_cap:
		tileTypeSelected = tileIdGrassSolo
			
		# Tileset for TileMapItems
		var tileSetItems: TileSet = tileMapItems.get_tileset()
		var tileIdRocks: int = tileSetItems.find_tile_by_name("atlas-rocks")
		tileItemTypeSelected = tileIdRocks
		
		var atlasesTileSelector: AtlasesTileSelector = TileGeneratorFactory.Atlases(
			[
				TileGeneratorFactory.Atlas(tileMapItems, "atlas-rocks"),
				TileGeneratorFactory.Atlas(tileMapItems, "atlas-mushroom")
			]
		)
		var atlasTileSelected: AtlasTileSelected = atlasesTileSelector.get_random_tile_from_atlases()
		atlasesTileSelector.free()
		
		tileMapItems.set_cell(
				x, y, 
				tileSetItems.find_tile_by_name(atlasTileSelected.atlasName), 
				false, false, false, 
				atlasTileSelected.tileSelected
		)
	
	if selection < road_caps.x and selection > road_caps.y:
		tileTypeSelected = tileIdRoad
		
	tileMap.set_cell(x, y, tileTypeSelected)

