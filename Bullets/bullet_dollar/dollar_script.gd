extends Area2D

export var direction = Vector2.UP
var target_object
export var speed = 0
export var ttl = 1.0

func _process(delta):
	position += direction * speed * delta

func move_to(object):
	direction = object.position - position

func stop():
	speed = 0

func _ready():
	yield(get_tree().create_timer(ttl), "timeout")
	queue_free()
