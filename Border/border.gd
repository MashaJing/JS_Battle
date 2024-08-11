extends StaticBody2D


func _ready():
	$BoxSprite.frame = 0
	$BoxSprite.play("Appear")
	$AnimationPlayer.play("darken_screen")

func _exit_tree():
	$AnimationPlayer.play_backwards("darken_screen")
	$BoxSprite.play("Appear", true)
