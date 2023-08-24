extends Area2D
# привести к одному масштабу
var animations = ["queen", "swatch"]
var direction = Vector2.DOWN
var speed = 0


func _ready():
	visible = false
	$Sprite.play(animations[randi() % len(animations)])


func stomp():
	visible = true
	speed = 600
	direction = Vector2.DOWN
	yield(get_tree().create_timer(0.5), "timeout")
	direction = Vector2.UP
	yield(get_tree().create_timer(0.5), "timeout")
	speed = 0
	direction = Vector2.DOWN
	visible = false


func _process(delta):
	global_position += direction * speed * delta
