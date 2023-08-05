extends Area2D

export var direction = Vector2.DOWN
export var speed = 200
export var ttl = 100.0


func _process(delta):
	position += direction.normalized() * speed * delta

func stop():
	speed = 0

func _ready():
	yield(get_tree().create_timer(ttl), "timeout")
	queue_free()
