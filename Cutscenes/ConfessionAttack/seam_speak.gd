extends Node

var dialogue_window = preload("res://Dialogues/ArrowDialogues/ArrowDialogues.tscn")
signal stopped_talk


func _ready():
	pass

func speak(replica, speed=0.01, pause=0):
	var dialogue = dialogue_window.instance()
	add_child(dialogue)
	$Dialogue.display(replica, speed, pause)
	yield($Dialogue, "replica_printed")
	# стоит вытащить на уровень выше?
	#yield(dialogue, "next_line")
	yield(get_tree().create_timer(1.0), "timeout")
	remove_child(dialogue)
	emit_signal("stopped_talk")
