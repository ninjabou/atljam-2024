extends Node2D

@export var radius := 100.0
var music_bus_level_at_start := -80.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var default_bus_layout = load("res://default_bus_layout.tres")
	AudioServer.set_bus_layout(default_bus_layout)
	music_bus_level_at_start = AudioServer.get_bus_volume_db(1)
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var listener_distance
	var ratio := 1.0
	var vol := music_bus_level_at_start
	
	listener_distance = self.global_position.distance_squared_to(GlobalCamera.get_screen_center_position())
	
	#print(listener_distance / pow(radius, 2))
	
	if listener_distance / pow(radius, 2) < 1.0:
		ratio = listener_distance / pow(radius, 2)
	else: 
		ratio = 1.0
		
	if ratio > 0.1:
		vol = music_bus_level_at_start / ratio
	else: 
		vol = -80.0

	#print(sqrt(listener_distance))
			
	AudioServer.set_bus_volume_db(1, vol)
