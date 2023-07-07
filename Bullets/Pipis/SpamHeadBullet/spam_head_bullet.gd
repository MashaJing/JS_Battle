extends Area2D

var direction = Vector2.ZERO
var time = 0
var speed = 250
var a = 70


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position = direction * (speed * time - a * time * time / 2)
