extends Area2D

onready var ray_poly = $ray

	
func shoot(color = Color.white):
	ray_poly.color = color
	$AnimationPlayer.play("shoot")
	yield($AnimationPlayer, "animation_finished")
	print('queue freed!')
	queue_free()
