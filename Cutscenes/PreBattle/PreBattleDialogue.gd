extends Node2D


func _ready():
	var dialog = Dialogic.start("pre-battle")
	add_child(dialog)
