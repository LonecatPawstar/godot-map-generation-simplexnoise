extends Node
class_name TileSelectorFactory


const ERROR_ATLAS_PRIORITY_FORMAT: String = "Invalid atlas and priority array '%s'. Atlas and priority must be passed as an array of arrays [string, int], e.g. [[\"name1\", 2], [\"name2\", 5]]"


# Select tiles in atlases.
# atlasNames example: ["rocks", "mushrooms"]
static func AtlasesTileSelectorFrom(
	tileMap: TileMap, # TileMap containing the atlases
	atlasNames: Array # Array of Atlas names (string)
) -> AtlasesTileSelector:
	var arrayAtlasNamesAndPriorities: Array # ["name", 1]
	for i in range(0, atlasNames.size()):
		var atlasName = atlasNames[i]
		assert(
			atlasName is String, 
			"Invalid atlas with name '" + str(atlasName) + "'. Atlas names must be passed as an array of Strings, e.g. [\"name1\", \"name2\"]"
		)
		arrayAtlasNamesAndPriorities.append(
			[
				atlasName,
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
		var errorString = ERROR_ATLAS_PRIORITY_FORMAT % str(atlasNameAndPriority)
		assert(
			atlasNameAndPriority is Array, 
			errorString
		)
		assert(
			atlasNameAndPriority[0] is String, 
			errorString
		)
		assert(
			atlasNameAndPriority[1] is int, 
			errorString
		)
		
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

