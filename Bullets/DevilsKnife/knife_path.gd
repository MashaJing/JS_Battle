extends PathFollow2D

@export var middle_rotation_speed = -0.05
@export var end_rotation_speed = -0.1
@export var knife_scale = 1.0
@export var speed = 1
@export var devils_knife = preload("res://Bullets/DevilsKnife/DevilsKnife.tscn")


func _ready():
	var knife = devils_knife.instantiate()
	knife.scale *= knife_scale
	knife.rotation_speed = end_rotation_speed
	$KnifeOrigin.add_child(knife)
	knife.position.y += 100


func _process(delta):
#	unit_offset += delta * speed
#	$KnifeOrigin.rotate(middle_rotation_speed)
	set_progress_ratio(get_progress_ratio() + delta * speed + 0.01)
	if 1.0 - progress_ratio < 0.1:
		emit_signal("child_exiting_tree")
		queue_free()


func reverse():
	speed *= -1

