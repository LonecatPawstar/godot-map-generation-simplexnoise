extends Node
class_name TileSelectorFactory


# Select tiles in atlases.
# atlasNames example: ["rocks", "mushrooms"]
static func AtlasesTileSelectorFrom(
	tileMap: TileMap, # TileMap containing the atlases
	atlasNames: Array # Array of Atlas names (string)
) -> AtlasesTileSelector:
	var arrayAtlasNamesAndPriorities: Array # ["name", 1]
	for i in range(0, atlasNames.size()):
		arrayAtlasNamesAndPriorities.append(
			[
				atlasNames[i],
				1
			]
		)
	return AtlasesTileSelectorWithPriorityFrom(
		tileMap,
		arrayAtlasNamesAndPriorities
	)


# Select tiles in atlases, selecting atlases according to priority defined here 
static func AtlasesTileSelectorWithPriorityFrom(
	tileMap: TileMap, # TileMap containing the atlases
	atlasNamesAndPriority: Array # Array of Atlas, priority array (string/int), e.g. [["name1", 1], ["name2", 3]]
) -> AtlasesTileSelector:
	var arrayAltasTileSelector: Array
	var arrayAtlasesPriorities: Array
	for i in range(0, atlasNamesAndPriority.size()):
		var atlasNameAndPriority: Array = atlasNamesAndPriority[i]
		arrayAltasTileSelector.append(
			AtlasTileSelectorFactory.from(tileMap, atlasNameAndPriority[0])
		)
		arrayAtlasesPriorities.append(
			atlasNameAndPriority[1]
		)
	return AtlasesTileSelectorFactory.from(
		arrayAltasTileSelector,
		arrayAtlasesPriorities
	)

