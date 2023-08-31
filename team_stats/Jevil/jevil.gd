extends Node

var HP = 3500
var ATK = 10
export var flipped = false
#signal down


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
