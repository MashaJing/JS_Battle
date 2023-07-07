extends Node2D
signal attack_began

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
	
	# идея для патттерна атаки: harvester
	# knife.end_rotation_speed = 0
	# knife.middle_rotation_speed = -0.1
	# knife.speed = 0.1


func _on_UnusedJevilAttack_attack_began():	
	$AnimationPlayer.play("attack")
