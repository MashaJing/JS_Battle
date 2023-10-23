extends Node2D
onready var Spamton = $Spamton/AnimatedSpriteController/AnimatedSprite
onready var CashTimer = $DollarTimer
onready var CashBullet = preload("res://Bullets/Cash/Cash.tscn")
onready var Border = preload("res://Border/Border.tscn")
signal card_attack_ended


func init_border():
	var border = Border.instance()
	border.global_position = $KinematicHeart.global_position
	add_child(border)

func _ready():
	init_border()
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
	$Spamton.get_node("AnimationPlayer").play("throw_cash")
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
	yield($AnimationPlayer, "animation_finished")
	emit_signal("card_attack_ended")
