extends Node
class_name AtlasTileFactory

static func AtlasTileSelected(
	tileSelected: Vector2,
	atlasId: int,
	atlasName: String
) -> TileSelected:
	var atlasTileSelected: TileSelected = TileSelected.new()
	atlasTileSelected.tileSelected = tileSelected
	atlasTileSelected.tileId = atlasId
	atlasTileSelected.tileName = atlasName
	return atlasTileSelected
