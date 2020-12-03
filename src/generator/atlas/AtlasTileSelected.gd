# Data container for Atlas selection results
extends Node
class_name AtlasTileSelected


# Tile selected
var tileSelected: Vector2 = Vector2(0, 0)

# Id of the atlas where the tile belongs
var atlasId: int = -1
# Name of atlas where the tile belongs
var atlasName: String = ""
