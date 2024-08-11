extends Node2D

const BlackPipisAttack = preload("res://Attacks/MadSpamAttack/BlackPipisAttack/BlackPipisAttack.tscn")
const HeadShotsAttack = preload("res://Attacks/MadSpamAttack/HeadShotsAttack/HeadShotsAttack.tscn")
signal attack_ended


func _ready():
	# нужен какой-то переиспользуемый механизм для добваления атак
	var Attack = BlackPipisAttack.instantiate()
	add_child(Attack)
