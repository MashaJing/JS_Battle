extends AnimatedSprite

signal exploded


func _ready():
	print("aaaaaaaaaaaaaaaaaaaaa")
	play("default")
	yield(self, "animation_finished")
	emit_signal("exploded")
