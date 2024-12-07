extends Kickable
class_name DefaultEnemy

func kicked():
	self.queue_free()
