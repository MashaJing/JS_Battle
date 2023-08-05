extends Node2D
export (PackedScene) var Bullet
export var bullet_scale = 1.0
export var healer = 'JEVIL'


func start_spawn():
	$SpawnTimer.start()


func stop_spawn():
	$SpawnTimer.stop()


func _on_SpawnTimer_timeout():
	var bullet = Bullet.instance()
	if healer != null:
		bullet.healer = healer
	bullet.scale *= bullet_scale
	add_child(bullet)
