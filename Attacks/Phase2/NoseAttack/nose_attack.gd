extends Node2D

signal attack_ended

export var APPEAR_TIME = 2.6
export var EYES_TIME = 2.5
export (PackedScene) var JEVIL_BULLET
# todo: запилить какую-то анимацию, которая предупредит
# о дамаге от носа, щас выглядит безобидно
onready var Ray = preload("res://Bullets/ray/Ray.tscn")
onready var eyes = [$eyeL, $eyeR]
onready var RightJevilSpawns = [$JevilSpawns/Spawn2, $JevilSpawns/Spawn4, $JevilSpawns/Spawn6]
onready var LeftJevilSpawns = [$JevilSpawns/Spawn1, $JevilSpawns/Spawn3, $JevilSpawns/Spawn5]
onready var JevilSpawns = [RightJevilSpawns, LeftJevilSpawns]
onready var appearTimer = $AppearTimer
onready var colors = [Color.yellow, Color.magenta]
onready var Jevil = preload("res://team_stats/Jevil/Jevil.tscn")
var side_ratio = 0


func _ready():
	# вынести к таймерам в скрипты?
	$AppearTimer.wait_time = APPEAR_TIME
	$EyeAttackTimer.wait_time = EYES_TIME

func _on_EyeAttackTimer_timeout():
	var ray = Ray.instance()
	var ind = randi() % 2
	ray.position = eyes[ind].position
	add_child(ray)
	ray.shoot(colors[ind])

func _on_AppearTimer_timeout():
	# с каждым запуском таймера сторона меняется
	var ind = side_ratio % 2
	spawn_jevil(ind)
	side_ratio +=1

func spawn_jevil(spawn_ind):
	var ind = randi() % 3
	var spawn = JevilSpawns[spawn_ind][ind]
	var jevil = Jevil.instance()
	# если спавн в какой-то из левых точек, Джев поворачивается по горизонтали
	if spawn_ind % 2 == 0:
		jevil.flipped = true
	jevil.global_position = spawn.global_position
	add_child(jevil)
	jevil.open_moth()
	yield(jevil.get_node("AnimationPlayer"), "animation_finished")
	spawn_bullet(spawn.global_position)
	jevil.close_moth()
	
func spawn_bullet(location):
	var dimond_bullet = JEVIL_BULLET.instance()
	dimond_bullet.global_position = location
	dimond_bullet.heart_position = $KinematicHeart.global_position
	add_child(dimond_bullet)


func _on_AttackTimer_timeout():
	emit_signal("attack_ended")
