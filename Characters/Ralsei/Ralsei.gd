extends Node2D

signal stopped_talk
signal RalseiDown

var RALSEI_MAX_HP = 100
var HP = 100
var dialogue_window = preload("res://Dialogues/ArrowDialogues/ArrowDialogues.tscn")


func speak(replica, speed=0.01, pause=0):
	var dialogue = dialogue_window.instance()
	add_child(dialogue)
	#call_deferred("add_child", dialogue)
#	$SpeakSound.play()
	# надо как-то дождаться тут анимации законченного текста
	# (мб стоит пробрасывать туда speaksound, если это возможно,
	# и его воспроизводить в самом диалоге)
	$Dialogue.display(replica, speed, pause)
	yield($Dialogue, "replica_printed")
#	$SpeakSound.stop()
	# стоит вытащить на уровень выше?
	yield(dialogue, "next_line")
	remove_child(dialogue)
	emit_signal("stopped_talk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
