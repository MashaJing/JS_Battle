extends Node2D

onready var mail_attack = preload("res://Attacks/DramaAttacks/BestAttack/MailAttack/MailAttack.tscn").instance()
onready var devil_knife_attack = preload("res://Attacks/DramaAttacks/BestAttack/DevilsBoomerang/DevilsBoomerang.tscn").instance()
onready var pipis_attack = preload("res://Attacks/DramaAttacks/BestAttack/PipisAttack/PipisAttack.tscn").instance()
onready var dimond_spiral_attack = preload("res://Attacks/DramaAttacks/BestAttack/DimondSpiralSpit/DimondSpiralSplit.tscn").instance()
var current_attack = 0
signal attack_ended


func _ready():
#	get_parent().get_node("Jevil").visible = false
	$AttackPlayer.play("best_attack")
	yield($AttackPlayer, "animation_finished")
#	get_parent().get_node("Jevil").visible = true
	emit_signal("attack_ended")
	

#func _on_attack_ended():
#	current_attack += 1
#	if current_attack < len(attacks):
#		start_attack()
#	else:
#		queue_free()

func start_attack(attack):
	add_child(attack)


func start_mail_attack():
	start_attack(mail_attack)


func start_devils_knife_attack():
	start_attack(devil_knife_attack)


func start_pipis_attack():
	start_attack(pipis_attack)


func dimond_spiral_attack():
	start_attack(dimond_spiral_attack)