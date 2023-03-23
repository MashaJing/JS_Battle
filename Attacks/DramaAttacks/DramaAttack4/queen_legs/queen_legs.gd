extends Node

onready var AnimPlayer = $Leg/AnimationPlayer
onready var AnimPlayer2 = $Leg2/AnimationPlayer
var hor_speed = -100


func _ready():
	# что с коллизией
	AnimPlayer.play("walk")
	AnimPlayer2.play("walk")


func _process(delta):
	self.position.x += delta * hor_speed
