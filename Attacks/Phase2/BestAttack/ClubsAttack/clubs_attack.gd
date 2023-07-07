extends Node2D

onready var ClubsSpawns = $Spawns
var n = 4
onready var Spawns = $Spawns.get_children()
signal attack_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	for disabled_row in range(n - 1):
		# заполняем пространство в прошлом ряду
		Spawns[disabled_row].enabled = false
		yield($ChangeRowTimer, "timeout")
		Spawns[disabled_row + 1].enabled = false
		# полсекунды на переход игрока в другой ряд
		yield(get_tree().create_timer(0.5), "timeout")
		# заполняем пространство в прошлом ряду
		Spawns[disabled_row].enabled = true
	
	# обрабатываем последний ряд
	yield($ChangeRowTimer, "timeout")	
	Spawns[n - 1].enabled = false
	yield(get_tree().create_timer(0.5), "timeout")
	Spawns[n - 2].enabled = true
	yield($ChangeRowTimer, "timeout")	
	$ChangeRowTimer.stop()
	Spawns = []
	# дождёмся, пока пройдут
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("attack_ended")
	queue_free()


func _on_SpawnTimer_timeout():
	for spawn in Spawns:
		spawn.spawn_bullet(self)
