extends Node

var target = ["Jevil"]
signal sub_attack_ended
@onready var Border = preload('res://Border/Border.tscn')


func init_border():
	var border = Border.instantiate()
	border.global_position = $KinematicHeart.global_position
	add_child(border)


func _ready():
#	init_border()
	await get_tree().create_timer(2.0).timeout
	emit_signal("sub_attack_ended")
