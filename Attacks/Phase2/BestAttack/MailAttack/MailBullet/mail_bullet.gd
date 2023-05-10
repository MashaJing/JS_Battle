extends RigidBody2D


var speed = randi() % 50
var gravity = 100
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 10
	z_index = randi() % 2
	pass # Replace with function body.

func _physics_process(delta):
	position.x += speed * delta

