extends Kickable
class_name DefaultEnemy

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D

func kicked():
	set_collision_layer_value(4, false)
	SoundController.play_sfx("EnemyConnect")
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 20, 0.1).from(15)
	tween.tween_callback(enable_particles)
	tween.tween_callback(queue_free)

func enable_particles():
	particles.emitting = true
