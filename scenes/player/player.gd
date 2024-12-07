extends CharacterBody2D

enum States {IDLE, RUNNING, AIRBORNE}
enum Kicks {LEFT, DOWN, RIGHT, NONE}

const FLOOR_SPEED := 170.0
const AIR_SPEED := 300.0
const KICK_SPEED := 800.0
const KICK_JUMP_VELOCITY := -200.0
const JUMP_VELOCITY := -270.0
const AIRBORNE_ADJUST := 0.03

@export var kicking := Kicks.NONE

@onready var animations: AnimationPlayer = $PlayerAnimations
@onready var kick_left: Area2D = $KickLeft
@onready var kick_right: Area2D = $KickRight

var state = States.IDLE
var jump_horizontal_dir := 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		state = States.AIRBORNE
		velocity += get_gravity() * delta
	else:
		state = States.IDLE
	
	var direction := Input.get_axis("action_left", "action_right")
	
	if Input.is_action_just_pressed("action_jump") && state == States.AIRBORNE && !animations.is_playing():
		if direction > 0.0:
			animations.play("kick_right")
		if direction < 0.0:
			animations.play("kick_left")
	print(kicking)
	if kicking == Kicks.LEFT:
		if kick_left.get_overlapping_bodies().size() > 0:
			jump_horizontal_dir = 1.0
			velocity.x = KICK_SPEED
			velocity.y = KICK_JUMP_VELOCITY
			kicking = Kicks.NONE
	if kicking == Kicks.RIGHT:
		if kick_right.get_overlapping_bodies().size() > 0:
			jump_horizontal_dir = -1.0
			velocity.x = -KICK_SPEED
			velocity.y = KICK_JUMP_VELOCITY
			kicking = Kicks.NONE
	
	if state == States.AIRBORNE:
		jump_horizontal_dir = move_toward(jump_horizontal_dir, direction, AIRBORNE_ADJUST)
		velocity.x = move_toward(velocity.x, jump_horizontal_dir * AIR_SPEED, 10)
	else:
		if direction:
			state = States.RUNNING
			velocity.x = direction * FLOOR_SPEED
		else:
			state = States.IDLE
			velocity.x = move_toward(velocity.x, 0, FLOOR_SPEED)
		
		if Input.is_action_just_pressed("action_jump") and is_on_floor():
			jump_horizontal_dir = direction
			velocity.y = JUMP_VELOCITY
			velocity.x = direction * AIR_SPEED
	
	move_and_slide()
