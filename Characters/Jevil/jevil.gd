extends Node

@export var flipped = false
#signal down


func _ready():
	$AnimatedSprite2D.flip_h = flipped
	print('Jevil ready')

func facepalm():
	$AnimationPlayer.play("facepalm")

func open_moth():
	$AnimationPlayer.play("open_moth")

func close_moth():
	$AnimationPlayer.play("close_moth")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_down(_name):
	GlobalPlotSettings.play_spam_down()
