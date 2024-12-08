extends Kickable
class_name Goal

@export var next_level: String
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	sprite.play("unkicked")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_page_down"):
		kicked()

func kicked():
	set_collision_layer_value(3, false)
	SoundController.play_sfx("BigButton")
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 20, 0.1).from(15)
	tween.tween_property(sprite, "modulate:v", 0.7, 0.1).from(15)
	sprite.play("kicked")
	particles.emitting = true
	SceneManager.goto_scene(next_level)
