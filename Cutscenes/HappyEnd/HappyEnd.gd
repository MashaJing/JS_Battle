extends Node2D

signal attack_ended
@onready var MusTheme = get_parent().get_node("Theme")


func _ready():
	MusTheme.stop()
	var dialog = Dialogic.start("happy_end")
	add_child(dialog)
	await dialog.timeline_ended
	MusTheme.set_soundtrack('My_Castle_Town_lofi.mp3')
