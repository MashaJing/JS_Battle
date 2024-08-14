extends CollisionPolygon2D


func _on_Heart_take_damage():
	set_deferred("disabled", true)

	# Даём секунду неуязвимости
	await get_tree().create_timer(1).timeout
	set_deferred("disabled", false)
