extends Area2D

var time = 0
var speed = 0
export var direction = Vector2.LEFT


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func _process(delta):
	rotate(.1)
	position += speed * delta * direction


func _on_DevilsKnife_area_entered(area):
	area.queue_free()
