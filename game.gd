extends Node3D
class_name Game

var _next_spawn_time: float = 1.0
var _score: int = 0
@onready var score_label = $UI/ScoreLabel

func _ready() -> void:
	G.game = self
	
func spawn_cube() -> void:
	var cube: Cube = preload("res://Cube.tscn").instantiate()
	cube.gravity_scale = 0.3
	cube.position = Vector3(randf() * 8 - 4, 4, -3)
	add_child(cube)
	
func add_score(score: int):
	_score += score
	score_label.text = "Score: %d" % _score
	
func _physics_process(delta: float) -> void:
	_next_spawn_time -= delta
	if _next_spawn_time <= 0:
		spawn_cube()
		_next_spawn_time = randf() + 1
