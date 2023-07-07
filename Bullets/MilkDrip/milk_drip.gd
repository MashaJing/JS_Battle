extends Area2D

var speed_x
export var direction = Vector2.RIGHT


func _ready():
	speed_x = randi() % 230 + 50
	
	
func _process(delta):
	position.y += 200 * delta
	position += speed_x * delta * direction
