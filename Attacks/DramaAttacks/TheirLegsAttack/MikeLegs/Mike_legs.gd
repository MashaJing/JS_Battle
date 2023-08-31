extends Area2D
var direction = Vector2.DOWN
var speed = 0


func _ready():
	visible = false

func stomp():
	$AnimatedSprite.play("default")
	visible = true
	speed = 560
	yield(get_tree().create_timer(0.5), "timeout")
	speed = 0

func _process(delta):
	global_position += direction * speed * delta