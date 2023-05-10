extends Node

signal attack_ended


func _ready():
	get_tree().create_timer(2.0)
	emit_signal("attack_ended")

