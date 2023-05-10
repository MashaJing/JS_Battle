extends Node2D

onready var Ray = preload("res://Bullets/ray/Ray.tscn")
onready var eyes = [$eyeL, $eyeR]
onready var JevilSpawns = $JevilSpawns.get_children()
onready var appearTimer = $AppearTimer
onready var colors = [Color.yellow, Color.magenta]
onready var Jevil = preload("res://team_stats/Jevil/Jevil.tscn")
onready var DimondBullet = preload("res://Bullets/WhiteDimond/WhiteDimond.tscn")
	

func _on_EyeAttackTimer_timeout():
	var ray = Ray.instance()
	print('added ray')
	var ind = randi() % 2
	ray.position = eyes[ind].position
	add_child(ray)
	ray.shoot(colors[ind])


func _on_AppearTimer_timeout():
	print('spawned jevil!!!')
	var ind = randi() % len(JevilSpawns)
	var spawn = JevilSpawns[ind]
	var jevil = Jevil.instance()
	var dimond_bullet = DimondBullet.instance()
	if ind < 3:
		jevil.flipped = true
	jevil.global_position = spawn.global_position
	dimond_bullet.global_position = spawn.global_position
	dimond_bullet.heart_position = $Heart.global_position
	add_child(jevil)
	# надо как-то дождаться именно того момента, когда он откроет рот: послать спец сигнал или распилить анимацию?
	add_child(dimond_bullet)
	jevil.spit_bullet()
