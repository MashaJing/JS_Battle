extends Area2D

var direction =  Vector2.ZERO
var speed =  70

func _ready():
	$AnimationPlayer.play("default")


func _process(delta):
	position += delta * direction * speed
