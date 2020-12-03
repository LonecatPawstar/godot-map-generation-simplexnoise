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
	atlasNamesAndPriorities: Array # Array of Atlas, priority array (string/int), e.g. [["name1", 1], ["name2", 3]]
) -> AtlasesTileSelector:
	var arrayAltasTileSelectorsPriorities: Array
	var arrayAtlasSelectorPriority
	for i in range(0, atlasNamesAndPriorities.size()):
		arrayAtlasSelectorPriority = []
		var atlasNameAndPriority: Array = atlasNamesAndPriorities[i]
		arrayAtlasSelectorPriority.append(
			AtlasTileSelectorFactory.from(tileMap, atlasNameAndPriority[0])
		)
		arrayAtlasSelectorPriority.append(
			atlasNameAndPriority[1]
		)
		arrayAltasTileSelectorsPriorities.append(
			arrayAtlasSelectorPriority
		)
	return AtlasesTileSelectorFactory.from(
		arrayAltasTileSelectorsPriorities
	)

