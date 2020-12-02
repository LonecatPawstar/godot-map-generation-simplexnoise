extends Node2D

onready var tileMapGrass = $TileMap

var map_size: Vector2 = Vector2(80, 60)
var grass_cap: float = 0.5

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
	tileMapGrass.clear()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	make_grass_map()


func make_grass_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x, y)
			if a < grass_cap:
				tileMapGrass.set_cell(x, y, 0)
