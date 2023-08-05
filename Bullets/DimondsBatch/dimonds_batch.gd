extends Node2D

export var heart_position = Vector2.ZERO
export var SHOOT_ANGLE = 10
export var N_BULLETS = 5
export (PackedScene) var BULLET
var bul = preload('res://Bullets/bullet_dimond/Dimond.tscn')


func _ready():
	if BULLET != null:
		bul = BULLET
	var direction = (heart_position - global_position).normalized()
	var angle = 0
	for i in range(N_BULLETS):
		angle = deg2rad(SHOOT_ANGLE * i / (N_BULLETS - 1) - SHOOT_ANGLE/2) + direction.angle()
		var bullet = bul.instance()
		bullet.direction =  Vector2(cos(angle), sin(angle)).normalized()
		bullet.set_rotation(angle + PI/2)
		bullet.speed = 300
		add_child(bullet)
