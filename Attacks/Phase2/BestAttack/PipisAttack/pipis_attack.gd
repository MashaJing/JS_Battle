extends Node2D
signal attack_ended


func _ready():
	yield(get_tree().create_timer(5), "timeout")
	emit_signal("attack_ended")
	queue_free()
