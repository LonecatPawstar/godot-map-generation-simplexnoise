extends Node
class_name AtlasTileSelectorFactory


static func from(
	tileMap: TileMap,
	atlasName: String
) -> AtlasTileSelector:
	var atlasTileSelector: AtlasTileSelector = AtlasTileSelector.new()
	atlasTileSelector.initialize(tileMap, atlasName)
	return atlasTileSelector
