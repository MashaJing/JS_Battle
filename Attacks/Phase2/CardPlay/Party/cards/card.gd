extends Area2D
var texture_path = "res://Assets/Images/Bullets/cards/%s.png" 
var texture = "spam_tuz"
var finish_point = Vector2.ZERO

var time = 0
var	turn_on = 0

var velocity = Vector2.ZERO
var d = 0


func _ready():
	$Sprite.modulate = Color(1, 1, 1, 0)
	$Sprite.texture = load(texture_path % texture)
	$AnimationPlayer.play("appear")
	yield($AnimationPlayer, "animation_finished")
	turn_on = 1

func _process(delta):
	velocity = (finish_point - global_position) * turn_on
	global_position += delta * velocity * 2
	rotate(velocity.x / 2000)
