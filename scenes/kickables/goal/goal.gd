extends Kickable
class_name Goal

@export var next_level: String
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	sprite.play("unkicked")

func kicked():
	sprite.play("kicked")
	particles.emitting = true
	SceneManager.goto_scene(next_level)
