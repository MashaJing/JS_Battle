extends KinematicBody2D

export var previous_node_name = "WireNode"
var velocity = Vector2()
var gravity = Vector2(0, 300)
var pos_ex = Vector2()
var previous_node


# Called when the node enters the scene tree for the first time.
func _ready():
	previous_node = get_parent().get_node(previous_node_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var previous_node_pos = previous_node.pos_ex
	print(previous_node.name, previous_node.pos_ex)
	velocity = (previous_node_pos - position) * 15 #+ gravity
	pos_ex = position
	move_and_slide(velocity)
