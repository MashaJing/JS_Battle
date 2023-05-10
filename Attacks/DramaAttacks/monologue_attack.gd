extends Node2D

onready var Jevil = $Jevil
onready var Spamton = $Spamton

# todo: НОРМАЛЬНЫЕ имена
onready var attacks = [
	preload("res://Attacks/DramaAttacks/DramaAttack1/DramaAttack1.tscn"),
	#preload("res://Attacks/DramaAttacks/DramaAttack2/DramaAttack2.tscn"), # ошибка
	#preload("res://Attacks/DramaAttacks/DramaAttack3/DramaAttack3.tscn"), # ошибка
	preload("res://Attacks/DramaAttacks/DramaAttack4/DramaAttack4.tscn"), # не падает, но сигнала нет
	preload("res://Attacks/DramaAttacks/DramaAttack5/DramaAttack5.tscn"), # не падает, но сигнала нет
]
var cur_attack = 1


func _ready():
	for attack in attacks:
		print(cur_attack)
		print('attack loaded!')
		var Attack = attack.instance()
		add_child(Attack)
		yield(Attack, "attack_ended")
		call_deferred("remove_child", Attack)
		#$TeamStats.choose_target()
		cur_attack += 1
		

func _on_attack_ended():
	print('__________attack begins__________')
