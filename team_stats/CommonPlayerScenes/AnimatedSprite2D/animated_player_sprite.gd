extends Node2D
const State = {
	UP = 'default',
	DOWN = 'down',
	DEFENSE = 'defend',
	ACTION_START = 'action_start',
	ATTACK_START = 'attack_start',
}
var state = State.UP


func _ready():
	print('INITIALIZED ANIMATOR FOR')
	print(get_parent().name)
	$AnimatedSprite2D.play(state)
	_init_signals()

func _on_Took_Damage():
	print(get_parent().name)
	print('take damage')
	$AnimatedSprite2D.play("damage")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play(state)

func _on_Healed():
	$AnimatedSprite2D.play("heal")
	await $AnimatedSprite2D.animation_finished
	# не должны переставать защищаться
	$AnimatedSprite2D.play(state)

func _on_Defend():
	state = State.DEFENSE
	$AnimatedSprite2D.play(state)

func _on_Spare():
	$AnimatedSprite2D.play("spared")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play(state)

func _on_new_turn():
	if state == State.DEFENSE:
		state = State.UP
	$AnimatedSprite2D.play(state)

# ... -> action_start/attack_start
func _on_Action_start(action_start_animation=State.ACTION_START):
	print('started action')
	state = action_start_animation
	$AnimatedSprite2D.play(state)

# action_start/attack_start -> up
func _on_Action_end(action_animation='action'): 
	print('started action ending animation')
	$AnimatedSprite2D.play(action_animation)
	await $AnimatedSprite2D.animation_finished
	state = State.UP
	$AnimatedSprite2D.play(state)

# up -> down
func _on_Down(_ally):
	state = State.DOWN
	$AnimatedSprite2D.play(state)

# down -> up
func _on_Up(_ally):
	state = State.UP
	$AnimatedSprite2D.play(state)

func _init_signals():
	pass
