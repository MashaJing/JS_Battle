extends Area2D

signal health_changed
signal tp_increased
signal tp_decreased

signal take_damage


func _ready():
	add_to_group("heart")
	connect("health_changed", TeamStats, "_on_take_damage")
	connect("tp_increased", TeamStats, "_on_tp_increased")
	connect("tp_decreased", TeamStats, "_on_tp_decreased")


func take_damage():
	# сигнал для детей
	emit_signal("take_damage")
	$CollisionPolygon2D.set_deferred("disabled", true)

	# сигнал о получении дамага (принимает Attacktarget в сцене main)
	# тут высчитывается hp_delta на осовании АТК + DEF
	emit_signal("health_changed")

	# Даём секунду неуязвимости
	yield(get_tree().create_timer(1), "timeout")
	$CollisionPolygon2D.set_deferred("disabled", false)

func take_heal():
	emit_signal("health_changed")
	emit_signal("tp_increased")
	
	# TODO: звук хилки
	$SoundDamage.play()

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
	elif area.is_in_group("heal_bullets"):
		take_heal()

