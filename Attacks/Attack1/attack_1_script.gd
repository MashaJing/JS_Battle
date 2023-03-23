extends Node

export (PackedScene) var bullet_scene
export (PackedScene) var bullet_scene_2


func _ready():
	var timer = get_node("BulletSpawnTimer")

func _on_BulletSpawnTimer_timeout():
	var dimond_spawn_location = $DimondPath/DimondSpawnLocation
	var dollar_spawn_location = $DollarPath/DollarSpawnLocation
	dimond_spawn_location.unit_offset = randf()
	dollar_spawn_location.unit_offset = randf()
	var bullet = bullet_scene.instance()
	var bullet_2 = bullet_scene_2.instance()
	add_child(bullet)
	add_child(bullet_2)

	bullet.position = dimond_spawn_location.position
	bullet_2.position = dollar_spawn_location.position
