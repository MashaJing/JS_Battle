extends PathFollow2D

@export (PackedScene) var Bullet


func spawn():
	var bullet = Bullet.instantiate()
	progress_ratio = randf()
	bullet.global_position = global_position
	# подразумеваю, что спавнер добавлен в Path2D, а Path2D - прямой child сцены
	get_parent().get_parent().add_child(bullet)


func spawn_instance(bullet):
	progress_ratio = randf()
	bullet.global_position = global_position
	# подразумеваю, что спавнер добавлен в Path2D, а Path2D - прямой child сцены
	get_parent().get_parent().add_child(bullet)
