extends Node
class_name TileSelectorFactory


static func AlasesTileSelectorFrom(
	tileMap: TileMap, # TileMap containing the atlases
	atlasNames: Array # Array of Atlas names (string)
) -> AtlasesTileSelector:
	var arrayAltasTileSelector: Array
	for i in range(0, atlasNames.size()):
		arrayAltasTileSelector.append(
			AtlasTileSelectorFactory.from(tileMap, atlasNames[i])
		)
	return AtlasesTileSelectorFactory.from(arrayAltasTileSelector)

