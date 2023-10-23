extends Node2D
const State = {
	UP = 'default',
	DEFEND = 'defend',
	DOWN = 'down'
}
var state = State.UP


func _ready():
	$AnimatedSprite.play(state)

func _on_Took_Damage():
	$AnimatedSprite.play("damage")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play(state)

func _on_Healed():
	print('caught healed!')
	$AnimatedSprite.play("heal")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play(state)

# up -> defend
func _on_Defend():
	state = State.DEFEND
	$AnimatedSprite.play(state)

# defend -> up
func _on_Stop_Defend():
	state = State.UP
	$AnimatedSprite.play(state)

# up -> down
func _on_Down():
	state = State.DOWN

# down -> up
func _on_Up():
	state = State.UP

