extends StateMachine

func _ready() -> void:
	add_state("idle")
	add_state("running")
	add_state("airborne")
	add_state("kicking")
	call_deferred("add_state", states.idle)

func _state_logic(delta):
	print("FUCK")
	pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
