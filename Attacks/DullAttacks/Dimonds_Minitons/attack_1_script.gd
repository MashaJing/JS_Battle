extends Node

@export var bullet_scene: PackedScene
@export var bullet_scene_2: PackedScene

signal attack_ended


func _ready():
	pass


func _on_BulletSpawnTimer_timeout():
	var dimond_spawn_location = $DimondPath/DimondSpawnLocation
	dimond_spawn_location.progress_ratio = randf()
	var bullet = bullet_scene.instantiate()
	bullet.ttl = 1
	add_child(bullet)
	bullet.position = dimond_spawn_location.position


func _on_AttackTimer_timeout():
	emit_signal("attack_ended")


func _on_MinitonTimer_timeout():
	var bullet = bullet_scene_2.instantiate()
	$MinitonPath.add_child(bullet)
