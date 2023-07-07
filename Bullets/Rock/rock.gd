extends Area2D
var speed = 450
var G = 400
var direction = Vector2.DOWN


func _process(delta):
	speed += delta * G
	position += delta * direction * speed
