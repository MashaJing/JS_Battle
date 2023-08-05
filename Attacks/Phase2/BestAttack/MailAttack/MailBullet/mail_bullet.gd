extends Area2D


var speed = randi() % 50
var time = 0
var GRABVITY = 4
var ttl = 4


func _ready():
	z_index = randi() % 2

func _process(delta):
	time += delta
	position.x += speed * delta
	position.y += GRABVITY * time * time

