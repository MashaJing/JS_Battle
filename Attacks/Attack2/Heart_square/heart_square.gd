extends Area2D

var direction = Vector2.LEFT
var speed = 250.0
var rotationSpeed = 1.0

func _process(delta):
	position += direction * speed * delta
	rotate(.1)

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
