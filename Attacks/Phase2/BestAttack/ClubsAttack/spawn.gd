extends Node2D

export var enabled = true
onready var ClubBullet = preload("res://Bullets/bullet_dimond/Dimond.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_bullet(parent):
	if enabled:
		var Bullet = ClubBullet.instance()
		Bullet.direction = Vector2.LEFT
		Bullet.speed = 300
		Bullet.global_position = self.global_position
		parent.add_child(Bullet)
		
