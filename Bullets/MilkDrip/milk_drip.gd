extends Area2D

var speed_x

func _ready():
	speed_x = randi() % 300
	
	
func _process(delta):
	position.y += 200 * delta
	position.x += speed_x * delta
