extends Node2D

export var APPEAR_TIME = 2.6
export var EYES_TIME = 2.5
export (PackedScene) var JEVIL_BULLET
# todo: запилить какую-то анимацию, которая предупредит
# о дамаге от носа, щас выглядит безобидно
onready var Ray = preload("res://Bullets/ray/Ray.tscn")
onready var eyes = [$eyeL, $eyeR]
onready var JevilSpawns = $JevilSpawns.get_children()
onready var appearTimer = $AppearTimer
onready var colors = [Color.yellow, Color.magenta]
onready var Jevil = preload("res://team_stats/Jevil/Jevil.tscn")


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
	var ind = randi() % len(JevilSpawns)
	var spawn = JevilSpawns[ind]
	var jevil = Jevil.instance()
	var dimond_bullet = JEVIL_BULLET.instance()

	# если спавн в какой-то из левых точек, поворачивается по горизонтали
	if ind < 3:
		jevil.flipped = true
	jevil.global_position = spawn.global_position
	dimond_bullet.global_position = spawn.global_position
	dimond_bullet.heart_position = $KinematicHeart.global_position
	add_child(jevil)
	# надо как-то дождаться именно того момента, когда он откроет рот:
	# послать спец сигнал или распилить анимацию?
	add_child(dimond_bullet)
	jevil.spit_bullet()
