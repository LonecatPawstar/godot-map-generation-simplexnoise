extends Node
class_name AtlasesTileSelectorFactory


static func Atlases(
	arrayAtlases: Array
) -> AtlasesTileSelector:
	var atlasesTileSelector: AtlasesTileSelector = AtlasesTileSelector.new()
	atlasesTileSelector.initialize(arrayAtlases)
	return atlasesTileSelector

