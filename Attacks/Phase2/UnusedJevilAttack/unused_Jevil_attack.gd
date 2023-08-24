extends Node2D
signal attack_began
signal attack_ended

# сделать большой коэф атаки, как задумывалось в ориге !!!

func _process(_delta):
	pass

func _ready():
	$Spamton/AnimationPlayer.play("default")
	$Spamton.speak("STOP [[ANYTHING]]")
	yield($Spamton, "stopped_talk")
	$Spamton.speak("JEV, STAY [online]")
	yield($Spamton, "stopped_talk")
	print('started anim')
	$AnimationPlayer.play("spam_leave")
	yield($AnimationPlayer, "animation_finished")
	$Spamton.speak("LOOK AT THIS   [TOTALLY IMBALANCED] UN-USED ATTACK I'VE [FOUND] !")
	yield($Spamton, "stopped_talk")
	
	emit_signal("attack_began")
	$AttackTimer.start()
	yield($AttackTimer, "timeout")
	emit_signal("attack_ended")
	
	# идея для патттерна атаки: harvester
	# knife.end_rotation_speed = 0
	# knife.middle_rotation_speed = -0.1
	# knife.speed = 0.1


func _on_UnusedJevilAttack_attack_began():
	$KnifeOrigin.visible = true
	$AnimationPlayer.play("attack")
