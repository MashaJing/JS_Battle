extends Node


func _ready():
	var anim = get_node("AnimationPlayer").get_animation("go_round")
	anim.set_loop(true)
	$AnimationPlayer.play("go_round")
