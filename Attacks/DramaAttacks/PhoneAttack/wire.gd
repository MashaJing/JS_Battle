extends Line2D

var pts=PoolVector2Array()
onready var phone =	get_parent().get_node("WireBase/Phone")
onready var wireBase =	get_parent().get_node("WireBase")


func _ready():
	pts=add_point(wireBase.position)
	pts=add_point(phone.position)
	

func _process(delta):
	set_point_position(1, phone.position)
