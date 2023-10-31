extends Node2D
const State = {
	UP = 'default',
	DOWN = 'down',
	DEFENSE = 'defend',
	ACTION_START = 'action_start'
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

func _on_Spare(_victim):
	$AnimatedSprite.play("spare")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play(state)

func _on_Back_to_idle():
	if state == State.DEFENSE:
		state = State.UP
	$AnimatedSprite.play(state)

func _on_Action_start():
	state = State.ACTION_START
	$AnimatedSprite.play(state)

# action_start -> up
func _on_Action_end(action_animation='action'): 
	$AnimatedSprite.play(action_animation)
	yield($AnimatedSprite, "animation_finished")
	state = State.UP
	$AnimatedSprite.play(state)

# up -> down
func _on_Down(_ally):
	state = State.DOWN

# down -> up
func _on_Up(_ally):
	state = State.UP
