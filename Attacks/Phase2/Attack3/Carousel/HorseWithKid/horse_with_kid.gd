extends Node2D

export var wait_time = 1
onready var KidAnimation = $Kid/AnimationPlayer


func _ready():
	$KidActionTimer.wait_time = wait_time
	$AnimationPlayer.play("go_round")

func _on_KidActionTimer_timeout():
	KidAnimation.play("jump_off")
