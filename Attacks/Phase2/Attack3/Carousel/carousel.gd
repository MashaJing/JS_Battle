extends Node

@export var horse_scene: PackedScene
@export var lower_horse_scene: PackedScene
var HORIZONTAL_AMOUNT = 5


func _ready():
	var horse_locations = [$HorsePos/HorsePos1, $HorsePos/HorsePos2]

	# спавн НИЖНИХ рядов
	for horse_spawn in horse_locations:
		spawn_horse_row(lower_horse_scene, horse_spawn)
	
	# то же самое, только для ВЕРХНЕГО ряда
	spawn_horse_row(horse_scene, $HorsePos/HorsePos3)


func spawn_horse_row(horse_scene, spawn_node):
	var anim_delta = 4.0 / HORIZONTAL_AMOUNT
	for i in range(HORIZONTAL_AMOUNT):
		var bullet = horse_scene.instantiate()
		bullet.position = spawn_node.global_position
		spawn_node.add_child(bullet)
		var player = bullet.get_node("AnimationPlayer")
		player.seek(anim_delta * i)
	
