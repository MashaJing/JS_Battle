extends Node2D
const HeadShot = preload("res://Bullets/HeadShots/HeadShot.tscn")


func _ready():
	$SpawnHeadsPath/RandomSpawnPath.Bullet = HeadShot


func _on_SpawnHeadTimer_timeout():
	$SpawnHeadsPath/RandomSpawnPath.spawn()
