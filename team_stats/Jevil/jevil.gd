extends Node

var HP = 3500
var ATK = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	print('Jevil ready')	
	#$AnimatedSprite.play("intro")


func facepalm():
	$AnimatedSprite.play("Facepalm")
	$Slap.play()
	$ShortLaughter.play()

func take_damage(damage):
	var new_HP = HP - damage
	print('Jevil hp ', new_HP)
	$AnimatedSprite.play("damage")
	$SoundDamage.play()
	HP = new_HP

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
