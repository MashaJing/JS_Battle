extends Node

var HP = 600
var ATK = 8

var dialogue_window = preload("res://Dialogues/ArrowDialogues/ArrowDialogues.tscn")
signal stopped_talk


func _ready():
	pass


func speak(replica, speed=0.01, pause=0):
	var dialogue = dialogue_window.instance()
	add_child(dialogue)
	#call_deferred("add_child", dialogue)
	if speed < 0.02:
		$SpeakSound.play()
		print('speak ', replica)
		# надо как-то дождаться тут анимации законченного текста
		# (мб стоит пробрасывать туда speaksound, если это возможно,
		# и его воспроизводить в самом диалоге)
		$Dialogue.display(replica, speed, pause)
		yield($Dialogue, "replica_printed")
		$SpeakSound.stop()
	else:
		print('speak ', replica)
		# надо как-то дождаться тут анимации законченного текста
		# (мб стоит пробрасывать туда speaksound, если это возможно,
		# и его воспроизводить в самом диалоге)
		$Dialogue.display(replica, speed, pause, $SpeakSound)
		yield($Dialogue, "replica_printed")
	yield(dialogue, "next_line")
	remove_child(dialogue)
	emit_signal("stopped_talk")


func _on_jevil_down():
	pass
