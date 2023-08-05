extends Node

var target = ["Jevil"]
signal attack_ended
onready var Border = preload('res://Border/Border.tscn')


func init_border():
	var border = Border.instance()
	border.global_position = $KinematicHeart.global_position
	add_child(border)


func _ready():
#	init_border()
	yield(get_tree().create_timer(2.0), "timeout")
	emit_signal("attack_ended")
