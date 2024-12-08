extends Node

var current_scene = null
var current_path = "MainMenu"
var transitioning = false
var call_queued = false

var queued_method
var queued_parameters

var reset_music = true

var scenes  = {
	"MainMenu" : "res://scenes/levels/main menu/mainmenu.tscn",
	"Default" : "res://scenes/levels/default level/default level.tscn",
	"Level1" : "res://scenes/levels/level1/level1.tscn",
	"Level2" : "res://scenes/levels/level2/level2.tscn",
	"Level3" : "res://scenes/levels/level3/level3.tscn",
	"Level4" : "res://scenes/levels/level4/level4.tscn",
	"Level5" : "res://scenes/levels/level5/level5.tscn",
	"Congrats" : "res://scenes/levels/congrats/congrats.tscn",
}

signal register_scene(scene: Node2D)

func _ready():
	self.register_scene.connect(on_register_scene)

func on_register_scene(scene: Node2D):
	current_scene = scene

# Queues a transition and stores a method to call with the specified parameters
# on the root node of the next scene once the transition finishes
func goto_scene_and_call(path, method_name, parameters):
	call_queued = true
	queued_method = method_name
	queued_parameters = parameters
	
	goto_scene(path)


# Queues a transition. If instantaneous_transition is true, will immediately
# go to the next scene. Otherwise, the next scene will only load once the method
# finish_transition is called. This can be extended to call a transition
# animation that will call finish_transition at the appropriate time
func goto_scene(path: String) -> void:
	if not transitioning:
		current_path = path
		
		transitioning = true
		
		GlobalCamera.start_transition_animation()
		await GlobalCamera.finish_transition
		call_deferred("_finish_transition")

# Instantiates the scene specified on the last goto_scene call. If a method has
# been queued, will call that method on the root not of that new scene
func _finish_transition():
	if transitioning:
		transitioning = false
		
		if (current_scene != null):
			current_scene.free()
			
		if reset_music: 
			choose_music()
		
		var s = ResourceLoader.load(scenes.get(current_path))
		current_scene = s.instantiate()
		
		if call_queued:
			current_scene.callv(queued_method, queued_parameters)
			call_queued = false
		
		get_tree().get_root().add_child(current_scene)
		get_tree().set_current_scene(current_scene)


# Queues a transition to the current scene
func restart() -> void:
	reset_music = false
	goto_scene(current_path)
	
# Chooses the correct music to play
func choose_music() -> void:
	if current_path == "MainMenu":
		SoundController.mute_music()
	if current_path == "Default": 
		SoundController.play_music("DefaultLevel")
	elif current_path == "Level1":
		SoundController.play_music("RegularLevels")
	elif current_path == "Congrats":
		SoundController.play_music("Ending")
	
