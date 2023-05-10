extends Node
onready var attack_timer = $AttackTimer


onready var attacks = [
	#preload("res://Attacks/Attack3/Attack3.tscn").instance(),	
	#preload("res://Attacks/Attack1/Attack1.tscn").instance(),
	#preload("res://Attacks/Attack2/Attack2.tscn").instance(),
	#preload("res://Attacks/DullAttacks/DullSpamton/DullSpamton.tscn").instance(),
	preload("res://Attacks/DramaAttacks/DramaAttack5/DramaAttack5.tscn").instance(),
]
var cur_attack = 0

func _ready():
	print('main loaded!')
	add_child(attacks[cur_attack])
	connect_heart(cur_attack)
	attack_timer.start()
	$TeamStats.choose_target()

func connect_heart(cur_attack):
	# почему через get_node?
	var team_stats = get_node("TeamStats")
	var current_heart = get_node("DramaAttack5/Heart")
	#var current_heart = get_node("Attack%d/Heart" % (cur_attack + 1))
	current_heart.connect("health_changed", team_stats, "_on_take_damage")
	current_heart.connect("tp_increased", team_stats, "_on_tp_increased")
	current_heart.connect("tp_decreased", team_stats, "_on_tp_decreased")

func _on_AttackTimer_timeout():
	attack_timer.stop()
	call_deferred("remove_child", attacks[cur_attack])
	cur_attack+=1

func _on_Menu_attck_begins():
	print('__________attack begins__________')
	add_child(attacks[cur_attack])
	connect_heart(cur_attack)
	attack_timer.start()
	$TeamStats.choose_target()
