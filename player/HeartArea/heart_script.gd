extends Area2D

signal health_changed()
signal tp_increased()
signal tp_decreased()


func _ready():
	add_to_group("heart")

func take_damage():
	$CollisionPolygon2D.set_deferred("disabled", true)
	print('took_damage')

	# анимация + звук дамага
	$AnimationPlayer.play("damage")
	$SoundDamage.play()

	# сигнал о получении дамага (принимает Attacktarget в сцене main)
	# todo: переименовать в health_change?
	emit_signal("health_changed")
	emit_signal("tp_decreased")

	# Даём секунду неуязвимости
	yield(get_tree().create_timer(1), "timeout")
	$CollisionPolygon2D.set_deferred("disabled", false)

func _on_TP_area_exited(area):
	if area.is_in_group("bullets"):
		$AnimationPlayer.play("exit")

func _on_TP_area_entered(area):
	#print('TP ENTERED!')
	# обрастаю ифами, надо подумать, как реагировать без них
	if area.is_in_group("bullets"):
		emit_signal("tp_increased")
		$AnimationPlayer.play("enter")

func _on_Heart_area_entered(area):
	#print('ENTERED!')
	if area.is_in_group("bullets"):
		take_damage()

