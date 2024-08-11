extends Area2D

@onready var ray_poly = $ray

	
func shoot(color = Color.WHITE):
	ray_poly.color = color
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	print('queue freed!')
	queue_free()
