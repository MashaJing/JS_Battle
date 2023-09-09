extends Area2D

var speed_x
var time = 0
var target_object = Vector2.DOWN


func _ready():
	speed_x = 0 # randi() % 130 + 10
	look_at(target_object)


func _process(delta):
	time += delta
	position.y += 5 * time * time
	position.x += speed_x * delta
