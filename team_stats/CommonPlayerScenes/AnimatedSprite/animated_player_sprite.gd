extends Node2D
const State = {
	UP = 'default',
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
	$AnimatedSprite.play("heal")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play(state)

# up -> down
func _on_Down():
	state = State.DOWN

# down -> up
func _on_Up():
	state = State.UP
