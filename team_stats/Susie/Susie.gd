extends Node2D

var MAX_HP = 140
var HP = 140

var dialogue_window = preload("res://Dialogues/ArrowDialogues/ArrowDialogues.tscn")
signal stopped_talk


func speak(replica, speed=0.01, pause=0):
	var dialogue = dialogue_window.instance()
	dialogue.flipped = true
	add_child(dialogue)
	#call_deferred("add_child", dialogue)
	$SpeakSound.play()
	# надо как-то дождаться тут анимации законченного текста
	# (мб стоит пробрасывать туда speaksound, если это возможно,
	# и его воспроизводить в самом диалоге)
	$Dialogue.display(replica, speed, pause)
	yield($Dialogue, "replica_printed")
	$SpeakSound.stop()
	# стоит вытащить на уровень выше?
	yield(dialogue, "next_line")
	remove_child(dialogue)
	emit_signal("stopped_talk")

