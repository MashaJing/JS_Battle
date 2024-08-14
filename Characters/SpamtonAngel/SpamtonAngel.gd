extends Node2D
var target_position


func _ready():
	$AnimatedSprite2D.play("fly_to_target")
	$HealSound.play()


func pet_head():
	$AnimatedSprite2D.play("heal")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _process(delta):
	pass
