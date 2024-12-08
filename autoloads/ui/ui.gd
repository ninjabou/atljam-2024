extends CanvasLayer

@onready var reset_button: Button = $CenterContainer/VBoxContainer/MarginContainer/ResetButton
@onready var main_menu_button: Button = $CenterContainer/VBoxContainer/MarginContainer2/MainMenuButton
@onready var quit_button: Button = $MarginContainer3/Button

func _ready() -> void:
	visible = false
	reset_button.button_down.connect(on_reset)
	main_menu_button.button_down.connect(on_main_menu)
	quit_button.button_down.connect(on_quit)
	reset_button.mouse_entered.connect(on_reset_hover)
	main_menu_button.mouse_entered.connect(on_menu_button_hover)
	quit_button.mouse_entered.connect(on_quit_hover)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SoundController.play_sfx("MenuOpen")
		visible = !visible
	if Input.is_action_just_pressed("action_reset"):
		on_reset()

func on_reset():
	SoundController.play_sfx("MenuButtonPress")
	SoundController.play_sfx("LevelReset")
	visible = false
	PlayerKiller.kill_player()
	SceneManager.restart()

func on_main_menu():
	SoundController.play_sfx("MenuButtonPress")
	visible = false
	SceneManager.goto_scene("Default")

func on_quit():
	SoundController.play_sfx("MenuButtonPress")
	get_tree().quit()

func on_reset_hover():
	SoundController.play_sfx("MenuMouseOver")

func on_menu_button_hover():
	SoundController.play_sfx("MenuMouseOver")

func on_quit_hover():
	SoundController.play_sfx("MenuMouseOver")
