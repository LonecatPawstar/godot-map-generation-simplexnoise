extends Node
class_name AtlasTileFactory

static func AtlasTileSelected(
	tileSelected: Vector2,
	atlasName: String
) -> AtlasTileSelected:
	var atlasTileSelected: AtlasTileSelected = AtlasTileSelected.new()
	atlasTileSelected.tileSelected = tileSelected
	atlasTileSelected.atlasName = atlasName
	return atlasTileSelected
