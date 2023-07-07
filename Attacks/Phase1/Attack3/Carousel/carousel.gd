extends Node

export (PackedScene) var horse_scene


func _ready():
	var horizontal_amount = 7
	var anim_delta = 8.0 / horizontal_amount

	var horse_locations = $HorsePos.get_children()
	for horse_spawn in horse_locations:
		for i in range(horizontal_amount):
			var bullet = horse_scene.instance()
			bullet.position = horse_spawn.global_position
			horse_spawn.add_child(bullet)
			var player = bullet.get_node("AnimationPlayer")
			player.seek(anim_delta * i)
