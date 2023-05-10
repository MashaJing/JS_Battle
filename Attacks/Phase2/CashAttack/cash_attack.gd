extends Node2D
onready var Spamton = $Spamton/AnimatedSprite
onready var CashTimer = $DollarTimer
onready var CashBullet = preload("res://Bullets/Cash/Cash.tscn")


func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	spamton_jumps()
	yield($AnimationPlayer, "animation_finished")
	spamton_attacks()
	# и дожидаемся срабатывания _on_AttackTimer_timeout
	
	
func spamton_jumps(revert=false):
	# почему-то не срабатывает, если прокидывать параметр обратки в play
	if revert:
		Spamton.play("jump")
		$AnimationPlayer.play_backwards("jump_on_area")
	else:
		Spamton.play("jump")
		$AnimationPlayer.play("jump_on_area")
	yield($AnimationPlayer, "animation_finished")
	Spamton.play("default")


func spamton_attacks():
	$DollarTimer.start()
	$AttackTimer.start()
	Spamton.play("throw_cash")
	$AnimationPlayer.play("attack")


func _on_DollarTimer_timeout():
	print($Spamton.position)
	for _i in range(5):
		var bullet = CashBullet.instance()
		bullet.global_position = $Spamton/DollarSpawn.global_position
		add_child(bullet)
		bullet.add_to_group("bullets")
		yield(get_tree().create_timer(0.02), "timeout")


func _on_AttackTimer_timeout():
	$DollarTimer.stop()
	$AnimationPlayer.stop()
	print($Spamton.position)	
	spamton_jumps(true)	
