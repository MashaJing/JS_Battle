extends Node2D
const Pipis = preload("res://Bullets/Pipis/Pipis.tscn")


func _on_SpawnPipisTimer_timeout():
	var Bullet = Pipis.instance()
	Bullet.damaged = true
	Bullet.N = 13
	Bullet.ttl = 5
	$PipisSpawnPath/RandomSpawnPath.spawn_instance(Bullet)
