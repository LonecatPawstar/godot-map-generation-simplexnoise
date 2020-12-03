extends Node
class_name AtlasesTileSelectorFactory


static func from(
	atlasTileSelector: Array, # Array of Atlas Tile Selectors
	arrayAtlasPriority: Array # Array of Atlases priority
) -> AtlasesTileSelector:
	var atlasesTileSelector: AtlasesTileSelector = AtlasesTileSelector.new()
	atlasesTileSelector.initialize(
		atlasTileSelector,
		arrayAtlasPriority
	)
	return atlasesTileSelector

