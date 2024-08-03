# unused
extends AnimatedSprite

signal exploded


func _ready():
	print("aaaaaaaaaaaaaaaaaaaaa")
	play("default")
	$AudioStreamPlayer2D.play()
	yield(self, "animation_finished")
	get_parent().visible = false
	emit_signal("exploded")
