extends Area2D
var speed_x = 50
var speed_y = 0


func _ready():
	$AnimatedSprite.play("default")
	var time_before_fall = randi() % 3 + 1
	$Timer.wait_time = time_before_fall
	$Timer.start()


func _process(delta):
	position.x += speed_x * delta
	position.y += speed_y * delta


func _on_Timer_timeout():
	$AnimatedSprite.play("fly")
	speed_x = 0
	speed_y = 250
