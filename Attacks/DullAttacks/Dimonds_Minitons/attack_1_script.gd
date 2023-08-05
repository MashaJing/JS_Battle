extends Node

export (PackedScene) var bullet_scene
export (PackedScene) var bullet_scene_2

signal attack_ended


func _ready():
	pass


func _on_BulletSpawnTimer_timeout():
	var dimond_spawn_location = $DimondPath/DimondSpawnLocation
	dimond_spawn_location.unit_offset = randf()
	var bullet = bullet_scene.instance()
	bullet.ttl = 1
	add_child(bullet)

	bullet.position = dimond_spawn_location.position


func _on_AttackTimer_timeout():
	emit_signal("attack_ended")


func _on_MinitonTimer_timeout():
	var bullet = bullet_scene_2.instance()
	$MinitonPath.add_child(bullet)
