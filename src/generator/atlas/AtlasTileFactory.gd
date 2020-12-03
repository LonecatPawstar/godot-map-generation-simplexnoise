extends Node
class_name AtlasTileFactory

static func AtlasTileSelected(
	tileSelected: Vector2,
	atlasId: int,
	atlasName: String
) -> AtlasTileSelected:
	var atlasTileSelected: AtlasTileSelected = AtlasTileSelected.new()
	atlasTileSelected.tileSelected = tileSelected
	atlasTileSelected.atlasId = atlasId
	atlasTileSelected.atlasName = atlasName
	return atlasTileSelected
