extends Area2D

export var direction = Vector2.DOWN
export var speed = 50
export var ttl = 100.0


func _process(delta):
	position += direction.normalized() * speed * delta

func stop():
	speed = 0

func _ready():
	$AnimationPlayer.play("appear")
	yield($AnimationPlayer, "animation_finished")
	speed = 250
	yield(get_tree().create_timer(ttl), "timeout")
	queue_free()
