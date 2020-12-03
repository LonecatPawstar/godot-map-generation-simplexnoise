extends Node
class_name AtlasTileSelectorFactory


static func Atlas(
	tileMap: TileMap,
	atlasName: String
) -> AtlasTileSelector:
	var atlasTileSelector: AtlasTileSelector = AtlasTileSelector.new()
	atlasTileSelector.initialize(tileMap, atlasName)
	return atlasTileSelector


static func Atlases(
	arrayAtlases: Array
) -> AtlasesTileSelector:
	var atlasesTileSelector: AtlasesTileSelector = AtlasesTileSelector.new()
	atlasesTileSelector.initialize(arrayAtlases)
	return atlasesTileSelector

