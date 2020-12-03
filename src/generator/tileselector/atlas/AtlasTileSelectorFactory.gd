extends Node
class_name AtlasesTileSelectorFactory


static func from(
	atlasTileSelector: Array # Array of Atlas Tile Selectors
) -> AtlasesTileSelector:
	var atlasesTileSelector: AtlasesTileSelector = AtlasesTileSelector.new()
	atlasesTileSelector.initialize(atlasTileSelector)
	return atlasesTileSelector

