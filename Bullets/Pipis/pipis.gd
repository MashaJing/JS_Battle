extends Area2D

onready var HeadBullet = preload("res://Bullets/Pipis/SpamHeadBullet/SpamHeadBullet.tscn")

var direction = Vector2.DOWN
var time = 0
var speed = 1
var ttl = 7
var G = 0
export var N = 10
var damaged = false


func _ready():
	$LiveTimer.wait_time = ttl
	$LiveTimer.start()
	
func _on_ExplosionTimer_timeout():
	$AnimatedSprite.queue_free()
	$CollisionShape2D.queue_free()
	var Bullet
	var angle = 0
	for i in range(N):
		Bullet = HeadBullet.instance()
		Bullet.damaged = self.damaged
		angle = PI/5 * i
		Bullet.direction = speed * Vector2(cos(angle), sin(angle))
		add_child(Bullet)

func _process(delta):
	time += delta
	position += 2 * delta * G * direction

func _on_LiveTimer_timeout():
	$ExplosionTimer.stop()
	queue_free()
