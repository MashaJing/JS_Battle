extends Node2D
const State = {
	UP = 'default',
	DOWN = 'down',
	DEFENSE = 'defend'
}
var state = State.UP


func _ready():
	$AnimatedSprite.play(state)

func _on_Took_Damage():
	$AnimatedSprite.play("damage")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play(state)

func _on_Healed():
	$AnimatedSprite.play("heal")
	yield($AnimatedSprite, "animation_finished")
	# не должны переставать защищаться
	$AnimatedSprite.play(state)

func _on_Defend():
	state = State.DEFENSE
	$AnimatedSprite.play(state)

func _on_Back_to_idle():
	if state == State.DEFENSE:
		state = State.UP
	$AnimatedSprite.play(state)

# up -> down
func _on_Down(_ally):
	state = State.DOWN

# down -> up
func _on_Up(_ally):
	state = State.UP

