extends Node2D

onready var KidAnimation = $Kid/AnimationPlayer


func _ready():
	$AnimationPlayer.play("go_round")

func _on_KidActionTimer_timeout():
	KidAnimation.play("reach")
	$KidActionTimer.wait_time = 1 + randf()
