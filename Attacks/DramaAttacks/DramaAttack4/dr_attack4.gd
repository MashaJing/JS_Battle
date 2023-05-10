extends Node

signal attack_ended


func _ready():
	get_tree().create_timer(4.0)
	emit_signal("attack_ended")

