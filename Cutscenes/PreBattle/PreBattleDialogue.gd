extends Node2D

signal attack_ended
onready var MusTheme = get_parent().get_node("Theme")


func _ready():
	var dialog = Dialogic.start("pre-battle")
	add_child(dialog)
	yield(dialog, "dialogic_signal")
	MusTheme.set_soundtrack('battle.ogg')
	emit_signal("attack_ended")
