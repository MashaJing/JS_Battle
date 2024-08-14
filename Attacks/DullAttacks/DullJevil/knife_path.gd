extends PathFollow2D

@export var speed = 0.1
@onready var Knife = preload("res://Bullets/DevilsKnife/DevilsKnife.tscn").instantiate()


func _ready():
	Knife.rotation_speed = -.1
	add_child(Knife)
	
	
func _process(delta):
	set_progress_ratio(get_progress_ratio() + delta * speed)
	if 1.0 - progress_ratio < 0.01:
		queue_free()
