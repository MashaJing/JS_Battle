extends Node2D
var target_position


func _ready():
	$AnimatedSprite.play("fly_to_target")
	$HealSound.play()


func pet_head():
	$AnimatedSprite.play("heal")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _process(delta):
	pass
