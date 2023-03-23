extends Area2D

var time = 0
var G = 300
var amplitude_x = 150
var amplitude_y = 90
var l = sqrt(amplitude_x * amplitude_x + amplitude_y * amplitude_y)

var spread_waves_freq = 0
var pendulum_angle = deg2rad(45)

var omega = sqrt(G / l)

# нужен для крепления к проводу
var pos_ex = self.position

func _ready():
	$AnimatedSprite.play("default")

func _process(delta):
	pos_ex = self.position

	time += delta
	# вращение + спавн пуль
	rotate(0.025 * cos(time * omega))

	# движение маятника
	self.position.x = amplitude_x * sin(time * omega - PI/2)
	self.position.y =  - amplitude_y * abs(sin(time * omega - PI/2))
