extends Node2D

onready var tileMap: TileMap = $TileMap

var map_size: Vector2 = Vector2(32, 19)

var grass_cap: float = 0.5
var road_caps: Vector2 = Vector2(0.3, 0.05)

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
	
	make_grass_map()
	make_road_map()
	tileMap.update_bitmask_region(Vector2(0, 0), Vector2(map_size.x, map_size.y))



func make_grass_map():
	var tileId: int = tileMap.get_tileset().find_tile_by_name("grass")
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x, y)
			if a < grass_cap:
				tileMap.set_cell(x, y, tileId)


func make_road_map():
	var tileId: int = tileMap.get_tileset().find_tile_by_name("road")
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x, y)
			if a < road_caps.x and a > road_caps.y:
				tileMap.set_cell(x, y, tileId)

