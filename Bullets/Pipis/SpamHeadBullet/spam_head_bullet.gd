extends Area2D

var direction = Vector2.ZERO
var time = 0
var speed = 250
var a = 70
var damaged = false


func _ready():
	var animation = ''
	if damaged:
		animation = "damaged" + str(randi() % 5 + 1)
	else:
		animation = "default"
	$AnimatedSprite.play(animation)


func _process(delta):
	time += delta
	position = direction * (speed * time - a * time * time / 2)
