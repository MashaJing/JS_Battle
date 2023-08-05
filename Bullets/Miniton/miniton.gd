extends Node2D

const State = {
	DEFAULT = "default",
	DAMAGE = "damage"
}
var cur_state = State.DEFAULT
var speed = 100


func _ready():
	$AnimationPlayer.play(cur_state)


func jump_to_heart():
	speed = 0
	$AnimationPlayer.play("jump")
	yield($AnimationPlayer, "animation_finished")
	speed = 100	
	$AnimationPlayer.play(cur_state)
	

func _on_Miniton_area_entered(area):
	if area.is_in_group("bullets"):
		cur_state = State.DAMAGE
		$AnimationPlayer.play(cur_state)

func _on_HeartDetectionArea_area_entered(area):
	if area.is_in_group("player"):
			print('see the heart!')
			jump_to_heart()
