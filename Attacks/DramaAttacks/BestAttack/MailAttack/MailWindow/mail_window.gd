extends Area2D


func _ready():
	$AnimationPlayer.play("window_open")
	yield($AnimationPlayer, "animation_finished")
	
func close():
	$AnimationPlayer.play_backwards("window_open")