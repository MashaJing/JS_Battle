extends Node2D

@export var heart_position = Vector2.ZERO
@export var SHOOT_ANGLE = 10
@export var N_BULLETS = 5
@export var BULLET: PackedScene

var bullet_default_class = preload('res://Bullets/bullet_dimond/Dimond.tscn')


func _ready():
	var bullet_class
	if BULLET == null:
		bullet_class = bullet_default_class
	else:
		bullet_class = BULLET
	print(bullet_class)
	var direction = (heart_position - global_position).normalized()
	var single_bullet_angle = 0
	for i in range(N_BULLETS):
		single_bullet_angle = deg_to_rad(SHOOT_ANGLE * i / (N_BULLETS - 1) - SHOOT_ANGLE/2) \
				+ direction.angle()
		var bullet = bullet_class.instantiate()
		bullet.direction =  Vector2(cos(single_bullet_angle), sin(single_bullet_angle)).normalized()
		bullet.set_rotation(single_bullet_angle + PI/2)
		bullet.speed = 300
		add_child(bullet)
