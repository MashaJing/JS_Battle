extends Node

var HP = 3500
var ATK = 10
export var flipped = false
var dialogue_window = preload("res://Dialogues/ArrowDialogues/ArrowDialogues.tscn")
signal stopped_talk
#signal down


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.flip_h = flipped
	print('Jevil ready')	

func facepalm():
	$AnimationPlayer.play("facepalm")

func open_moth():
	$AnimationPlayer.play("open_moth")

func close_moth():
	$AnimationPlayer.play("close_moth")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func take_damage(damage):
	var new_HP = HP - damage
	print('Jevil hp ', new_HP)
	$AnimationPlayer.play("damage")
	#$SoundDamage.play()
	HP = new_HP


func speak(replica, speed=0.01, pause=0):
	var dialogue = dialogue_window.instance()
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
