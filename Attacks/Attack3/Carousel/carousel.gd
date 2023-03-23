extends Node

export (PackedScene) var bullet_scene
export (PackedScene) var bullet_scene_2


func _ready():
	var horizontal_amount = 7
	# длина анимации на количество лошадок - мне в ломы прокидывать длину красиво
	var anim_delta = 8.0 / horizontal_amount

	var horse_locations = $HorsePos.get_children()
	for horse_spawn in horse_locations:	
		for i in range(horizontal_amount):
			print(horse_spawn, '', i)
			var bullet = bullet_scene.instance()
			add_child(bullet)
			bullet.position = horse_spawn.position
			print(bullet.position)
			var player = bullet.get_node("AnimationPlayer")
			player.seek(anim_delta * i)
		print()
