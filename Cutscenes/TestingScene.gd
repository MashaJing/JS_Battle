extends Node2D
signal attack_ended


func _ready():
	var d = Dialogic.start("spamton_down")
	add_child(d)
	await d.timeline_ended
#	var a = Dialogic.start("jevil_down_end")
#	add_child(a)
