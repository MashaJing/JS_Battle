extends PathFollow2D

export var speed = 400
onready var Knife = $DevilsKnife


func _ready():
	pass
	
func _process(delta):
	Knife.rotate(-.4)
	set_offset(get_offset() + delta * speed)
	if 1.0 - unit_offset < 0.01:
		queue_free()
