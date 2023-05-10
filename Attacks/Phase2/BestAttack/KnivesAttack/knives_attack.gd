extends Node2D

onready var KnifeBullet = preload("res://Bullets/DevilsKnife/DevilsKnife.tscn")
signal attack_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	for knife_name in ['KnifePrePath', 'KnifePrePath2']:
		var knife = get_node(knife_name)
		show_line(knife)
		yield(get_tree().create_timer(0.5), "timeout")
		knife.clear_points()
		create_knife(knife)
		yield(get_tree().create_timer(0.9), "timeout")
		remove_child(knife)
	emit_signal("attack_ended")
	queue_free()

func show_line(knife):
	for i in range(20):
		var KnifePathFollow = knife.get_node('Path2D/PathFollow2D')
		KnifePathFollow.unit_offset = i * 0.05
		knife.add_point(KnifePathFollow.global_position)

func create_knife(knife):
	var spawn = knife.get_node('KnifeSpawn')
	var knife_bullet = KnifeBullet.instance()
	knife_bullet.position = spawn.position
	knife.add_child(knife_bullet)
