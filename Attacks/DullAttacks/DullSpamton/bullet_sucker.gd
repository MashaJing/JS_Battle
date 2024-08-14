extends Node2D
@export var suck_speed = 1
@export var suck_activated = 0
var time = 0

func activate():
	suck_activated = 1

func deactivate():
	suck_activated = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	suck_speed = time * suck_activated * 100
