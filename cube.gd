extends RigidBody3D
class_name Cube

@onready var collection = $VoronoiShatter/Fractured
@onready var voronoi_shatter = $VoronoiShatter
@onready var mesh = $VoronoiShatter/MeshInstance3D
@onready var score_label = $Label3D
var _pieces_lifetime: float = 2.0
var _lifetime: float = 0x1000
var _shattered = false
var score: int

func _ready() -> void:
	score = randi_range(1, 3)
	score_label.visible = false
	
	collection.visible = false
	mesh.visible = true
	
	for child in collection.get_children():
		if child is RigidBody3D:
			child.collision_layer = 1 << 3
			child.freeze = true
			for inner in child.get_children():
				if inner is MeshInstance3D:
					inner.mesh.surface_set_material(0, mesh.get_active_material(0))
					inner.mesh.surface_set_material(1, mesh.get_active_material(0))
			
func _physics_process(delta: float) -> void:
	if position.y < -4:
		print("out of map")
		queue_free()
		
	if _shattered: _pieces_lifetime -= delta
	if _shattered: _lifetime -= delta
	
	if _pieces_lifetime <= 0:
		for child in collection.get_children():
			if child is RigidBody3D:
				var tween = child.create_tween()
				tween.tween_property(child, "scale", Vector3(0.1, 0.1, 0.1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
				tween.connect("finished", child.queue_free)
				pass
				
		_pieces_lifetime = 0x100
		_lifetime = 1
	if _lifetime <= 0: queue_free()
	
func is_shattered():
	return _shattered

func shatter() -> void:
	# unfreeze the pieces, making a shatter effect
	for child in collection.get_children():
		if child is RigidBody3D:
			child.freeze = false
			child.collision_layer = 1 << 1
	_shattered = true
	
	collision_layer = 1 << 3
	freeze = true
	
	# score label effect
	score_label.visible = true
	score_label.text = "+%d" % score
	var tween = score_label.create_tween()
	tween.tween_property(score_label, "scale", Vector3(0.1, 0.1, 0.1), 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	collection.visible = true
	mesh.visible = false
