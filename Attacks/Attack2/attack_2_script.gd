extends Node

export (PackedScene) var bullet_scene
export (PackedScene) var bullet_scene_2


func _ready():
	var window_spawn_locations = $BorderField/SpawnWindowsPos.get_children()
	for window_spawn in window_spawn_locations:
		var bullet = bullet_scene_2.instance()
		add_child(bullet)
		bullet.position = window_spawn.global_position
		yield(get_tree().create_timer(0.1), "timeout")

func _on_BulletSpawnTimer_timeout():
	var heart_spawn_location = $HeartPath/HeartSpawnLocation
	heart_spawn_location.unit_offset = randf()
	var bullet = bullet_scene.instance()
	add_child(bullet)

	bullet.position = heart_spawn_location.position
