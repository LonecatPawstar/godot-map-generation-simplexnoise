#############
# ATLAS TILE
# Convenience class to initialize the atlas tile result properly.
#############
extends Node
class_name AtlasTile

static func from(
	atlasId: int,
	atlasName: String,
	tileSelected: Vector2
) -> TileSelected:
	var atlasTileSelected: TileSelected = TileSelected.new()
	atlasTileSelected.tileId = atlasId
	atlasTileSelected.tileName = atlasName
	atlasTileSelected.tileSelected = tileSelected
	return atlasTileSelected
