extends Node2D

signal attack_ended

@export var mode = 0
@export var APPEAR_TIME = 2.6
@export var EYES_TIME = 2.5
@export var JEVIL_BULLET: PackedScene
# todo: запилить какую-то анимацию, которая предупредит
# о дамаге от носа, щас выглядит безобидно
@onready var Ray = preload("res://Bullets/ray/Ray.tscn")
@onready var DiamondsBatch = preload("res://Bullets/DimondsBatch/DimondsBatch.tscn")
@onready var DiamondSingle = preload("res://Bullets/WhiteDimond/WhiteDimond.tscn")
@onready var eyes = [$eyeL, $eyeR]
@onready var RightJevilSpawns = [$JevilSpawns/Spawn2, $JevilSpawns/Spawn4, $JevilSpawns/Spawn6]
@onready var LeftJevilSpawns = [$JevilSpawns/Spawn1, $JevilSpawns/Spawn3, $JevilSpawns/Spawn5]
@onready var JevilSpawns = [RightJevilSpawns, LeftJevilSpawns]
@onready var appearTimer = $AppearTimer
@onready var colors = [Color.YELLOW, Color.MAGENTA]
@onready var Jevil = preload("res://Characters/Jevil/Jevil.tscn")
var side_ratio = 0


func _ready():
	match mode:
		0:
			APPEAR_TIME = 2.6
			EYES_TIME = 2.6
			JEVIL_BULLET = DiamondsBatch
		1:
			APPEAR_TIME = 1.6
			EYES_TIME = 2.6
			JEVIL_BULLET = DiamondSingle
	# вынести к таймерам в скрипты?
	$AppearTimer.wait_time = APPEAR_TIME
	$EyeAttackTimer.wait_time = EYES_TIME

func _on_EyeAttackTimer_timeout():
	var ray = Ray.instantiate()
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
	var jevil = Jevil.instantiate()
	# если спавн в какой-то из левых точек, Джев поворачивается по горизонтали
	if spawn_ind % 2 == 0:
		jevil.get_node("AnimatedSpriteController/AnimatedSprite2D").flip_h = true

	jevil.global_position = spawn.global_position
	add_child(jevil)
	jevil.get_node("AnimationPlayer").play("open_moth")
	await jevil.get_node("AnimationPlayer").animation_finished
	spawn_bullet(spawn.global_position)
	jevil.get_node("AnimationPlayer").play("close_moth")
	await jevil.get_node("AnimationPlayer").animation_finished
	jevil.get_node("AnimationPlayer").play("Hide")
	await jevil.get_node("AnimationPlayer").animation_finished
	jevil.queue_free()

func spawn_bullet(location):
	var dimond_bullet = JEVIL_BULLET.instantiate()
	dimond_bullet.global_position = location
	dimond_bullet.heart_position = $KinematicHeart.global_position
	add_child(dimond_bullet)


func _on_AttackTimer_timeout():
	print('emited attack ended signal!')
	emit_signal("attack_ended")
