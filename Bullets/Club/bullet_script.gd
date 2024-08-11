extends Area2D

var angle_increase_speed = PI
var radius = Vector2(10.0, 15.0)
var direction = Vector2.ZERO

var angle = 0.0
var time = 0
var speed = 300
@onready var start_position = position
@onready var previous_position = start_position



func _process(delta):
	rotate(.05)
	#time+=delta
	pass
	#$AnimationPlayer.play("appear")
	#time += delta
	#position = direction * speed * time
	#angle = wrapf(angle + angle_increase_speed * delta, 0.0, 2 * PI)
	#var direction = Vector2(cos(angle), sin(2*angle))
	
	#previous_position = position
	#position = start_position + direction * radius
	#rotation = (position - previous_position).angle()
