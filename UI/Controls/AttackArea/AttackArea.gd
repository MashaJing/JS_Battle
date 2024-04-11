extends ColorRect

signal bar_finished(bar_name)

var initial_position = 0


func start():
	visible = true
	$AnimationPlayer.play("go_" + str(initial_position))
	yield($AnimationPlayer, "animation_finished")
	visible = false


func attack():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("glow")
	yield($AnimationPlayer, "animation_finished")
	# signal *проигрыш звука*
	var ratio = abs($AttackPeakRect.rect_position.x - $AttackCursor.rect_position.x)
	AttackController.confirm_attack(ratio, name)
	emit_signal("bar_finished", name)

	visible = false
