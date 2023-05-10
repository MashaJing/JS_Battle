extends Area2D

onready var HeadBullet = preload("res://Attacks/Phase2/BestAttack/PipisAttack/Pipis/SpamHeadBullet/SpamHeadBullet.tscn")


func _ready():
	pass

func _on_ExplosionTimer_timeout():
	$AnimatedSprite.queue_free()
	var Bullet
	var angle = 0
	for i in range(10):
		Bullet = HeadBullet.instance()
		angle = PI/5 * i
		Bullet.direction = Vector2(cos(angle), sin(angle))
		add_child(Bullet)
