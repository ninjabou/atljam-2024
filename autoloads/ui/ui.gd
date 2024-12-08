extends CanvasLayer

@onready var reset_button: Button = $CenterContainer/VBoxContainer/MarginContainer/ResetButton
@onready var main_menu_button: Button = $CenterContainer/VBoxContainer/MarginContainer2/MainMenuButton
@onready var quit_button: Button = $MarginContainer3/Button

func _ready() -> void:
	visible = false
	reset_button.button_down.connect(on_reset)
	main_menu_button.button_down.connect(on_main_menu)
	quit_button.button_down.connect(on_quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
	if Input.is_action_just_pressed("action_reset"):
		on_reset()

func on_reset():
	visible = false
	PlayerKiller.kill_player()
	SceneManager.restart()

func on_main_menu():
	visible = false
	SceneManager.goto_scene("Default")

func on_quit():
	get_tree().quit()
