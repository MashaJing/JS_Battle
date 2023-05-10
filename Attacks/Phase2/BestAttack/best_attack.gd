extends Node2D

onready var attacks = [
	preload("res://Attacks/Phase2/BestAttack/ClubsAttack/ClubsAttack.tscn").instance(),
	preload("res://Attacks/Phase2/BestAttack/KnivesAttack/KnivesAttack.tscn").instance(),
	preload("res://Attacks/Phase2/BestAttack/MailAttack/MailAttack.tscn").instance(),
	preload("res://Attacks/Phase2/BestAttack/PipisAttack/PipisAttack.tscn").instance(),
]
var current_attack = 0


func _ready():
	start_attack()

func _on_attack_ended():
	current_attack+=1
	if current_attack < len(attacks):
		start_attack()
	else:
		queue_free()

func start_attack():
	# todo: change_scene!
	add_child(attacks[current_attack])
	attacks[current_attack].connect("attack_ended", self, "_on_attack_ended")
