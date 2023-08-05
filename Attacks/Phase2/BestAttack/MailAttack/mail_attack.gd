extends Node2D

onready var MailBullet = preload("res://Attacks/Phase2/BestAttack/MailAttack/MailBullet/MailBullet.tscn")
onready var MailWindow = preload("res://Attacks/Phase2/BestAttack/MailAttack/MailWindow/MailWindow.tscn")
var windows = []

signal attack_ended


func _ready():
	$SpamtonAnimationPlayer.play("appear")
	yield($SpamtonAnimationPlayer, "animation_finished")
	$SpamtonAnimationPlayer.play("window_attack_begin")

func _on_MailTimer_timeout():
	$WindowSpawn/RandomSpawnPath.spawn()
	$WindowSpawn2/RandomSpawnPath2.spawn()

func _on_SpawnTimer_timeout():
	# останавливаем спавн писем
	$MailTimer.stop()
	# Спам уходит
	$SpamtonAnimationPlayer.play_backwards("appear")
	# окна закрываются
	for window in windows:
		window.close()
		window.queue_free()
	# посылаем сигнал в сцену всей атаки
	emit_signal("attack_ended")


func start_attack():
	$MailTimer.start()
	$SpawnTimer.start()

func open_windows():
	spawn_window($WindowSpawn.global_position)
	spawn_window($WindowSpawn2.global_position)

func spawn_window(spawn_position):
	var Window = MailWindow.instance()
	Window.global_position = spawn_position
	add_child(Window)
	windows.append(Window)	
