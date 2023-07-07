extends Line2D

var pts=PoolVector2Array()
onready var wire_nodes = [
	get_parent().get_node("Phone"),
	get_parent().get_node("WireNode"),
	get_parent().get_node("WireNode2"),
	get_parent().get_node("WireNode3"),
	get_parent().get_node("WireBegin")
]


func _physics_process(delta):
	clear_points()
	for node in wire_nodes:
		pts=add_point(node.position)
