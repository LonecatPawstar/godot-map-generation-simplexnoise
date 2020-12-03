# Data container for Tile selection results
extends Node
class_name TileSelected

# ID on tileset
var tileId: int = -1
# Name on tileset
var tileName: String = ""

# Subtile selected if any, or (0, 0) is the base tile
var tileSelected: Vector2 = Vector2(0, 0)
