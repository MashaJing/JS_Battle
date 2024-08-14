# unused
extends AnimatedSprite2D

signal exploded


func _ready():
	print("aaaaaaaaaaaaaaaaaaaaa")
	play("default")
	$AudioStreamPlayer2D.play()
	await self.animation_finished
	get_parent().visible = false
	emit_signal("exploded")
