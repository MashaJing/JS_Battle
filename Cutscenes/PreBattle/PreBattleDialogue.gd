extends Node2D

var BEST_ATTACK_SCENE = "res://Attacks/Phase2/BestAttack/best_attack.tscn"


func _ready():
	var dialog = Dialogic.start("test1")
	add_child(dialog)
	# по сигналу из диалога - переключение сцены на атаку - begin_attack


func begin_attack():
	get_tree().change_scene(BEST_ATTACK_SCENE)
