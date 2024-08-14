extends Node2D

signal attack_ended


func _ready():
	var dialog = Dialogic.start("appearance_first")
	add_child(dialog)
	await Dialogic.timeline_ended
	emit_signal("attack_ended")
