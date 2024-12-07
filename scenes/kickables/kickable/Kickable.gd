extends AnimatableBody2D
class_name Kickable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KickablesManager.register_kickable.emit(self)

func kicked():
	pass
