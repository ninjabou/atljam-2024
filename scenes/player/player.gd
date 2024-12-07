extends CharacterBody2D

const MAX_SPEED := 300.0
const FLOOR_SPEED := 170.0
const JUMP_VELOCITY := -230.0

var speed := MAX_SPEED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		speed = MAX_SPEED
		velocity += get_gravity() * delta
	else:
		speed = FLOOR_SPEED
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
