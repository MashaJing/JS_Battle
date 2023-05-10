extends Node2D

onready var MailBullet = preload("res://Attacks/Phase2/BestAttack/MailAttack/MailBullet/MailBullet.tscn")
onready var MailWindow = preload("res://Attacks/Phase2/BestAttack/MailAttack/MailWindow/MailWindow.tscn")
onready var BulletSpawn = [$BulletSpawn, $BulletSpawn2]

signal attack_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	var Window = MailWindow.instance()
	Window.global_position = $WindowSpawn.global_position
	add_child(Window)
	$MailTimer.start()

func _on_MailTimer_timeout():
	var Bullet = MailBullet.instance()
	Bullet.global_position = BulletSpawn[randi() % 2].global_position
	add_child(Bullet)

func _on_SpawnTimer_timeout():
	# останавливаем спавн писем
	$MailTimer.stop()
	# окно закрывается
	get_node("MailWindow").close()
	yield(get_node("MailWindow/AnimationPlayer"), "animation_finished")
	get_node("MailWindow").queue_free()
	# посылаем сигнал в сцену всей атаки	
	emit_signal("attack_ended")
	$AnimationPlayer.play("clear_box")
	yield(get_node("AnimationPlayer"), "animation_finished")
	# ответственность за высвобождение ресурсов лежит на сцене атаки
	queue_free()
