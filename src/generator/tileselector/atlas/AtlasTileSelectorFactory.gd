extends Node
class_name AtlasesTileSelectorFactory


static func from(
	atlasTileSelectorWithPriority: Array # Array of [obj: AtlasTileSelector, priority: int]
) -> AtlasesTileSelector:
	var atlasesTileSelector: AtlasesTileSelector = AtlasesTileSelector.new()
	atlasesTileSelector.initialize(
		atlasTileSelectorWithPriority
	)
	return atlasesTileSelector

