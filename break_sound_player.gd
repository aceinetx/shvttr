extends AudioStreamPlayer3D
class_name BreakSoundPlayer

func _ready() -> void:
	connect("finished", queue_free)
