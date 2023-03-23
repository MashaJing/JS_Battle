extends Node
onready var attack_timer = $AttackTimer


var attacks = [
	#preload("res://Attacks/Attack3/Attack3.tscn").instance(),	
	#preload("res://Attacks/Attack1/Attack1.tscn").instance(),
	#preload("res://Attacks/Attack2/Attack2.tscn").instance(),
	preload("res://Attacks/DullAttacks/DullSpamton/DullSpamton.tscn").instance(),
	#preload("res://Attacks/DramaAttacks/DramaAttack4/DramaAttack4.tscn").instance(),
]
var cur_attack = 0

func _ready():
	print('main loaded!')
	add_child(attacks[cur_attack])
	attack_timer.start()
	connect_heart(cur_attack)

func connect_heart(cur_attack):
	var team_stats = get_node("TeamStats")
	var current_heart = get_node("DullSpamton/Heart")
	#var current_heart = get_node("Attack%d/Heart" % (cur_attack + 1))
	current_heart.connect("health_changed", team_stats, "_on_take_damage")

func _on_AttackTimer_timeout():
	attack_timer.stop()
	call_deferred("remove_child", attacks[cur_attack])
	cur_attack+=1

func _on_Menu_attck_begins():
	print('drama attack 3 begins!')
	add_child(attacks[cur_attack])
	connect_heart(cur_attack)
	attack_timer.start()
