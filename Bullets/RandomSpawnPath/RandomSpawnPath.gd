extends PathFollow2D

export (PackedScene) var Bullet


func spawn():
	var bullet = Bullet.instance()
	unit_offset = randf()
	bullet.global_position = global_position
	# подразумеваю, что спавнер добавлен в Path2D, а Path2D - прямой child сцены
	get_parent().get_parent().add_child(bullet)
