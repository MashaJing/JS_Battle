extends PathFollow2D

export var speed = 400
onready var Knife = preload("res://Bullets/DevilsKnife/DevilsKnife.tscn").instance()


func _ready():
	Knife.rotation_speed = -.1
	add_child(Knife)
	
	
func _process(delta):
	set_offset(get_offset() + delta * speed)
	if 1.0 - unit_offset < 0.01:
		queue_free()
