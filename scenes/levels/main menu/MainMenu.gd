extends Node2D

func _ready() -> void:
	SceneManager.register_scene.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_jump"):
		SoundController.play_sfx("MenuButtonPress")
		SceneManager.goto_scene("Default")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
