extends Kickable
class_name DefaultEnemy

@onready var sprite: AnimatedSprite2D = $Sprite2D

func kicked():
	set_collision_layer_value(4, false)
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 20, 0.1).from(15)
	tween.tween_callback(queue_free)
