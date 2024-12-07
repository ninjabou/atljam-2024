extends Kickable
class_name Goal

@export var next_level: String

func kicked():
	SceneManager.goto_scene(next_level)
