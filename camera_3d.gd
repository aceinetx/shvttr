extends Camera3D

@export var launch_speed := 20.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var screen_pos = event.position
		var from = project_ray_origin(screen_pos)
		var to   = from + project_ray_normal(screen_pos) * 1000
		
		var space_state = get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.new()
		params.from = from
		params.to = to
		params.exclude = [self]
		params.collision_mask = 0xffffffff
		var result = space_state.intersect_ray(params)
		var target_point: Vector3
		if result: target_point = result.position
		else: target_point = to
		
		var bullet: Bullet = preload("res://Bullet.tscn").instantiate()
		bullet.linear_velocity = (target_point.normalized() * launch_speed)
		get_parent().add_child(bullet)
