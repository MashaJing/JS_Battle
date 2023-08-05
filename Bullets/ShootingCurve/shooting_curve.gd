extends PathFollow2D

export (PackedScene) var BULLET
export var SPAWN_DELAY = 0.1
export var SHOOT_DELAY = 0.1
export var N_BULLETS = 10
var spawned_bullets = []

# не факт, что так можно использовать
func _ready():
	$SpawnDelayTimer.wait_time = SPAWN_DELAY
	$ShootTimer.wait_time = SHOOT_DELAY


func shoot():
	$SpawnDelayTimer.start()
	for bullet in spawned_bullets:
		# имплементировать для каждой отдельно?
		bullet.move_with_acceleration()
		yield($ShootTimer, "timeout")
	$SpawnDelayTimer.stop()


func spawn():
	var bullets_offset = 1.0/N_BULLETS
	for i in range(N_BULLETS):
		unit_offset+=bullets_offset
		var bullet = BULLET.instance()
		bullet.global_position = self.global_position
		get_parent().get_parent().add_child(bullet)
		spawned_bullets.append(bullet)


func spawn_with_delay():
	var bullets_offset = 1.0/N_BULLETS
	$SpawnDelayTimer.start()
	for i in range(N_BULLETS):
		unit_offset+=bullets_offset
		var bullet = BULLET.instance()
		bullet.global_position = self.global_position
		get_parent().get_parent().add_child(bullet)
		yield($SpawnDelayTimer, "timeout")
	$SpawnDelayTimer.stop()
