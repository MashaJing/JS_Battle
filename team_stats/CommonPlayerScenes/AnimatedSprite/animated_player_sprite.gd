extends Node2D
const State = {
	UP = 'default',
	DOWN = 'down',
	DEFENSE = 'defend',
	ACTION_START = 'action_start'
}
var state = State.UP


func _ready():
	print('INITIALIZED ANIMATOR FOR')
	print(get_parent().name)
	$AnimatedSprite.play(state)
	_init_signals()

func _on_Took_Damage():
	print(get_parent().name)
	print('take damage')
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

func _on_new_turn():
	if state == State.DEFENSE:
		state = State.UP
	$AnimatedSprite.play(state)

func _on_Action_start():
	print('started action')
	state = State.ACTION_START
	$AnimatedSprite.play(state)

# action_start -> up
func _on_Action_end(action_animation='action'): 
	print('started action ending animation')
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

func _init_signals():
	pass
