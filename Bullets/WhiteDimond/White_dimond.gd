extends Area2D

var speed = 300
@export var heart_position = Vector2.ZERO
var direction


func _ready():
	direction = (heart_position - global_position).normalized()
	set_rotation(direction.angle() + PI/2)

func _process(delta):
	position += speed * direction * delta

