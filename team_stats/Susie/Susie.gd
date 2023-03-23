extends Node

var SUSIE_MAX_HP = 140
var HP = 140
signal SusieDown


# Called when the node enters the scene tree for the first time.
func _ready():
	print('Susie ready')	
	$AnimatedSprite.play("intro")

func take_damage(damage):
	var new_HP = HP - damage
	print('Susie hp ', new_HP)
	$AnimatedSprite.play("damage")
	if HP > 0 and new_HP < 0:
		$AnimatedSprite.play("down")
		emit_signal("KrisDown")
	HP = new_HP

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
