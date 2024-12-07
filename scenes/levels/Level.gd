extends Node2D

func _ready() -> void:
	SceneManager.register_scene.emit(self)
