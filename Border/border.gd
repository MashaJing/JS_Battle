extends StaticBody2D


func _ready():
	$BoxSprite.frame = 0
	$BoxSprite.play("Appear")

func _exit_tree():
	$BoxSprite.play("Appear", true)
