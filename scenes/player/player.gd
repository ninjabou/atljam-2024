extends CharacterBody2D

enum States {IDLE, RUNNING, AIRBORNE}
enum Kicks {LEFT, DOWN, RIGHT, NONE}

const FLOOR_SPEED := 170.0
const AIR_SPEED := 300.0
const KICK_SPEED := 800.0
const SIDE_KICK_JUMP_VELOCITY := -270.0
const DOWN_KICK_JUMP_VELOCITY := -520.0
const JUMP_VELOCITY := -290.0
const AIRBORNE_ADJUST := 0.03

@export var kicking := Kicks.NONE

@onready var animations: AnimationPlayer = $PlayerAnimations
@onready var kick_left: Area2D = $KickLeft
@onready var kick_right: Area2D = $KickRight
@onready var kick_down: Area2D = $KickDown
@onready var kick_left_particles: GPUParticles2D = $KickLeft/GPUParticles2D
@onready var kick_right_particles: GPUParticles2D = $KickRight/GPUParticles2D
@onready var kick_down_particles: GPUParticles2D = $KickDown/GPUParticles2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var state = States.IDLE
var jump_horizontal_dir := 0.0

func _ready() -> void:
	GlobalCamera.follow_pos(self.global_position)
	GlobalCamera.snap_to_aim()

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		state = States.AIRBORNE
		velocity += get_gravity() * delta
	else:
		state = States.IDLE
	
	var direction := Input.get_axis("action_left", "action_right")
	var dir_updown := Input.get_axis("action_up", "action_down")
	
	if Input.is_action_just_pressed("action_jump") && state == States.AIRBORNE && !animations.is_playing():
		if direction > 0.0 && dir_updown == 0.0:
			animations.play("kick_right")
		if direction < 0.0 && dir_updown == 0.0:
			animations.play("kick_left")
		if dir_updown > 0.0:
			animations.play("kick_down")
	
	if kicking == Kicks.LEFT:
		if kick_left.get_overlapping_bodies().size() > 0:
			jump_horizontal_dir = 1.0
			velocity.x = KICK_SPEED
			velocity.y = SIDE_KICK_JUMP_VELOCITY
			kick_left_particles.restart()
			kicks_reset()
			kick_enemies(kick_left)
	if kicking == Kicks.RIGHT:
		if kick_right.get_overlapping_bodies().size() > 0:
			jump_horizontal_dir = -1.0
			velocity.x = -KICK_SPEED
			velocity.y = SIDE_KICK_JUMP_VELOCITY
			kick_right_particles.restart()
			kicks_reset()
			kick_enemies(kick_right)
	if kicking == Kicks.DOWN:
		if kick_down.get_overlapping_bodies().size() > 0:
			kick_enemies(kick_down)
			velocity.y = DOWN_KICK_JUMP_VELOCITY
			kick_down_particles.restart()
			kicks_reset()
		
	
	if state == States.AIRBORNE:
		jump_horizontal_dir = move_toward(jump_horizontal_dir, direction, AIRBORNE_ADJUST)
		velocity.x = move_toward(velocity.x, jump_horizontal_dir * AIR_SPEED, 10)
	else:
		if direction:
			state = States.RUNNING
			velocity.x = direction * FLOOR_SPEED
			
			if direction > 0.0:
				sprite.flip_h = true
			if direction < 0.0:
				sprite.flip_h = false
			sprite.play("walk")
		else:
			state = States.IDLE
			sprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, FLOOR_SPEED)
		
		if Input.is_action_just_pressed("action_jump") and is_on_floor():
			jump_horizontal_dir = direction
			velocity.y = JUMP_VELOCITY
			velocity.x = direction * AIR_SPEED
	
	GlobalCamera.follow_pos(self.global_position)
	
	move_and_slide()

func kicks_reset():
	animations.stop()
	GlobalCamera.add_trauma(0.15)
	kicking = Kicks.NONE

func kick_enemies(area: Area2D):
	for body in area.get_overlapping_bodies():
		if body is Kickable:
			KickablesManager.kick.emit(body)
