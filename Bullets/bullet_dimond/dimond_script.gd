extends Area2D

@export var direction = Vector2.DOWN
@export var speed = 50
@export var ttl = 100.0


func _process(delta):
	position += direction.normalized() * speed * delta

func stop():
	speed = 0

func _ready():
	$TTL.wait_time = ttl
	$AnimationPlayer.play("appear")
	await $AnimationPlayer.animation_finished
	speed = 250

func _on_TTL_timeout():
	queue_free()
