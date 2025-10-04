extends Node

var game: Game = null

var _generator = null
func get_voronoi_generator() -> VoronoiGenerator:
	if _generator == null:
		_generator = VoronoiGenerator.new()
	return _generator
