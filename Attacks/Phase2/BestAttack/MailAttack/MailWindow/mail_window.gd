extends Area2D


func _ready():
	$AnimationPlayer.play("window_open")
	
	
func close():
	$AnimationPlayer.play_backwards("window_open")
