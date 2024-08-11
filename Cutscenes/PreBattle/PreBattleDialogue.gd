extends Node2D

signal attack_ended
@onready var MusTheme = get_parent().get_node("Theme")


func _ready():
	var dialog = Dialogic.start("pre_battle")
	add_child(dialog)
	await Dialogic.timeline_ended
	MusTheme.set_soundtrack('battle.ogg')
	emit_signal("attack_ended")
