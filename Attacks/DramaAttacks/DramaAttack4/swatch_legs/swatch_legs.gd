extends Node

onready var Anim = $AnimatedSprite
var hor_speed = 200
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Anim.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x += delta * hor_speed
