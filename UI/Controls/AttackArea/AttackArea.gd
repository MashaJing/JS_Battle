extends ColorRect

signal bar_finished(bar_name)

var initial_position = 0
var MIN_RATIO = 100  # минимальный коэффициент атаки
var ratio = MIN_RATIO


func start():
	print(name + '_STARTEDED_ATTACK')
	visible = true
	$AnimationPlayer.play("go_" + str(initial_position))


func attack():
	print(name + '_ATTACKED')
	$AnimationPlayer.stop()
	$AnimationPlayer.play("glow")
	$HitSound.play()


func end(attack_ratio):
	AttackController.confirm_attack(attack_ratio, name)
	emit_signal("bar_finished", name)
	visible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	print(name + '_FINISHED_ATTACK')
	if anim_name == "glow":  # если анимация закончилась атакой
		# signal *проигрыш звука*
		ratio = abs($AttackPeakRect.rect_position.x - $AttackCursor.rect_position.x)
	else:  # если анимация просто прошла
		ratio = MIN_RATIO
		
	end(ratio)
