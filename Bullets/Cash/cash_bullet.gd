extends Area2D

var time = 0

var amplitude_x = 5
var amplitude_y = 5
var G = 200

@onready var sprites = [
	preload("res://Bullets/Cash/Assets/money1.png"),
	preload("res://Bullets/Cash/Assets/money2.png"),
	preload("res://Bullets/Cash/Assets/money3.png")
]
var l = sqrt(amplitude_x * amplitude_x + amplitude_y * amplitude_y)
var omega = sqrt(G / l)



func _ready():
	$Sprite2D.texture = sprites[randi() % len(sprites)]
	amplitude_x = randi() % 7


func _process(delta):
	time += delta
	rotate(0.025 * cos(time * omega))

	# движение маятника
	self.position.x += amplitude_x * cos(omega * time - PI/2)
	self.global_position.y += delta * abs(cos(omega * time - PI/2)) * 100


func _on_TTL_timeout():
	queue_free()
