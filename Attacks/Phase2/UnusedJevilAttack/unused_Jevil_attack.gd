extends Node2D
signal attack_ended

# сделать большой коэф атаки, как задумывалось в ориге !!!


func _ready():
	var dialog = Dialogic.start("unused_attack")
	add_child(dialog)
	
	await dialog.timeline_ended
	emit_signal("attack_ended")
	
	# идея для патттерна атаки: harvester
	# knife.end_rotation_speed = 0
	# knife.middle_rotation_speed = -0.1
	# knife.speed = 0.1


func begin_attack():
	$KnifeOrigin.visible = true
	$AnimationPlayer.play("attack")


func _on_AttackTimer_timeout():
	$KnifeOrigin/Blade/CollisionPolygon2D.disabled = false
