extends Node

var HP = 3500
var ATK = 10
export var flipped = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.flip_h = flipped
	print('Jevil ready')	

func facepalm():
	$AnimationPlayer.play("facepalm")

func spit_bullet():
	$AnimationPlayer.play("spit_bullet")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func take_damage(damage):
	var new_HP = HP - damage
	print('Jevil hp ', new_HP)
	$AnimationPlayer.play("damage")
	#$SoundDamage.play()
	HP = new_HP

#func _on_AnimatedSprite_animation_finished():
#	$AnimatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
