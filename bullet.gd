extends RigidBody3D
class_name Bullet

var lifetime: float = 10.

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 3
	body_entered.connect(collision)
	
func destroy_with_animation() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0, 0, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.connect("finished", queue_free)
	lifetime = 0x100
	
func collision(body: Node) -> void:
	if body is Cube and not body.is_shattered():
		body.shatter()
		G.game.add_score(body.score)
		
		var sound_player = preload("res://BreakSoundPlayer.tscn").instantiate()
		sound_player.pitch_scale = 1.0 + (randf() / 2 - 0.25)
		G.game.add_child(sound_player)
		sound_player.play()
		sound_player.position = body.position
		#destroy_with_animation()

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		destroy_with_animation()
